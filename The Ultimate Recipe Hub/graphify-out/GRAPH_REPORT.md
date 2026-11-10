# Graph Report - The Ultimate Recipe Hub  (2026-11-11)

## Corpus Check
- 900 files · ~238,489 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1331 nodes · 3355 edges · 92 communities (55 shown, 37 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 353 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `42fab0c7`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- .updateRecipe
- PaywallTrigger
- .show
- String
- UnitsSetting
- SwiftUI
- .body
- CodingKeys
- GroceryPickerSheet
- RecipeIngredientsGridView
- GroceriesView
- RatingPromptManager
- SwiftUI
- Color
- ProcessedRecipe
- RoundedButton
- .show
- FoodSensitivity
- GroceryRow
- GroceriesManager
- String
- RecipeModel
- User
- PaywallButton
- .body
- .body
- DailyMeals
- .show
- LaunchAnimationView
- View
- Text
- Array
- SavedRecipesView
- TrackScrolling
- .formatPrice
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- ServingsStepper
- FavoritesView
- Text
- RecipesView
- BannerCollectionView
- DirectionState
- .body
- Foundation
- SafariView
- Goal
- MultipleSelectionRichButton
- UnitConverter
- PreviewProvider
- OnboardingHealtyMealPage
- RateUsView
- NotificationManager
- ObservableObject
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- MultipleSelectionRichButtonRed
- MealPlanLoader
- AlertState
- Tab
- .purchase
- CodingKeys
- CLAUDE.md
- OnboardingMealPlanPage
- .updateItem
- DifficultyType
- SubscriptionType

## God Nodes (most connected - your core abstractions)
1. `Text` - 97 edges
2. `GroceriesView` - 64 edges
3. `UnitConverter` - 43 edges
4. `GroceriesManager` - 43 edges
5. `MealPlanManager` - 43 edges
6. `RatingPromptManager` - 40 edges
7. `CodingKeys` - 40 edges
8. `GroceryItem` - 38 edges
9. `RecipeIngredientsGridView` - 36 edges
10. `NewPaywallView` - 32 edges

## Surprising Connections (you probably didn't know these)
- `.scaleWithProChip` --calls--> `Text`  [INFERRED]
  Pages/Recipe/RecipeIngredientsGridView.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Recipe/RecipeIngredientsGridView.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `RichButton`  [INFERRED]
  Pages/Recipe/AddToMealPlanFooter.swift → Components/RichButton.swift
- `.progress` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultipleSelectionRichButton.swift → Logic/Text+ReadableFractions.swift

## Import Cycles
- None detected.

## Communities (92 total, 37 thin omitted)

### Community 0 - ".updateRecipe"
Cohesion: 0.15
Nodes (8): .body, RecipeComparisonView, .body, RecipeDetailView, ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 1 - "PaywallTrigger"
Cohesion: 0.06
Nodes (27): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+19 more)

### Community 2 - ".show"
Cohesion: 0.10
Nodes (15): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, Array, MealSlot, .isEaten, .isFilled (+7 more)

### Community 3 - "String"
Cohesion: 0.20
Nodes (3): GroceryDisplay, GroceryFormatter, .display

### Community 4 - "UnitsSetting"
Cohesion: 0.14
Nodes (16): UnitsSetting, .activeSystem, automatic, .current, .id, metric, .regionSystem, .system (+8 more)

### Community 5 - "SwiftUI"
Cohesion: 0.15
Nodes (5): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingPreferencesPage, OnBoardingView, .body

### Community 6 - ".body"
Cohesion: 0.05
Nodes (18): FavoriteRecipesManager, NutritionalInfoView, .body, NutritionalInfoView_Previews, .previews, .body, AddToMealPlanFooter, .body (+10 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (33): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+25 more)

### Community 9 - "GroceryPickerSheet"
Cohesion: 0.17
Nodes (10): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .items, .scale (+2 more)

### Community 10 - "RecipeIngredientsGridView"
Cohesion: 0.11
Nodes (18): CheckableButton, .body, ConversionNoteView, .body, IngredientLineBox, RecipeIngredientsGridView, .body, .conversionNote (+10 more)

### Community 11 - "GroceriesView"
Cohesion: 0.07
Nodes (30): recipes, AddItemTip, .body, GroceriesMenuButton, .body, GroceriesView, .addItemBar, .addItemButton (+22 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.09
Nodes (21): Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays, Key (+13 more)

### Community 13 - "SwiftUI"
Cohesion: 0.20
Nodes (6): MultiTitledHeader, .body, Kingfisher, RevenueCat, StoreKit, SwiftUI

### Community 14 - "Color"
Cohesion: 0.18
Nodes (15): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+7 more)

### Community 15 - "ProcessedRecipe"
Cohesion: 0.24
Nodes (5): ProcessedRecipe, RecipeSourceManager, FindRecipesManager, FindSuitableRecipesView, .body

### Community 16 - "RoundedButton"
Cohesion: 0.12
Nodes (9): RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body, .body, SegmentedProgressBar (+1 more)

### Community 17 - ".show"
Cohesion: 0.07
Nodes (15): DateStatus, future, past, today, tomorrow, TypingEffectView, .body, TypingEffectView_Previews (+7 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.13
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "GroceryRow"
Cohesion: 0.40
Nodes (5): GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix

### Community 21 - "GroceriesManager"
Cohesion: 0.13
Nodes (10): GroceriesManager, .freeSlotsLeft, GroceryItem, .editableText, RecipeAmount, .allCheckedView, .body, .hasCheckedItemsToToggle (+2 more)

### Community 22 - "String"
Cohesion: 0.06
Nodes (23): HydrationMessageManager, CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection, RecipeCollectionsResponse, String (+15 more)

### Community 23 - "RecipeModel"
Cohesion: 0.27
Nodes (14): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+6 more)

### Community 25 - "PaywallButton"
Cohesion: 0.14
Nodes (10): LoadingPlaceholder, PaywallButton, .body, .cardRow, .selectionTick, .showsBadge, .showsRecommended, .showsSelected (+2 more)

### Community 26 - ".body"
Cohesion: 0.16
Nodes (9): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, SeeAllCard, .body, SeeAllCard_Previews (+1 more)

### Community 27 - ".body"
Cohesion: 0.17
Nodes (9): AlertToast, LoadingView, .body, MainView, .body, ContentView, .body, Save_Previews (+1 more)

### Community 28 - "DailyMeals"
Cohesion: 0.16
Nodes (8): DailyMeals, MealEntry, MealPlanManager, ReplaceMode, WaterChallengeEntry, WeeklyMeals, .body, Date

### Community 29 - ".show"
Cohesion: 0.17
Nodes (8): ToastType, error, success, ToastVisibilityManager, SavedRestaurant_Previews, .previews, SavedRestaurantsView, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.16
Nodes (14): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, RecipeAction, RecipeCard (+6 more)

### Community 32 - "Text"
Cohesion: 0.10
Nodes (21): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, NewPaywallView, .body, .compactHeroHeight, .continueButtonText (+13 more)

### Community 34 - "SavedRecipesView"
Cohesion: 0.21
Nodes (6): Saved_Previews, .previews, SavedRecipesView, .body, SearchTextField, .body

### Community 36 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 38 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.15
Nodes (11): CategoryCollection, MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch (+3 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.16
Nodes (8): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced, UltimateRecipeHub, .body

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.19
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - "ServingsStepper"
Cohesion: 0.31
Nodes (4): ServingsStepper, .body, .maxServings, .proBadge

### Community 44 - "FavoritesView"
Cohesion: 0.29
Nodes (6): FavoritesPreviews, .previews, FavoritesView, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView

### Community 45 - "Text"
Cohesion: 0.15
Nodes (11): Text, .emptyArtAndTitle, .progressPill, .rowContent, .body, .body, .body, SaveExternalRecipeCardView_Preview (+3 more)

### Community 46 - "RecipesView"
Cohesion: 0.15
Nodes (8): .view, ExternalCollectionView, .body, RecipesView, .body, .placeholderCollectionView, RecipesView_Previews, .previews

### Community 48 - "DirectionState"
Cohesion: 0.40
Nodes (3): DirectionState, emptySlot, filledSlot

### Community 50 - "Foundation"
Cohesion: 0.18
Nodes (4): Combine, Foundation, OnboardingPageContent, .body

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 55 - "UnitConverter"
Cohesion: 0.13
Nodes (14): Bool, Kind, length, volume, weight, Measure, .combined, UnitConverter (+6 more)

### Community 57 - "PreviewProvider"
Cohesion: 0.11
Nodes (13): ConfettiSwiftUI, AlertState, create, none, override, remove, PlanPageMenuButton, PlanView (+5 more)

### Community 59 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 61 - "ObservableObject"
Cohesion: 0.27
Nodes (3): LoadingVisibilityManager, TabVisibilityManager, .body

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 68 - "AlertState"
Cohesion: 0.50
Nodes (4): AlertState, none, override, remove

### Community 69 - "Tab"
Cohesion: 0.18
Nodes (9): HomeSelectionManager, HomeView, SuccessView_Previews, .previews, Tab, favorites, .icon, plan (+1 more)

### Community 70 - ".purchase"
Cohesion: 0.27
Nodes (5): SubscriptionPlan, lifetime, monthly, yearly, .bottomSection

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 78 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 79 - "SubscriptionType"
Cohesion: 0.50
Nodes (4): .subscriptionType, SubscriptionType, free, pro

## Knowledge Gaps
- **218 isolated node(s):** `us`, `metric`, `.name`, `automatic`, `metric` (+213 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 372 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `.updateRecipe`, `PaywallTrigger`, `.show`, `.body`, `CodingKeys`, `GroceryPickerSheet`, `GroceriesView`, `RatingPromptManager`, `SwiftUI`, `Color`, `ProcessedRecipe`, `RoundedButton`, `.show`, `FoodSensitivity`, `RecipeModel`, `User`, `PaywallButton`, `.show`, `LaunchAnimationView`, `View`, `Text`, `Array`, `SavedRecipesView`, `.formatPrice`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `ServingsStepper`, `Text`, `Foundation`, `Goal`, `MultipleSelectionRichButton`, `PreviewProvider`, `SavedSourceCard`, `MultipleSelectionRichButtonRed`, `Tab`, `.purchase`, `CodingKeys`, `DifficultyType`, `SubscriptionType`?**
  _High betweenness centrality (0.234) - this node is a cross-community bridge._
- **Are the 95 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 95 INFERRED edges - model-reasoned connections that need verification._
- **What connects `us`, `metric`, `.name` to the rest of the system?**
  _218 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `.updateRecipe` be split into smaller, more focused modules?**
  _Cohesion score 0.14736842105263157 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `UnitConverter` to `.updateRecipe`, `.show`, `String`, `UnitsSetting`, `SwiftUI`, `.body`, `GroceryPickerSheet`, `RecipeIngredientsGridView`, `GroceriesView`, `RatingPromptManager`, `Color`, `ProcessedRecipe`, `RoundedButton`, `.show`, `FoodSensitivity`, `GroceryRow`, `GroceriesManager`, `String`, `RecipeModel`, `User`, `PaywallButton`, `.body`, `DailyMeals`, `.show`, `LaunchAnimationView`, `View`, `Text`, `SavedRecipesView`, `TrackScrolling`, `ExternalSourceManager`, `MealPlanManager.swift`, `SubscriptionManager`, `MetadataFetcher`, `ServingsStepper`, `RecipesView`, `.body`, `Foundation`, `MultipleSelectionRichButton`, `PreviewProvider`, `ObservableObject`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `MultipleSelectionRichButtonRed`, `.purchase`, `.updateItem`?**
  _High betweenness centrality (0.230) - this node is a cross-community bridge._
- **Should `PaywallTrigger` be split into smaller, more focused modules?**
  _Cohesion score 0.06417112299465241 - nodes in this community are weakly interconnected._
- **Why does `SwiftUI` connect `SwiftUI` to `.updateRecipe`, `PaywallTrigger`, `.show`, `String`, `UnitsSetting`, `SwiftUI`, `.body`, `GroceryPickerSheet`, `RecipeIngredientsGridView`, `GroceriesView`, `Color`, `RoundedButton`, `.show`, `String`, `PaywallButton`, `.body`, `.body`, `.show`, `LaunchAnimationView`, `View`, `Text`, `SavedRecipesView`, `ExternalSourceManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `ServingsStepper`, `FavoritesView`, `Text`, `RecipesView`, `BannerCollectionView`, `DirectionState`, `.body`, `Foundation`, `SafariView`, `MultipleSelectionRichButton`, `PreviewProvider`, `OnboardingHealtyMealPage`, `RateUsView`, `RateUsPrePromptVisibilityManager`, `FTMealPlanGenerateView`, `MultipleSelectionRichButtonRed`, `Tab`, `OnboardingMealPlanPage`?**
  _High betweenness centrality (0.067) - this node is a cross-community bridge._