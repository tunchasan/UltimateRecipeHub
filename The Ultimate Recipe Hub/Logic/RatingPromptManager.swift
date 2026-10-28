//
//  RatingPromptManager.swift
//  The Ultimate Recipe Hub
//
//  Decides when to show Apple's rating prompt (1.3.1; fewer, better-timed repeat asks in 1.3.2).
//  Replaces the old "Do you enjoy" sheet.
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
/// Never from a button, at most once per app version and 60 days apart, only for people who have used the app
/// on 2+ different days, and never over the launch animation, a paywall, onboarding, the keyboard or Cooking Mode.
/// After an ask, the counted moments only count what happened since (2 more meals eaten, 3 more plan adds, 2 more
/// AI Coach swaps, 3 more recipes to groceries, 3 more favorites, 2 more water-goal days); Cooking Mode and a
/// ticked-off grocery list are always fresh. Apple also caps its prompt at 3 times a year per person and skips
/// people who already rated; the app can't tell whether it showed or what they tapped.
final class RatingPromptManager: ObservableObject {
    static let shared = RatingPromptManager()

    /// MainView shows Apple's prompt whenever this changes.
    @Published private(set) var requestCount = 0

    /// Where someone has finished what they were doing, so a waiting moment can ask.
    enum Pause {
        case leftRecipe, closedCookingMode, openedPlanPage, closedReplaceScreen, switchedTab
    }

    /// Days between asks. Apple shows its prompt at most 3 times in 365 days per person.
    private static let daysBetweenAsks = 60

    /// Testing: the "-RatingSkipLimits" launch argument (Edit Scheme > Run > Arguments) skips the 2-day,
    /// once-per-version and 60-day rules and the fresh-moment baselines (moments use their first-ask counts).
    /// "-RatingPretendLastAsk 61" acts as if the last ask was 61 days ago in an older version, with baselines
    /// taken at launch; it only changes what the app sees while running and saves nothing.
    /// Launch arguments only apply to runs from Xcode, never to TestFlight or App Store builds. Apple's prompt
    /// always shows in Xcode builds and never in TestFlight.
    #if DEBUG
    private static let skipLimitsForTesting = ProcessInfo.processInfo.arguments.contains("-RatingSkipLimits")
    private static let pretendDaysSinceAsk: Int? = {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-RatingPretendLastAsk"), i + 1 < args.count else { return nil }
        return Int(args[i + 1])
    }()
    #else
    private static let skipLimitsForTesting = false // release builds always follow every rule
    private static let pretendDaysSinceAsk: Int? = nil
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
        static let favoritesAdded = "rating.favoritesAdded"     // Int, every favorite added (1.3.2)
        static let baselines = "rating.baselines"               // [counter: value] at the last ask (1.3.2)
    }

    /// The counters a repeat ask compares with their values at the last ask.
    private enum Counter: String, CaseIterable {
        case eatenMeals, planAdds, aiCoachSwaps, groceryRecipes, favoritesAdded, waterGoalDays
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
    /// True while the app-open logo animation covers the screen. MainView turns it off when the animation ends.
    var isLaunchAnimationShowing = true
    /// Debug only: baselines taken at launch for "-RatingPretendLastAsk" when none are saved.
    private var pretendBaselines: [String: Int] = [:]

    private init() {
        // 1.3.2: people asked in 1.3.1 have no baselines yet. Start them from today, so their next ask also needs
        // a fresh moment instead of firing on the next small action.
        if defaults.object(forKey: Key.lastAskedDate) != nil, defaults.dictionary(forKey: Key.baselines) == nil {
            saveBaselines()
            log("baselines set for an ask before 1.3.2")
        }
        if Self.pretendDaysSinceAsk != nil {
            pretendBaselines = snapshot()
            log("pretending the last ask was \(Self.pretendDaysSinceAsk ?? 0) days ago")
        }
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
        guard enough(.eatenMeals, total: count, first: 2, more: 2) else { return }
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
        guard enough(.waterGoalDays, total: days, first: 2, more: 2) else { return }
        askSoon(stillTrue: stillMet)
    }

    // MARK: - Moments that wait for a pause

    /// A recipe was added to favorites; `total` includes it. The first ask counts once someone has 3 or more, so
    /// people who already had several before this update still count. Later asks need 3 favorites added since
    /// the last ask (adds, not the total, so removing favorites doesn't matter).
    func favoriteAdded(total: Int, stillFavorited: @escaping () -> Bool) {
        defaults.set(defaults.integer(forKey: Key.favoritesAdded) + 1, forKey: Key.favoritesAdded)
        log("favorite added: total \(total)")
        guard enough(.favoritesAdded, total: total, first: 3, more: 3) else { return }
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
        guard enough(.planAdds, total: count, first: 3, more: 3) else { return }
        wait(for: [.leftRecipe, .openedPlanPage, .closedReplaceScreen, .switchedTab]) { true }
    }

    /// An AI Coach swap was accepted on the comparison screen (Pro). The 1st can be someone trying the feature;
    /// the 2nd shows they like it, so it asks as soon as the comparison screen closes.
    private func aiCoachSwapAccepted() {
        let count = defaults.integer(forKey: Key.aiCoachSwaps) + 1
        defaults.set(count, forKey: Key.aiCoachSwaps)
        log("AI Coach swaps accepted: \(count)")
        guard enough(.aiCoachSwaps, total: count, first: 2, more: 2) else { return }
        wait(for: [.closedReplaceScreen, .switchedTab]) { true }
    }

    /// A recipe's ingredients went to the grocery list (Pro). Distinct recipes; the 3rd counts.
    func recipeSentToGroceries(recipeID: String) {
        let recipes = addToSet(Key.groceryRecipes, recipeID)
        log("recipes sent to groceries: \(recipes) distinct")
        guard enough(.groceryRecipes, total: recipes, first: 3, more: 3) else { return }
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
            self.saveBaselines()
            self.requestCount += 1
        }
        scheduled = work
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: work)
    }

    private func mayAsk() -> Bool {
        guard isScreenClear() else { log("not asking: something else is on screen"); return false }
        if Self.skipLimitsForTesting { return true }
        guard (defaults.stringArray(forKey: Key.daysUsed) ?? []).count >= 2 else { log("not asking: used on fewer than 2 days"); return false }
        // Pretending the last ask was in an older version, so the version rule doesn't block the test.
        guard Self.pretendDaysSinceAsk != nil || defaults.string(forKey: Key.lastAskedVersion) != Self.appVersion else {
            log("not asking: already asked in this version"); return false
        }
        if let last = lastAskedDate, Date().timeIntervalSince(last) < Double(Self.daysBetweenAsks) * 24 * 60 * 60 {
            log("not asking: asked less than \(Self.daysBetweenAsks) days ago")
            return false
        }
        return true
    }

    // MARK: - Fresh moments (1.3.2)

    /// Before any ask, a moment counts once `total` reaches `first` (as in 1.3.1). After an ask, its counter must
    /// have grown by `more` since that ask.
    private func enough(_ counter: Counter, total: Int, first: Int, more: Int) -> Bool {
        guard !Self.skipLimitsForTesting, let base = baselines?[counter.rawValue] else { return total >= first }
        let since = currentValue(counter) - base
        log("\(counter.rawValue): \(since) since the last ask, needs \(more)")
        return since >= more
    }

    private func currentValue(_ counter: Counter) -> Int {
        switch counter {
        case .eatenMeals: return (defaults.stringArray(forKey: Key.eatenMeals) ?? []).count
        case .waterGoalDays: return (defaults.stringArray(forKey: Key.waterGoalDays) ?? []).count
        case .groceryRecipes: return (defaults.stringArray(forKey: Key.groceryRecipes) ?? []).count
        case .planAdds: return defaults.integer(forKey: Key.planAdds)
        case .aiCoachSwaps: return defaults.integer(forKey: Key.aiCoachSwaps)
        case .favoritesAdded: return defaults.integer(forKey: Key.favoritesAdded)
        }
    }

    private func snapshot() -> [String: Int] {
        Dictionary(uniqueKeysWithValues: Counter.allCases.map { ($0.rawValue, currentValue($0)) })
    }

    private func saveBaselines() {
        defaults.set(snapshot(), forKey: Key.baselines)
    }

    /// The values at the last ask, or nil before the first ask.
    private var baselines: [String: Int]? {
        if let saved = defaults.dictionary(forKey: Key.baselines) as? [String: Int] { return saved }
        return Self.pretendDaysSinceAsk != nil ? pretendBaselines : nil
    }

    /// When the last ask was (or the pretend date while testing).
    private var lastAskedDate: Date? {
        if let days = Self.pretendDaysSinceAsk { return Date().addingTimeInterval(-Double(days) * 24 * 60 * 60) }
        return defaults.object(forKey: Key.lastAskedDate) as? Date
    }

    /// Nothing else is in the way: no launch animation, paywall, onboarding, keyboard or Cooking Mode.
    private func isScreenClear() -> Bool {
        let paywall = PaywallVisibilityManager.shared
        return !isLaunchAnimationShowing
            && !paywall.isVisible
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
