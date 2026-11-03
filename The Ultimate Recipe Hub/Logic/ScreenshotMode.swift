//
//  ScreenshotMode.swift
//  The Ultimate Recipe Hub
//
//  App Store screenshot mode (Debug builds only).
//
//  Turn on:  Xcode › Product › Scheme › Edit Scheme… › Run › Arguments › "Arguments Passed On Launch"
//            › add  -screenshotMode  (tick it)
//  Turn off: untick the argument. In Release builds `isOn` is always false and the plan code isn't compiled.
//
//  What it does:
//  - today's meal plan is filled with the six screenshot recipes, in memory only (nothing is saved);
//  - the Recipes page shows the collections and first cards in `recipesOrder` (in memory; Collections.json
//    is untouched); the "Your Recipes" row shows `savedRecipes` (app recipes, in place of saved links);
//    the banner carousel drops "Save a restaurant" and rests on "Save It. Cook It. Love It!";
//  - no onboarding, and recipe pages have no "Add to meal plan" footer;
//  - the app acts as Pro, so macros show numbers and nothing is locked;
//  - the Plan page hides the tab bar and skips the first-time meal plan sheet.
//
//  Capture (iPhone 17 Pro Max simulator, light mode):
//  1. xcrun simctl status_bar booted override --time 9:41 --batteryState charged \
//        --batteryLevel 100 --cellularBars 4 --wifiBars 3
//  2. Run with -screenshotMode, open Meal Plan, scroll to the top.
//  3. Cmd+S in the simulator → full-resolution 1320×2868 PNG on the Desktop.
//

import SwiftUI

enum ScreenshotMode {

    /// True when a Debug build was launched with -screenshotMode. Always false in Release.
    static var isOn: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-screenshotMode")
        #else
        return false
        #endif
    }

    /// Its own switch, separate from -screenshotMode: launching with -hideRecipesBanner (Debug only) sets up the
    /// Recipes page for a screenshot: no sliding banner, one-line and slightly larger recipe names, collections
    /// closer together. Always false in Release.
    static var hidesRecipesBanner: Bool {
        #if DEBUG
        return ProcessInfo.processInfo.arguments.contains("-hideRecipesBanner")
        #else
        return false
        #endif
    }

    /// A plan card's height: 240 normally; 226 in screenshot mode, where the name is one line and sits closer.
    static var cardHeight: CGFloat { isOn ? 226 : 240 }

    /// Plan cards (170 × 240) scaled so two fill the screen's width in the capture; 1 in normal runs.
    /// The width left for a row: the screen less the day card's margins (10 + 22 a side) and the 20 pt gap.
    static var cardScale: CGFloat {
        guard isOn else { return 1 }
        let width = UIScreen.main.bounds.width - 2 * (10 + 22) - 20
        return max(1, width / (2 * 170))
    }

    #if DEBUG
    /// The six meals for the App Store Meal Plan screenshot, one per slot (main and side for each meal).
    /// By recipe id, so a renamed title can't break it.
    static let mealPlan: [(slot: MealSlot.MealType, recipeID: String)] = [
        (.breakfast,     "00000000aa_14"), // Fried Eggs with Balsamic
        (.sideBreakfast, "00000000ee_2"),  // Nutritious Green Smoothie
        (.lunch,         "000000000b_0"),  // Roasted & Raw Vegetables With Spicy Tahini Cream
        (.sideLunch,     "0000000089_5"),  // Vegetable and Glass Noodle Salad
        (.dinner,        "000000017b_0"),  // Red Lentil Soup
        (.sideDinner,    "00000000a8_40"), // Roasted Sweet Potatoes with Merguez, Persimmon, and Za'atar Yogurt
    ]

    /// Recipes page order for the App Store screenshot: these collections first, in this order (the rest follow
    /// in their usual order), each opening with these recipes (the rest of its recipes follow, no duplicates).
    /// Matched by title, ignoring case and accents.
    static let recipesOrder: [(collection: String, firstRecipes: [String])] = [
        ("Quick & Easy", [
            "Avocado, Feta, and Mint on Sourdough Toast",
            "Orzo Salad with Green Beans, Tomatoes, Feta & Mint",
            "Vegan Banana Pancakes",
        ]),
        ("Healthy Salad", [
            "Mediterranean Quinoa Bowl",
            "Asparagus & Cannellini Beans",
            "Peach & Tomato Salad With Fish Sauce Vinaigrette",
        ]),
        ("Pasta Paradise", [
            "Creamy Pesto Chicken Pasta",
            "Pasta with Cherry Tomato Sauce",
            "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
        ]),
        ("Essentials of Asia", [
            "Honey Teriyaki Salmon",
            "Kung Pao Tofu",
            "Vegetable and Glass Noodle Salad",
        ]),
    ]

    /// The Recipes page collections in `recipesOrder`. Returns them unchanged when screenshot mode is off.
    /// A title that isn't found is printed and skipped.
    static func orderedCollections(_ collections: [RecipeCollection]) -> [RecipeCollection] {
        guard isOn else { return collections }
        var rest = collections
        var front: [RecipeCollection] = []
        for entry in recipesOrder {
            guard let index = rest.firstIndex(where: { sameTitle($0.name, entry.collection) }) else {
                print("ScreenshotMode: not found → \(entry.collection)")
                continue
            }
            front.append(withFirstRecipes(entry.firstRecipes, in: rest.remove(at: index)))
        }
        return front + rest
    }

    /// The "Your Recipes" row (saved links) in screenshot mode: these app recipes instead, in this order.
    /// Matched by title, ignoring case and accents.
    static let savedRecipes: [String] = [
        "Fall Salad With Lemony Brown Butter Vinaigrette",
        "Baked Salmon With Brown-Buttered Tomatoes & Basil",
        "Classic Ratatouille",
    ]

    /// `savedRecipes` as recipes, worked out once. Empty when screenshot mode is off; a title that isn't
    /// found is printed and skipped.
    static let savedRecipeModels: [ProcessedRecipe] = {
        guard isOn else { return [] }
        let manager = RecipeCollectionManager.shared
        let collections = (manager.collectionsResponse?.collections ?? [])
            + (manager.popularCollectionsResponse?.collections ?? [])
        var seen = Set<String>()
        let ids = collections.flatMap { $0.recipes }.filter { seen.insert($0).inserted }
        return savedRecipes.compactMap { title in
            for id in ids {
                if let recipe = RecipeSourceManager.shared.findRecipe(byID: id), sameTitle(recipe.recipe.name, title) {
                    return recipe
                }
            }
            print("ScreenshotMode: not found → \(title)")
            return nil
        }
    }()

    /// The collection with these recipes first, in its preview row (the cards on the Recipes page) and in its
    /// full list ("See all"); everything else keeps its order after them.
    private static func withFirstRecipes(_ titles: [String], in collection: RecipeCollection) -> RecipeCollection {
        let pool = collection.previews + collection.recipes.filter { !collection.previews.contains($0) }
        var pinned: [String] = []
        for title in titles {
            let match = pool.first { id in
                guard let recipe = RecipeSourceManager.shared.findRecipe(byID: id) else { return false }
                return sameTitle(recipe.recipe.name, title)
            }
            guard let id = match else {
                print("ScreenshotMode: not found → \(title)")
                continue
            }
            if !pinned.contains(id) { pinned.append(id) }
        }
        return RecipeCollection(
            id: collection.id,
            name: collection.name,
            entries: collection.entries,
            recipes: pinned + collection.recipes.filter { !pinned.contains($0) },
            previews: pinned + collection.previews.filter { !pinned.contains($0) }
        )
    }

    private static func sameTitle(_ a: String, _ b: String) -> Bool {
        a.compare(b, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    }

    /// Fills today's plan with the screenshot meals and their day totals. In memory only: the saved plan
    /// is untouched (until something else in the app saves the plan). Prints any recipe it can't find.
    static func applyMealPlan(to manager: MealPlanManager) {
        guard isOn, var plan = manager.currentWeeklyPlan else { return }
        guard let index = plan.dailyMeals.firstIndex(where: { Calendar.current.isDateInToday($0.date) }) else {
            print("ScreenshotMode: today isn't in the current weekly plan")
            return
        }

        var day = plan.dailyMeals[index]
        for entry in mealPlan {
            guard let recipe = RecipeSourceManager.shared.findRecipe(byID: entry.recipeID) else {
                print("ScreenshotMode: recipe not found → \(entry.recipeID)")
                continue
            }
            let meal = MealEntry(meal: recipe)
            switch entry.slot {
            case .breakfast:     day.breakfast = meal
            case .sideBreakfast: day.sideBreakfast = meal
            case .lunch:         day.lunch = meal
            case .sideLunch:     day.sideLunch = meal
            case .dinner:        day.dinner = meal
            case .sideDinner:    day.sideDinner = meal
            }
        }

        // The day's totals, as the app works them out when a meal is added
        let meals = [day.breakfast, day.sideBreakfast, day.lunch, day.sideLunch, day.dinner, day.sideDinner]
            .compactMap { $0 }
        day.calories = meals.reduce(0) { $0 + $1.meal.recipe.calories }
        day.macros = Macros(
            carbs: meals.reduce(0) { $0 + $1.meal.recipe.macros.carbs },
            protein: meals.reduce(0) { $0 + $1.meal.recipe.macros.protein },
            fat: meals.reduce(0) { $0 + $1.meal.recipe.macros.fat }
        )

        plan.dailyMeals[index] = day
        manager.currentWeeklyPlan = plan
    }
    #endif
}

extension View {
    /// Screenshot mode only: a plan card (170 × 240) scaled by `ScreenshotMode.cardScale`, with its layout
    /// size following, so two cards fill the row. Normal runs and Release builds: the view as it is.
    @ViewBuilder
    func screenshotCardScale() -> some View {
        if ScreenshotMode.isOn {
            let scale = ScreenshotMode.cardScale
            self
                .scaleEffect(scale, anchor: .topLeading)
                .frame(width: 170 * scale, height: ScreenshotMode.cardHeight * scale, alignment: .topLeading)
        } else {
            self
        }
    }
}
