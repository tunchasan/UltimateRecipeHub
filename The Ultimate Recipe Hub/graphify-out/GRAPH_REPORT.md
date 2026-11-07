# Graph Report - The Ultimate Recipe Hub  (2026-11-07)

## Corpus Check
- cluster-only mode — file stats not available

## Summary
- 1213 nodes · 3016 edges · 75 communities (62 shown, 13 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 339 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `21926217`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- MealPlanManager
- LaunchAnimationView
- WaterChallengeView
- Tab
- GroceryPickerSheet
- SwiftUI
- .body
- CodingKeys
- Text
- PlanDayView
- RecipeIngredientsGridView
- GroceriesView
- RatingPromptManager
- GroceriesManager
- Color
- MealSlot
- RoundedButton
- PaywallTrigger
- FoodSensitivity
- GroceryRow
- GroceriesView.swift
- GroceryItem
- IngredientMentions
- RecipeModel
- User
- ObservableObject
- .body
- .body
- Bool
- .show
- String
- View
- NewPaywallView
- PaywallButton
- PreviewProvider
- GroceryFormatter
- IconButton
- ExternalSourceManager
- FoodPreference
- Foundation
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- SavedRestaurantsView
- NotificationManager
- .formatPrice
- RecipeCard
- SubscriptionManager.swift
- Date
- AddItemTip
- NewPaywallView.swift
- SafariView
- Goal
- .purchase
- MealType
- .highlightedSteps
- NutritionalInfoView
- PlanPageMenuButton
- OnboardingHealtyMealPage
- FavoritesView
- RateUsPrePromptVisibilityManager
- ReplaceRecipe
- SavedSourceCard
- Counter
- FTMealPlanGenerateView
- CodingKeys
- Pause
- RateUsView
- SaveExternalSourceCardView
- DifficultyType
- SubscriptionType
- AddToMealPlanFooter
- CLAUDE.md
- Array

## God Nodes (most connected - your core abstractions)
1. `Text` - 92 edges
2. `GroceriesView` - 64 edges
3. `MealPlanManager` - 43 edges
4. `RatingPromptManager` - 40 edges
5. `GroceriesManager` - 38 edges
6. `CodingKeys` - 36 edges
7. `GroceryItem` - 35 edges
8. `NewPaywallView` - 32 edges
9. `RecipeIngredientsGridView` - 30 edges
10. `MealSlot` - 30 edges

## Surprising Connections (you probably didn't know these)
- `.body` --calls--> `RichButton`  [INFERRED]
  Pages/Recipe/AddToMealPlanFooter.swift → Components/RichButton.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift

## Import Cycles
- None detected.

## Communities (75 total, 13 thin omitted)

### Community 0 - "MealPlanManager"
Cohesion: 0.07
Nodes (21): CategoryCollection, DailyMeals, MealEntry, MealPlanCollectionLoader, MealPlanLoader, MealPlanManager, MealSlot.MealType, .collectionType (+13 more)

### Community 1 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 2 - "WaterChallengeView"
Cohesion: 0.07
Nodes (15): DateStatus, future, past, today, tomorrow, TypingEffectView, .body, TypingEffectView_Previews (+7 more)

### Community 3 - "Tab"
Cohesion: 0.08
Nodes (18): HomeSelectionManager, Tab, favorites, .icon, plan, .title, .view, CollectionType (+10 more)

### Community 4 - "GroceryPickerSheet"
Cohesion: 0.11
Nodes (14): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .items, .scale (+6 more)

### Community 5 - "SwiftUI"
Cohesion: 0.08
Nodes (13): HomeView, SuccessView_Previews, .previews, Kingfisher, OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body (+5 more)

### Community 6 - ".body"
Cohesion: 0.09
Nodes (10): FavoriteRecipesManager, .body, DirectionView, .cookingServingsText, RecipeDetails, .body, .listScale, .listServingsText (+2 more)

### Community 7 - "CodingKeys"
Cohesion: 0.07
Nodes (30): CodingKeys, calories, cookTime, cuisine, description, difficulty, dishType, duration (+22 more)

### Community 8 - "Text"
Cohesion: 0.08
Nodes (16): MultipleSelectionRichButton, .body, MultipleSelectionRichButtonRed, .body, MultiTitledHeader, .body, Text, .body (+8 more)

### Community 9 - "PlanDayView"
Cohesion: 0.10
Nodes (15): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, AlertState, none, override, remove (+7 more)

### Community 10 - "RecipeIngredientsGridView"
Cohesion: 0.12
Nodes (10): IngredientLineBox, RecipeIngredientsGridView, .body, .firstHighlightedIndex, .isServingsLocked, RecipeIngredientsGridView_Previews, .previews, .scaledIngredients (+2 more)

### Community 11 - "GroceriesView"
Cohesion: 0.11
Nodes (14): GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem, .emptyArtAndTitle, .emptyArtTopPadding, .emptyArtWidth (+6 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.20
Nodes (7): Key, RatingPromptManager, .appVersion, .baselines, .lastAskedDate, Waiting, .body

### Community 13 - "GroceriesManager"
Cohesion: 0.15
Nodes (9): groceries, GroceriesManager, .freeSlotsLeft, .allCheckedView, .body, .hasCheckedItemsToToggle, .progress, .recipeNamesOnList (+1 more)

### Community 14 - "Color"
Cohesion: 0.17
Nodes (17): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+9 more)

### Community 15 - "MealSlot"
Cohesion: 0.12
Nodes (10): FindRecipesManager, DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body, MealSlot, .isEaten (+2 more)

### Community 16 - "RoundedButton"
Cohesion: 0.12
Nodes (9): RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body, .body, SegmentedProgressBar (+1 more)

### Community 17 - "PaywallTrigger"
Cohesion: 0.10
Nodes (18): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+10 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.11
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 19 - "GroceryRow"
Cohesion: 0.13
Nodes (9): recipes, .recipeSections, GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix, RecipeSection (+1 more)

### Community 20 - "GroceriesView.swift"
Cohesion: 0.14
Nodes (10): CheckableButton, .body, GroceriesMenuButton, .body, .groceriesListView, GroceriesView_Previews, .previews, .toolbarContent (+2 more)

### Community 21 - "GroceryItem"
Cohesion: 0.19
Nodes (4): GroceryDisplay, GroceryItem, .display, .editableText

### Community 23 - "RecipeModel"
Cohesion: 0.27
Nodes (14): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+6 more)

### Community 24 - "User"
Cohesion: 0.17
Nodes (3): User, .body, .body

### Community 25 - "ObservableObject"
Cohesion: 0.19
Nodes (5): LoadingVisibilityManager, TabVisibilityManager, PlanView, .body, .body

### Community 26 - ".body"
Cohesion: 0.13
Nodes (11): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, ExternalCollectionView, .body, SeeAllCard (+3 more)

### Community 27 - ".body"
Cohesion: 0.15
Nodes (10): AlertToast, LoadingView, .body, MainView, .body, ContentView, .body, Save_Previews (+2 more)

### Community 28 - "Bool"
Cohesion: 0.18
Nodes (5): Bool, ReplaceMode, RecipeComparisonView, .body, RecipeDetailView

### Community 29 - ".show"
Cohesion: 0.17
Nodes (8): ToastType, error, success, ToastVisibilityManager, Saved_Previews, .previews, SavedRecipesView, .body

### Community 30 - "String"
Cohesion: 0.33
Nodes (3): HydrationMessageManager, String, .capitalizedWords

### Community 31 - "View"
Cohesion: 0.29
Nodes (7): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, RoundedImage, .body

### Community 32 - "NewPaywallView"
Cohesion: 0.14
Nodes (13): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footerDot, .footnote, .footnoteText (+5 more)

### Community 33 - "PaywallButton"
Cohesion: 0.17
Nodes (8): LoadingPlaceholder, PaywallButton, .cardRow, .selectionTick, .showsBadge, .showsRecommended, .showsSelected, View

### Community 34 - "PreviewProvider"
Cohesion: 0.15
Nodes (9): ConfettiSwiftUI, PlanView_Previews, .previews, DirectionView_Previews, RecipeDetailView_Previews, RecipesView_Previews, .previews, SavedRestaurant_Previews (+1 more)

### Community 36 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 38 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 39 - "Foundation"
Cohesion: 0.20
Nodes (3): Combine, Foundation, ExternalSource

### Community 40 - "SubscriptionManager"
Cohesion: 0.24
Nodes (6): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.23
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - "SavedRestaurantsView"
Cohesion: 0.21
Nodes (4): SavedRestaurantsView, .body, SearchTextField, .body

### Community 45 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 46 - "RecipeCard"
Cohesion: 0.27
Nodes (8): RecipeAction, .body, RecipeCard, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 47 - "SubscriptionManager.swift"
Cohesion: 0.22
Nodes (4): RevenueCat, StoreKit, UltimateRecipeHub, .body

### Community 49 - "AddItemTip"
Cohesion: 0.24
Nodes (6): AddItemTip, .body, .addItemBar, RecipeRemoval, .buttonTitle, .title

### Community 50 - "NewPaywallView.swift"
Cohesion: 0.22
Nodes (8): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, PaywallSelection, firstPackage, secondPackage, thirdPackage

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 53 - ".purchase"
Cohesion: 0.28
Nodes (4): SubscriptionPlan, lifetime, monthly, yearly

### Community 54 - "MealType"
Cohesion: 0.22
Nodes (8): MealType, breakfast, dinner, .displayName, lunch, sideBreakfast, sideDinner, sideLunch

### Community 55 - ".highlightedSteps"
Cohesion: 0.39
Nodes (3): DirectionsView, .body, HighlightedStepsBox

### Community 56 - "NutritionalInfoView"
Cohesion: 0.29
Nodes (4): NutritionalInfoView, .body, NutritionalInfoView_Previews, .previews

### Community 57 - "PlanPageMenuButton"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "FavoritesView"
Cohesion: 0.29
Nodes (6): FavoritesPreviews, .previews, FavoritesView, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView

### Community 61 - "ReplaceRecipe"
Cohesion: 0.32
Nodes (4): ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 63 - "Counter"
Cohesion: 0.29
Nodes (7): Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.38
Nodes (5): FTMealPlanGenerateView, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 65 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 66 - "Pause"
Cohesion: 0.33
Nodes (6): Pause, closedCookingMode, closedReplaceScreen, leftRecipe, openedPlanPage, switchedTab

### Community 67 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 68 - "SaveExternalSourceCardView"
Cohesion: 0.40
Nodes (4): SaveExternalRecipeCardView_Preview, .previews, SaveExternalSourceCardView, .body

### Community 69 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 70 - "SubscriptionType"
Cohesion: 0.50
Nodes (4): .subscriptionType, SubscriptionType, free, pro

## Knowledge Gaps
- **197 isolated node(s):** `.collectionType`, `breakfast`, `dinner`, `lunch`, `sideBreakfast` (+192 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 330 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **13 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `MealPlanManager`, `LaunchAnimationView`, `WaterChallengeView`, `Tab`, `GroceryPickerSheet`, `.body`, `CodingKeys`, `Text`, `PlanDayView`, `RecipeIngredientsGridView`, `GroceriesView`, `RatingPromptManager`, `GroceriesManager`, `Color`, `MealSlot`, `RoundedButton`, `FoodSensitivity`, `GroceryRow`, `GroceriesView.swift`, `GroceryItem`, `IngredientMentions`, `RecipeModel`, `User`, `Bool`, `.show`, `View`, `NewPaywallView`, `PaywallButton`, `GroceryFormatter`, `IconButton`, `ExternalSourceManager`, `FoodPreference`, `Foundation`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `SavedRestaurantsView`, `.formatPrice`, `RecipeCard`, `Date`, `AddItemTip`, `Goal`, `.purchase`, `MealType`, `.highlightedSteps`, `PlanPageMenuButton`, `ReplaceRecipe`, `SavedSourceCard`, `Counter`, `CodingKeys`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`, `Array`?**
  _High betweenness centrality (0.400) - this node is a cross-community bridge._
- **Are the 90 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 90 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.collectionType`, `breakfast`, `dinner` to the rest of the system?**
  _197 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `MealPlanManager` be split into smaller, more focused modules?**
  _Cohesion score 0.06862745098039216 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `Bool` to `MealPlanManager`, `LaunchAnimationView`, `WaterChallengeView`, `Tab`, `GroceryPickerSheet`, `SwiftUI`, `.body`, `Text`, `PlanDayView`, `RecipeIngredientsGridView`, `GroceriesView`, `RatingPromptManager`, `GroceriesManager`, `Color`, `MealSlot`, `RoundedButton`, `FoodSensitivity`, `GroceryRow`, `GroceriesView.swift`, `GroceryItem`, `IngredientMentions`, `RecipeModel`, `User`, `ObservableObject`, `.body`, `.show`, `View`, `NewPaywallView`, `PaywallButton`, `GroceryFormatter`, `ExternalSourceManager`, `Foundation`, `SubscriptionManager`, `MetadataFetcher`, `SavedRestaurantsView`, `RecipeCard`, `Date`, `AddItemTip`, `.purchase`, `NutritionalInfoView`, `PlanPageMenuButton`, `RateUsPrePromptVisibilityManager`, `ReplaceRecipe`, `SavedSourceCard`?**
  _High betweenness centrality (0.176) - this node is a cross-community bridge._
- **Should `LaunchAnimationView` be split into smaller, more focused modules?**
  _Cohesion score 0.08156028368794327 - nodes in this community are weakly interconnected._
- **Why does `GroceriesView` connect `GroceriesView` to `MealPlanManager`, `Tab`, `GroceriesManager`, `Color`, `AddItemTip`, `GroceryRow`, `GroceriesView.swift`, `GroceryItem`, `Bool`, `.show`, `String`, `View`?**
  _High betweenness centrality (0.097) - this node is a cross-community bridge._