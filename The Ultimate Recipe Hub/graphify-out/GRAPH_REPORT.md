# Graph Report - The Ultimate Recipe Hub  (2026-11-11)

## Corpus Check
- 900 files · ~240,333 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1360 nodes · 3433 edges · 91 communities (57 shown, 34 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 358 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `3049d51d`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- RecipeDetailView
- IconButton
- RecipeIngredientsGridView
- String
- UnitsSetting
- SwiftUI
- .body
- CodingKeys
- GroceryPickerSheet
- MealPlanManager
- GroceriesView
- RatingPromptManager
- NewPaywallView.swift
- Color
- RecipeCard
- User
- PaywallTrigger
- FoodSensitivity
- NotificationManager
- SubscriptionManager.swift
- GroceriesManager
- String
- RecipeModel
- RoundedButton
- Text
- ExternalCollectionRecipeCard
- .body
- DailyMeals
- SavedRestaurantsView
- LaunchAnimationView
- View
- Text
- Array
- CategoryCollection
- GroceriesView.swift
- PreviewProvider
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- Goal
- .show
- SaveExternalSourceCardView
- SavedRecipesView
- .formatPrice
- .updateRecipe
- .body
- Foundation
- SafariView
- FavoritesView
- GroceryRow
- Bool
- PlanPageMenuButton
- MultipleSelectionRichButtonRed
- RateUsView
- MealSlot
- .body
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- .init
- RecipeCard.swift
- MealType
- .purchase
- CodingKeys
- CLAUDE.md
- NutritionalInfoView
- LoadingPlaceholder
- DifficultyType
- Tab
- .show

## God Nodes (most connected - your core abstractions)
1. `Text` - 100 edges
2. `GroceriesView` - 64 edges
3. `MealPlanManager` - 47 edges
4. `RecipeIngredientsGridView` - 44 edges
5. `GroceriesManager` - 43 edges
6. `UnitConverter` - 43 edges
7. `RatingPromptManager` - 40 edges
8. `CodingKeys` - 40 edges
9. `GroceryItem` - 38 edges
10. `MealSlot` - 33 edges

## Surprising Connections (you probably didn't know these)
- `.emptyArtAndTitle` --calls--> `Text`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/Text+ReadableFractions.swift
- `.visibleGroceries` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift
- `.hasCheckedItemsToToggle` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift
- `.recipeNamesOnList` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift
- `.progress` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift

## Import Cycles
- None detected.

## Communities (91 total, 34 thin omitted)

### Community 0 - "RecipeDetailView"
Cohesion: 0.23
Nodes (8): RecipeComparisonView, .body, RecipeDetailView, RecipeDetailView_Previews, ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - "RecipeIngredientsGridView"
Cohesion: 0.11
Nodes (19): ConversionNote, ConversionNoteView, .content, .linkTitle, IngredientLineBox, RecipeIngredientsGridView, .body, .conversionNote (+11 more)

### Community 3 - "String"
Cohesion: 0.22
Nodes (4): GroceryDisplay, GroceryFormatter, .display, RecipeAmount

### Community 4 - "UnitsSetting"
Cohesion: 0.12
Nodes (20): UnitsSetting, .activeSystem, automatic, .current, .id, metric, .regionSystem, .system (+12 more)

### Community 5 - "SwiftUI"
Cohesion: 0.08
Nodes (11): Kingfisher, OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingHealtyMealPage, .body, OnboardingMealPlanPage, .body, OnboardingPreferencesPage (+3 more)

### Community 6 - ".body"
Cohesion: 0.06
Nodes (18): FavoriteRecipesManager, .body, AddToMealPlanFooter, .body, .icon, .title, Style, add (+10 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (34): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+26 more)

### Community 9 - "GroceryPickerSheet"
Cohesion: 0.11
Nodes (13): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .scale, IngredientChecklist (+5 more)

### Community 11 - "GroceriesView"
Cohesion: 0.07
Nodes (25): recipes, GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem (+17 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.09
Nodes (20): Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays, Key (+12 more)

### Community 13 - "NewPaywallView.swift"
Cohesion: 0.22
Nodes (8): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, PaywallSelection, firstPackage, secondPackage, thirdPackage

### Community 14 - "Color"
Cohesion: 0.19
Nodes (16): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+8 more)

### Community 15 - "RecipeCard"
Cohesion: 0.20
Nodes (5): DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body

### Community 17 - "PaywallTrigger"
Cohesion: 0.10
Nodes (18): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+10 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.13
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "SubscriptionManager.swift"
Cohesion: 0.22
Nodes (4): RevenueCat, StoreKit, UltimateRecipeHub, .body

### Community 21 - "GroceriesManager"
Cohesion: 0.14
Nodes (7): groceries, GroceriesManager, .freeSlotsLeft, GroceryItem, .editableText, .allCheckedView, .body

### Community 22 - "String"
Cohesion: 0.08
Nodes (15): HydrationMessageManager, CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection, RecipeCollectionsResponse, String (+7 more)

### Community 23 - "RecipeModel"
Cohesion: 0.20
Nodes (18): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+10 more)

### Community 24 - "RoundedButton"
Cohesion: 0.12
Nodes (9): RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body, .body, SegmentedProgressBar (+1 more)

### Community 25 - "Text"
Cohesion: 0.07
Nodes (21): MultipleSelectionRichButton, .body, MultiTitledHeader, .body, Text, OnboardingPageContent, .body, .rowContent (+13 more)

### Community 26 - "ExternalCollectionRecipeCard"
Cohesion: 0.10
Nodes (12): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, ExternalCollectionRecipeCard, ExternalCollectionView, .body (+4 more)

### Community 27 - ".body"
Cohesion: 0.13
Nodes (12): AlertToast, HomeView, SuccessView_Previews, .previews, LoadingView, .body, MainView, .body (+4 more)

### Community 28 - "DailyMeals"
Cohesion: 0.16
Nodes (6): DailyMeals, MealPlanLoader, WaterChallengeEntry, WeeklyMeals, .body, Date

### Community 29 - "SavedRestaurantsView"
Cohesion: 0.27
Nodes (4): SavedRestaurantsView, .body, SearchTextField, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.26
Nodes (8): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, RoundedImage, .body

### Community 32 - "Text"
Cohesion: 0.14
Nodes (13): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footerDot, .footnote, .footnoteText (+5 more)

### Community 35 - "GroceriesView.swift"
Cohesion: 0.12
Nodes (13): AddItemTip, .body, CheckableButton, .body, .addItemBar, .groceriesListView, GroceriesView_Previews, .previews (+5 more)

### Community 36 - "PreviewProvider"
Cohesion: 0.10
Nodes (15): ConfettiSwiftUI, EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, PlanView_Previews, .previews, TypingEffectView_Previews (+7 more)

### Community 38 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.16
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.24
Nodes (6): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.27
Nodes (4): .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 44 - ".show"
Cohesion: 0.05
Nodes (23): AlertState, none, override, remove, Array, DateStatus, future, past (+15 more)

### Community 45 - "SaveExternalSourceCardView"
Cohesion: 0.40
Nodes (4): SaveExternalRecipeCardView_Preview, .previews, SaveExternalSourceCardView, .body

### Community 46 - "SavedRecipesView"
Cohesion: 0.33
Nodes (4): Saved_Previews, .previews, SavedRecipesView, .body

### Community 47 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 52 - "FavoritesView"
Cohesion: 0.29
Nodes (6): FavoritesPreviews, .previews, FavoritesView, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView

### Community 54 - "GroceryRow"
Cohesion: 0.40
Nodes (5): GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix

### Community 55 - "Bool"
Cohesion: 0.13
Nodes (14): Bool, Kind, length, volume, weight, Measure, .combined, UnitConverter (+6 more)

### Community 57 - "PlanPageMenuButton"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 60 - "MealSlot"
Cohesion: 0.14
Nodes (9): MealEntry, ProcessedRecipe, RecipeSourceManager, FindRecipesManager, MealSlot, .isEaten, .isFilled, .isPro (+1 more)

### Community 61 - ".body"
Cohesion: 0.21
Nodes (5): LoadingVisibilityManager, TabVisibilityManager, PlanView, .body, .body

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 67 - "RecipeCard.swift"
Cohesion: 0.27
Nodes (8): RecipeAction, .body, RecipeCard, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 68 - "MealType"
Cohesion: 0.25
Nodes (8): MealType, breakfast, dinner, .displayName, lunch, sideBreakfast, sideDinner, sideLunch

### Community 70 - ".purchase"
Cohesion: 0.28
Nodes (4): SubscriptionPlan, lifetime, monthly, yearly

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 75 - "NutritionalInfoView"
Cohesion: 0.29
Nodes (4): NutritionalInfoView, .body, NutritionalInfoView_Previews, .previews

### Community 78 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 80 - "Tab"
Cohesion: 0.10
Nodes (12): HomeSelectionManager, Tab, favorites, .icon, plan, .title, .view, BannerCollectionView (+4 more)

### Community 81 - ".show"
Cohesion: 0.29
Nodes (5): ToastType, error, success, ToastVisibilityManager, .body

## Knowledge Gaps
- **225 isolated node(s):** `breakfast`, `dinner`, `lunch`, `sideBreakfast`, `sideDinner` (+220 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 382 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **34 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Bool` connect `Bool` to `RecipeDetailView`, `RecipeIngredientsGridView`, `String`, `UnitsSetting`, `SwiftUI`, `.body`, `GroceryPickerSheet`, `MealPlanManager`, `GroceriesView`, `RatingPromptManager`, `Color`, `RecipeCard`, `User`, `FoodSensitivity`, `GroceriesManager`, `String`, `RecipeModel`, `RoundedButton`, `Text`, `ExternalCollectionRecipeCard`, `DailyMeals`, `SavedRestaurantsView`, `LaunchAnimationView`, `View`, `Text`, `CategoryCollection`, `GroceriesView.swift`, `PreviewProvider`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `.show`, `SavedRecipesView`, `.body`, `Foundation`, `GroceryRow`, `PlanPageMenuButton`, `MultipleSelectionRichButtonRed`, `MealSlot`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `.init`, `RecipeCard.swift`, `.purchase`, `NutritionalInfoView`, `LoadingPlaceholder`, `Tab`?**
  _High betweenness centrality (0.261) - this node is a cross-community bridge._
- **Are the 98 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 98 INFERRED edges - model-reasoned connections that need verification._
- **What connects `breakfast`, `dinner`, `lunch` to the rest of the system?**
  _225 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `RecipeIngredientsGridView` be split into smaller, more focused modules?**
  _Cohesion score 0.10505050505050505 - nodes in this community are weakly interconnected._
- **Why does `String` connect `String` to `IconButton`, `.body`, `CodingKeys`, `GroceryPickerSheet`, `RatingPromptManager`, `Color`, `RecipeCard`, `User`, `FoodSensitivity`, `RecipeModel`, `RoundedButton`, `Text`, `ExternalCollectionRecipeCard`, `SavedRestaurantsView`, `LaunchAnimationView`, `View`, `Text`, `Array`, `PreviewProvider`, `ExternalSourceManager`, `FoodPreference`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `Goal`, `.show`, `SaveExternalSourceCardView`, `SavedRecipesView`, `.formatPrice`, `PlanPageMenuButton`, `MultipleSelectionRichButtonRed`, `MealSlot`, `SavedSourceCard`, `RecipeCard.swift`, `MealType`, `.purchase`, `DifficultyType`, `Tab`, `.show`?**
  _High betweenness centrality (0.221) - this node is a cross-community bridge._
- **Should `UnitsSetting` be split into smaller, more focused modules?**
  _Cohesion score 0.1164021164021164 - nodes in this community are weakly interconnected._
- **Why does `GroceriesView` connect `GroceriesView` to `GroceriesView.swift`, `Color`, `Tab`, `.show`, `GroceriesManager`, `Bool`, `MealSlot`, `View`?**
  _High betweenness centrality (0.082) - this node is a cross-community bridge._