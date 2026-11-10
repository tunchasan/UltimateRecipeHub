# Graph Report - The Ultimate Recipe Hub  (2026-11-11)

## Corpus Check
- 900 files · ~239,575 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1346 nodes · 3404 edges · 99 communities (62 shown, 37 thin omitted)
- Extraction: 90% EXTRACTED · 10% INFERRED · 0% AMBIGUOUS · INFERRED: 357 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `90dbc3d4`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- RecipeDetailView
- IconButton
- PlanDayView
- String
- UnitsSetting
- SwiftUI
- .body
- CodingKeys
- GroceryPickerSheet
- MealPlanManager
- GroceriesView
- RatingPromptManager
- SwiftUI
- Color
- RecipeCard
- RoundedButton
- PaywallTrigger
- FoodSensitivity
- .show
- GroceriesManager
- IngredientMentions
- RecipeModel
- User
- PaywallButton
- RecipeCollectionManager
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
- String
- WaterProgressView
- Text
- SavedRecipesView
- .formatPrice
- .updateRecipe
- DateStatus
- Foundation
- SafariView
- TypingEffectView
- SubscriptionPlan
- Bool
- PlanPageMenuButton
- OnboardingHealtyMealPage
- RateUsView
- ProcessedRecipe
- .body
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- .highlightedSteps
- RecipeCard.swift
- MealSlot
- Tab
- .purchase
- CodingKeys
- CLAUDE.md
- NutritionalInfoView
- .addCustomItem
- TrackScrolling
- DifficultyType
- SubscriptionType
- Tab
- .show
- EmptyRecipeSlot
- MultipleSelectionRichButton
- AlertState
- ExternalSource

## God Nodes (most connected - your core abstractions)
1. `Text` - 99 edges
2. `GroceriesView` - 64 edges
3. `RecipeIngredientsGridView` - 44 edges
4. `UnitConverter` - 43 edges
5. `GroceriesManager` - 43 edges
6. `MealPlanManager` - 43 edges
7. `RatingPromptManager` - 40 edges
8. `CodingKeys` - 40 edges
9. `GroceryItem` - 38 edges
10. `NewPaywallView` - 32 edges

## Surprising Connections (you probably didn't know these)
- `.scaleWithProChip` --calls--> `Text`  [INFERRED]
  Pages/Recipe/RecipeIngredientsGridView.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Recipe/RecipeIngredientsGridView.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Settings/SettingsView.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Settings/SettingsView.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Settings/SettingsView.swift → Logic/Text+ReadableFractions.swift

## Import Cycles
- None detected.

## Communities (99 total, 37 thin omitted)

### Community 0 - "RecipeDetailView"
Cohesion: 0.21
Nodes (8): RecipeComparisonView, .body, RecipeDetailView, RecipeDetailView_Previews, ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - "PlanDayView"
Cohesion: 0.23
Nodes (6): PlanDayView, .allSlotsFilled, .areAllSlotsNotFilled, .body, .expandedContent, .headerSection

### Community 3 - "String"
Cohesion: 0.22
Nodes (3): GroceryDisplay, GroceryFormatter, .display

### Community 4 - "UnitsSetting"
Cohesion: 0.12
Nodes (20): UnitsSetting, .activeSystem, automatic, .current, .id, metric, .regionSystem, .system (+12 more)

### Community 5 - "SwiftUI"
Cohesion: 0.12
Nodes (6): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingPreferencesPage, OnboardingSensitivityPage, OnBoardingView, .body

### Community 6 - ".body"
Cohesion: 0.05
Nodes (21): FavoriteRecipesManager, FavoritesPreviews, .previews, FavoritesView, .body, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView (+13 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (33): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+25 more)

### Community 9 - "GroceryPickerSheet"
Cohesion: 0.11
Nodes (13): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .scale, IngredientChecklist (+5 more)

### Community 10 - "MealPlanManager"
Cohesion: 0.19
Nodes (3): MealPlanManager, ReplaceMode, Date

### Community 11 - "GroceriesView"
Cohesion: 0.07
Nodes (28): recipes, GroceriesMenuButton, .body, GroceriesView, .addItemButton, .allCheckedMessage, .canSubmitNewItem, .emptyArtAndTitle (+20 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.09
Nodes (20): Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays, Key (+12 more)

### Community 13 - "SwiftUI"
Cohesion: 0.09
Nodes (14): MultipleSelectionRichButtonRed, .body, MultiTitledHeader, .body, SingleSelectionRichButton, .body, Kingfisher, NewPaywallExample (+6 more)

### Community 14 - "Color"
Cohesion: 0.19
Nodes (16): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+8 more)

### Community 15 - "RecipeCard"
Cohesion: 0.16
Nodes (6): DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body, RecipeCard

### Community 16 - "RoundedButton"
Cohesion: 0.22
Nodes (4): RoundedButton, .body, OnboardingMealPlanPage, .body

### Community 17 - "PaywallTrigger"
Cohesion: 0.10
Nodes (18): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+10 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.13
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 21 - "GroceriesManager"
Cohesion: 0.11
Nodes (13): groceries, GroceriesManager, .freeSlotsLeft, GroceryItem, .editableText, RecipeAmount, .allCheckedView, .body (+5 more)

### Community 23 - "RecipeModel"
Cohesion: 0.27
Nodes (14): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+6 more)

### Community 24 - "User"
Cohesion: 0.11
Nodes (8): User, .body, .body, .body, .body, .body, SegmentedProgressBar, .body

### Community 25 - "PaywallButton"
Cohesion: 0.17
Nodes (9): LoadingPlaceholder, PaywallButton, .body, .cardRow, .selectionTick, .showsBadge, .showsRecommended, .showsSelected (+1 more)

### Community 26 - "RecipeCollectionManager"
Cohesion: 0.06
Nodes (25): .view, CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection, RecipeCollectionsResponse, BannerCollectionView (+17 more)

### Community 27 - ".body"
Cohesion: 0.11
Nodes (11): AlertToast, LoadingView, .body, NotificationManager, MainView, .body, ContentView, .body (+3 more)

### Community 28 - "DailyMeals"
Cohesion: 0.22
Nodes (6): DailyMeals, MealEntry, MealPlanLoader, WaterChallengeEntry, WeeklyMeals, .body

### Community 29 - "SavedRestaurantsView"
Cohesion: 0.25
Nodes (4): SavedRestaurant_Previews, .previews, SavedRestaurantsView, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.26
Nodes (8): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, RoundedImage, .body

### Community 32 - "Text"
Cohesion: 0.13
Nodes (14): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footnoteText, .fullHeroHeight, .hero (+6 more)

### Community 35 - "GroceriesView.swift"
Cohesion: 0.28
Nodes (6): AddItemTip, .body, .addItemBar, RecipeRemoval, .buttonTitle, .title

### Community 36 - "PreviewProvider"
Cohesion: 0.24
Nodes (6): ConfettiSwiftUI, PlanView_Previews, .previews, TypingEffectView_Previews, .previews, DirectionView_Previews

### Community 38 - "FoodPreference"
Cohesion: 0.09
Nodes (21): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+13 more)

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.16
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.16
Nodes (8): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced, UltimateRecipeHub, .body

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.23
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - "String"
Cohesion: 0.40
Nodes (3): HydrationMessageManager, String, .capitalizedWords

### Community 44 - "WaterProgressView"
Cohesion: 0.21
Nodes (4): WaterProgressView, .body, WaterWave, .animatableData

### Community 45 - "Text"
Cohesion: 0.18
Nodes (9): Text, .rowContent, .footerDot, .footnote, .title, SaveExternalRecipeCardView_Preview, .previews, SaveExternalSourceCardView (+1 more)

### Community 46 - "SavedRecipesView"
Cohesion: 0.21
Nodes (6): Saved_Previews, .previews, SavedRecipesView, .body, SearchTextField, .body

### Community 47 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 49 - "DateStatus"
Cohesion: 0.20
Nodes (6): Array, DateStatus, future, past, today, tomorrow

### Community 50 - "Foundation"
Cohesion: 0.20
Nodes (4): Combine, Foundation, OnboardingPageContent, .body

### Community 54 - "SubscriptionPlan"
Cohesion: 0.50
Nodes (4): SubscriptionPlan, lifetime, monthly, yearly

### Community 55 - "Bool"
Cohesion: 0.06
Nodes (37): Bool, Kind, length, volume, weight, Measure, .combined, UnitConverter (+29 more)

### Community 57 - "PlanPageMenuButton"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 60 - "ProcessedRecipe"
Cohesion: 0.43
Nodes (3): ProcessedRecipe, RecipeSourceManager, FindRecipesManager

### Community 61 - ".body"
Cohesion: 0.30
Nodes (3): PlanView, .body, .body

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 65 - ".highlightedSteps"
Cohesion: 0.33
Nodes (4): steps, DirectionsView, .body, HighlightedStepsBox

### Community 67 - "RecipeCard.swift"
Cohesion: 0.27
Nodes (7): RecipeAction, .body, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 68 - "MealSlot"
Cohesion: 0.13
Nodes (12): MealSlot, .isEaten, .isFilled, .isPro, MealType, breakfast, dinner, .displayName (+4 more)

### Community 69 - "Tab"
Cohesion: 0.21
Nodes (6): HomeSelectionManager, HomeView, LoadingVisibilityManager, SuccessView_Previews, .previews, TabVisibilityManager

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 75 - "NutritionalInfoView"
Cohesion: 0.29
Nodes (4): NutritionalInfoView, .body, NutritionalInfoView_Previews, .previews

### Community 78 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 79 - "SubscriptionType"
Cohesion: 0.50
Nodes (4): .subscriptionType, SubscriptionType, free, pro

### Community 80 - "Tab"
Cohesion: 0.33
Nodes (5): Tab, favorites, .icon, plan, .title

### Community 81 - ".show"
Cohesion: 0.40
Nodes (4): ToastType, error, success, ToastVisibilityManager

### Community 87 - "EmptyRecipeSlot"
Cohesion: 0.50
Nodes (4): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews

### Community 89 - "AlertState"
Cohesion: 0.50
Nodes (4): AlertState, none, override, remove

## Knowledge Gaps
- **220 isolated node(s):** `us`, `metric`, `.name`, `automatic`, `metric` (+215 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 376 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **37 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `RecipeDetailView`, `IconButton`, `PlanDayView`, `String`, `.body`, `CodingKeys`, `GroceryPickerSheet`, `RatingPromptManager`, `SwiftUI`, `Color`, `RoundedButton`, `FoodSensitivity`, `.show`, `IngredientMentions`, `RecipeModel`, `User`, `PaywallButton`, `RecipeCollectionManager`, `SavedRestaurantsView`, `LaunchAnimationView`, `View`, `Text`, `Array`, `CategoryCollection`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `WaterProgressView`, `Text`, `SavedRecipesView`, `.formatPrice`, `.updateRecipe`, `Foundation`, `TypingEffectView`, `SubscriptionPlan`, `PlanPageMenuButton`, `ProcessedRecipe`, `SavedSourceCard`, `.highlightedSteps`, `RecipeCard.swift`, `MealSlot`, `.purchase`, `CodingKeys`, `DifficultyType`, `SubscriptionType`, `Tab`, `.show`, `EmptyRecipeSlot`, `MultipleSelectionRichButton`, `ExternalSource`?**
  _High betweenness centrality (0.260) - this node is a cross-community bridge._
- **Are the 97 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 97 INFERRED edges - model-reasoned connections that need verification._
- **What connects `us`, `metric`, `.name` to the rest of the system?**
  _220 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `UnitsSetting` be split into smaller, more focused modules?**
  _Cohesion score 0.1225071225071225 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `Bool` to `RecipeDetailView`, `PlanDayView`, `String`, `UnitsSetting`, `SwiftUI`, `.body`, `GroceryPickerSheet`, `MealPlanManager`, `GroceriesView`, `RatingPromptManager`, `SwiftUI`, `Color`, `RecipeCard`, `FoodSensitivity`, `.show`, `GroceriesManager`, `IngredientMentions`, `RecipeModel`, `User`, `PaywallButton`, `RecipeCollectionManager`, `DailyMeals`, `SavedRestaurantsView`, `LaunchAnimationView`, `View`, `Text`, `CategoryCollection`, `GroceriesView.swift`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `WaterProgressView`, `SavedRecipesView`, `Foundation`, `TypingEffectView`, `PlanPageMenuButton`, `ProcessedRecipe`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `MealSlot`, `Tab`, `.purchase`, `NutritionalInfoView`, `.addCustomItem`, `TrackScrolling`, `EmptyRecipeSlot`, `MultipleSelectionRichButton`?**
  _High betweenness centrality (0.259) - this node is a cross-community bridge._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.11695906432748537 - nodes in this community are weakly interconnected._
- **Why does `GroceriesView` connect `GroceriesView` to `GroceriesView.swift`, `.addCustomItem`, `Color`, `GroceriesManager`, `Bool`, `RecipeCollectionManager`, `ProcessedRecipe`, `View`?**
  _High betweenness centrality (0.073) - this node is a cross-community bridge._