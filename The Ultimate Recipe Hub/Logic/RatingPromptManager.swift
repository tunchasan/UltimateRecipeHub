//
//  RatingPromptManager.swift
//  The Ultimate Recipe Hub
//
//  Decides when to show Apple's rating prompt (1.3.1). Replaces the old "Do you enjoy" sheet.
//

import SwiftUI
import UIKit

/// Asks for an App Store rating with Apple's own prompt, only right after something went well:
/// - Right away (after a 2 s check that it's still true): the 2nd meal marked eaten, Cooking Mode Done after
///   5+ minutes (once Cooking Mode has closed), a whole grocery list of 5+ items ticked off, the water goal met
///   on a 2nd day.
/// - At the next pause (going back from the recipe, opening the Plan page, closing the swap comparison screen,
///   switching tabs): a favorite added once there are 3+, the 3rd recipe added to the plan by hand, the 2nd
///   accepted AI Coach swap, the 3rd recipe sent to the grocery list.
/// Never from a button, at most once per app version and 2 weeks apart, only for people who have used the app
/// on 2+ different days, and never over a paywall, onboarding, the keyboard or Cooking Mode. Apple also caps
/// its prompt at 3 times a year per person and skips people who already rated.
final class RatingPromptManager: ObservableObject {
    static let shared = RatingPromptManager()

    /// MainView shows Apple's prompt whenever this changes.
    @Published private(set) var requestCount = 0

    /// Where someone has finished what they were doing, so a waiting moment can ask.
    enum Pause {
        case leftRecipe, closedCookingMode, openedPlanPage, closedReplaceScreen, switchedTab
    }

    /// Testing: the "-RatingSkipLimits" launch argument (Edit Scheme > Run > Arguments) skips the 2-day and
    /// once-per-version / 2-week rules. Launch arguments only apply to runs from Xcode, never to TestFlight or
    /// App Store builds. Apple's prompt always shows in Xcode builds and never in TestFlight.
    #if DEBUG
    private static let skipLimitsForTesting = ProcessInfo.processInfo.arguments.contains("-RatingSkipLimits")
    #else
    private static let skipLimitsForTesting = false // release builds always follow every rule
    #endif

    private enum Key {
        static let daysUsed = "rating.daysUsed"                 // [yyyy-MM-dd]
        static let lastAskedDate = "rating.lastAskedDate"       // Date
        static let lastAskedVersion = "rating.lastAskedVersion" // "1.3.1"
        static let eatenMeals = "rating.eatenMeals"             // ["yyyy-MM-dd|dinner"]
        static let waterGoalDays = "rating.waterGoalDays"       // [yyyy-MM-dd]
        static let planAdds = "rating.planAdds"                 // Int
        static let aiCoachSwaps = "rating.aiCoachSwaps"         // Int
        static let groceryRecipes = "rating.groceryRecipes"     // [recipe ID]
    }

    private struct Waiting {
        let pauses: Set<Pause>
        let stillTrue: () -> Bool
        let since: Date
    }

    private let defaults = UserDefaults.standard
    private var waiting: Waiting?
    private var scheduled: DispatchWorkItem?
    private var isKeyboardVisible = false
    private var isCookingModeOpen = false
    private var cookingStartedAt: Date?

    private init() {
        recordDayUsed()
        let center = NotificationCenter.default
        center.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main) { [weak self] _ in
            self?.recordDayUsed()
        }
        // Leaving the app drops a moment that was waiting for a pause, and anything about to ask.
        center.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main) { [weak self] _ in
            if self?.waiting != nil { self?.log("app left: waiting moment dropped") }
            self?.waiting = nil
            self?.scheduled?.cancel()
        }
        center.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] _ in
            self?.isKeyboardVisible = true
        }
        center.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] _ in
            self?.isKeyboardVisible = false
        }
    }

    // MARK: - Moments that ask right away

    /// A planned meal was just marked eaten. Counts distinct meals (day + slot), so toggling one meal doesn't
    /// add up; the 2nd one asks once they stop tapping for 2 s.
    func mealMarkedEaten(on date: Date, slot: String, stillEaten: @escaping () -> Bool) {
        let count = addToSet(Key.eatenMeals, "\(Self.dayString(date))|\(slot)")
        log("meal eaten: \(count) distinct")
        guard count >= 2 else { return }
        askSoon(stillTrue: stillEaten)
    }

    /// Cooking Mode opened.
    func cookingModeOpened() {
        isCookingModeOpen = true
        if cookingStartedAt == nil { cookingStartedAt = Date() } // keep the start if onAppear fires again (ingredients sheet)
    }

    /// Done tapped on the last step. Counts after 5+ minutes of clock time (the phone is often locked while
    /// cooking), and asks once Cooking Mode has closed.
    func cookingModeDone() {
        let seconds = cookingStartedAt.map { Int(Date().timeIntervalSince($0)) } ?? -1
        log("cooking done after \(seconds) s")
        guard let start = cookingStartedAt, Date().timeIntervalSince(start) >= 5 * 60 else { return }
        wait(for: [.closedCookingMode]) { true }
    }

    /// Cooking Mode closed (Done or Close).
    func cookingModeClosed() {
        isCookingModeOpen = false
        cookingStartedAt = nil
        pause(.closedCookingMode)
    }

    /// The grocery list changed (an item ticked, unticked or deleted). Asks when every item is ticked and there
    /// are at least 5: the end of a real shop.
    func groceryListChanged() {
        let items = GroceriesManager.shared.groceries
        let ticked = items.filter { $0.isChecked }.count
        log("grocery list: \(ticked)/\(items.count) ticked")
        guard Self.isGroceryListDone() else { return }
        askSoon(stillTrue: Self.isGroceryListDone)
    }

    /// The water progress changed. Asks on the 2nd distinct day the goal is met (Pro only, like the tracker).
    func waterProgressChanged(on date: Date, progress: CGFloat, goal: CGFloat, stillMet: @escaping () -> Bool) {
        guard goal > 0, progress >= goal - 0.001 else { return }
        // The day it was reached, so filling in two days' trackers in one sitting doesn't count twice.
        let days = addToSet(Key.waterGoalDays, Self.dayString(Date()))
        log("water goal met: \(days) distinct days")
        guard days >= 2 else { return }
        askSoon(stillTrue: stillMet)
    }

    // MARK: - Moments that wait for a pause

    /// A recipe was added to favorites; `total` includes it. Counts once someone has 3 or more, so people who
    /// already had several before this update still count.
    func favoriteAdded(total: Int, stillFavorited: @escaping () -> Bool) {
        log("favorite added: total \(total)")
        guard total >= 3 else { return }
        wait(for: [.leftRecipe, .switchedTab], stillTrue: stillFavorited)
    }

    /// A recipe the person chose went into the plan: picked by hand, or an AI Coach swap they accepted (which is
    /// also its own moment, below). "Plan day with AI Coach" and "Generate Plan for Week" fill many slots at once
    /// and never call this. Both moments can be ready at once; only one prompt shows.
    func recipeAddedToPlan(pickedByAICoach: Bool) {
        log("plan add, AI Coach swap: \(pickedByAICoach)")
        defer { if pickedByAICoach { aiCoachSwapAccepted() } }
        let count = defaults.integer(forKey: Key.planAdds) + 1
        defaults.set(count, forKey: Key.planAdds)
        log("plan adds chosen: \(count)")
        guard count >= 3 else { return }
        wait(for: [.leftRecipe, .openedPlanPage, .closedReplaceScreen, .switchedTab]) { true }
    }

    /// An AI Coach swap was accepted on the comparison screen (Pro). The 1st can be someone trying the feature;
    /// the 2nd shows they like it, so it asks as soon as the comparison screen closes.
    private func aiCoachSwapAccepted() {
        let count = defaults.integer(forKey: Key.aiCoachSwaps) + 1
        defaults.set(count, forKey: Key.aiCoachSwaps)
        log("AI Coach swaps accepted: \(count)")
        guard count >= 2 else { return }
        wait(for: [.closedReplaceScreen, .switchedTab]) { true }
    }

    /// A recipe's ingredients went to the grocery list (Pro). Distinct recipes; the 3rd counts.
    func recipeSentToGroceries(recipeID: String) {
        let recipes = addToSet(Key.groceryRecipes, recipeID)
        log("recipes sent to groceries: \(recipes) distinct")
        guard recipes >= 3 else { return }
        wait(for: [.leftRecipe, .switchedTab]) { true }
    }

    /// Someone finished what they were doing. A waiting moment asks about a second later.
    func pause(_ pause: Pause) {
        guard let waiting, waiting.pauses.contains(pause) else { return }
        log("pause \(pause) → checking the waiting moment")
        self.waiting = nil
        guard Date().timeIntervalSince(waiting.since) < 10 * 60 else { return }
        askSoon(after: 1, stillTrue: waiting.stillTrue)
    }

    // MARK: - Asking

    private func wait(for pauses: Set<Pause>, stillTrue: @escaping () -> Bool) {
        log("waiting for a pause: \(pauses)")
        waiting = Waiting(pauses: pauses, stillTrue: stillTrue, since: Date())
    }

    /// Asks after `delay` seconds if the moment is still true and every rule allows it. A newer moment replaces
    /// one that's about to ask, so a burst of taps asks once.
    private func askSoon(after delay: TimeInterval = 2, stillTrue: @escaping () -> Bool) {
        scheduled?.cancel()
        let work = DispatchWorkItem { [weak self] in
            guard let self else { return }
            guard stillTrue() else { self.log("not asking: the moment was undone"); return }
            guard self.mayAsk() else { return }
            self.log("ASKING for a rating")
            self.defaults.set(Date(), forKey: Key.lastAskedDate)
            self.defaults.set(Self.appVersion, forKey: Key.lastAskedVersion)
            self.requestCount += 1
        }
        scheduled = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    private func mayAsk() -> Bool {
        guard isScreenClear() else { log("not asking: something else is on screen"); return false }
        if Self.skipLimitsForTesting { return true }
        guard (defaults.stringArray(forKey: Key.daysUsed) ?? []).count >= 2 else { log("not asking: used on fewer than 2 days"); return false }
        guard defaults.string(forKey: Key.lastAskedVersion) != Self.appVersion else { log("not asking: already asked in this version"); return false }
        if let last = defaults.object(forKey: Key.lastAskedDate) as? Date,
           Date().timeIntervalSince(last) < 14 * 24 * 60 * 60 {
            log("not asking: asked less than 14 days ago")
            return false
        }
        return true
    }

    /// Nothing else is in the way: no paywall, onboarding, keyboard or Cooking Mode.
    private func isScreenClear() -> Bool {
        let paywall = PaywallVisibilityManager.shared
        return !paywall.isVisible
            && !paywall.isFullScreenVisible
            && User.shared.isOnBoardingCompleted
            && !isKeyboardVisible
            && !isCookingModeOpen
    }

    // MARK: - Helpers

    /// Debug-only console line, e.g. "[Rating] favorite added: total 3".
    private func log(_ message: String) {
        #if DEBUG
        print("[Rating] \(message)")
        #endif
    }

    private func recordDayUsed() {
        addToSet(Key.daysUsed, Self.dayString(Date()))
    }

    /// Adds `value` to a saved set and returns the set's size.
    @discardableResult
    private func addToSet(_ key: String, _ value: String) -> Int {
        var set = Set(defaults.stringArray(forKey: key) ?? [])
        set.insert(value)
        defaults.set(Array(set), forKey: key)
        return set.count
    }

    private static func isGroceryListDone() -> Bool {
        let items = GroceriesManager.shared.groceries
        return items.count >= 5 && items.allSatisfy(\.isChecked)
    }

    private static func dayString(_ date: Date) -> String {
        let parts = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }

    private static var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "?"
    }
}
