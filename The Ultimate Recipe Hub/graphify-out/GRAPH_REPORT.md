# Graph Report - The Ultimate Recipe Hub  (2026-11-10)

## Corpus Check
- 900 files · ~237,717 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1329 nodes · 3343 edges · 86 communities (54 shown, 32 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 353 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `8dd7f7ec`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- RecipeDetailView
- IconButton
- .show
- String
- GroceryItem
- SwiftUI
- .body
- CodingKeys
- GroceryPickerSheet
- RecipeIngredientsGridView
- GroceriesView
- RatingPromptManager
- SwiftUI
- Color
- .body
- RoundedButton
- PaywallTrigger
- FoodSensitivity
- String
- GroceriesManager
- String
- RecipeModel
- User
- SingleSelectionRichButton
- .body
- .body
- DailyMeals
- SavedRecipesView
- LaunchAnimationView
- View
- Text
- Array
- CategoryCollection
- .groceriesListView
- ProcessedRecipe
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- .show
- RecipesView
- NutritionalInfoView
- FavoritesView
- BannerCollectionView
- MealPlanManager
- Foundation
- SafariView
- Goal
- MealType
- UnitConverter
- PlanView
- OnboardingHealtyMealPage
- RateUsView
- .body
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- PreviewProvider
- Tab
- CodingKeys
- CLAUDE.md
- SaveExternalSourceCardView
- DifficultyType
- SubscriptionType

## God Nodes (most connected - your core abstractions)
1. `Text` - 97 edges
2. `GroceriesView` - 64 edges
3. `GroceriesManager` - 43 edges
4. `MealPlanManager` - 43 edges
5. `UnitConverter` - 40 edges
6. `RatingPromptManager` - 40 edges
7. `CodingKeys` - 40 edges
8. `GroceryItem` - 38 edges
9. `RecipeIngredientsGridView` - 36 edges
10. `NewPaywallView` - 32 edges

## Surprising Connections (you probably didn't know these)
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultipleSelectionRichButton.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultipleSelectionRichButtonRed.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultiTitledHeader.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift

## Import Cycles
- None detected.

## Communities (86 total, 32 thin omitted)

### Community 0 - "RecipeDetailView"
Cohesion: 0.23
Nodes (7): RecipeComparisonView, .body, RecipeDetailView, ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - ".show"
Cohesion: 0.05
Nodes (24): AlertState, none, override, remove, Array, DateStatus, future, past (+16 more)

### Community 3 - "String"
Cohesion: 0.20
Nodes (4): groceries, GroceryDisplay, GroceryFormatter, .display

### Community 5 - "SwiftUI"
Cohesion: 0.09
Nodes (8): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body, OnboardingPreferencesPage, OnboardingSensitivityPage, OnBoardingView, .body

### Community 6 - ".body"
Cohesion: 0.08
Nodes (11): FavoriteRecipesManager, .body, DirectionView, .cookingServingsText, RecipeDetails, .body, .listScale, .listServingsText (+3 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (34): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+26 more)

### Community 9 - "GroceryPickerSheet"
Cohesion: 0.11
Nodes (13): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .scale, IngredientChecklist (+5 more)

### Community 10 - "RecipeIngredientsGridView"
Cohesion: 0.10
Nodes (18): CheckableButton, .body, ConversionNoteView, .body, IngredientLineBox, RecipeIngredientsGridView, .body, .firstHighlightedIndex (+10 more)

### Community 11 - "GroceriesView"
Cohesion: 0.09
Nodes (17): GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem, .emptyArtAndTitle (+9 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.06
Nodes (29): Bool, Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays (+21 more)

### Community 13 - "SwiftUI"
Cohesion: 0.08
Nodes (14): MultipleSelectionRichButton, .body, MultipleSelectionRichButtonRed, .body, MultiTitledHeader, .body, Kingfisher, OnboardingPageContent (+6 more)

### Community 14 - "Color"
Cohesion: 0.19
Nodes (16): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+8 more)

### Community 15 - ".body"
Cohesion: 0.20
Nodes (5): DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body

### Community 16 - "RoundedButton"
Cohesion: 0.15
Nodes (7): RoundedButton, .body, .body, .body, .body, SegmentedProgressBar, .body

### Community 17 - "PaywallTrigger"
Cohesion: 0.10
Nodes (18): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+10 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.13
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "String"
Cohesion: 0.10
Nodes (17): recipes, AddItemTip, .body, .addItemBar, GroceriesView_Previews, .previews, .recipeSections, GroceryRow (+9 more)

### Community 21 - "GroceriesManager"
Cohesion: 0.12
Nodes (10): GroceriesManager, .freeSlotsLeft, RecipeAmount, .allCheckedView, .body, .hasCheckedItemsToToggle, .progress, .recipeNamesOnList (+2 more)

### Community 22 - "String"
Cohesion: 0.08
Nodes (15): HydrationMessageManager, CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection, RecipeCollectionsResponse, String (+7 more)

### Community 23 - "RecipeModel"
Cohesion: 0.27
Nodes (14): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+6 more)

### Community 25 - "SingleSelectionRichButton"
Cohesion: 0.18
Nodes (7): SingleSelectionRichButton, .body, CookingSkill, advanced, beginner, intermediate, .body

### Community 26 - ".body"
Cohesion: 0.13
Nodes (11): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, ExternalCollectionView, .body, SeeAllCard (+3 more)

### Community 27 - ".body"
Cohesion: 0.12
Nodes (13): AlertToast, HomeView, SuccessView_Previews, .previews, LoadingView, .body, MainView, .body (+5 more)

### Community 28 - "DailyMeals"
Cohesion: 0.22
Nodes (6): DailyMeals, MealEntry, MealPlanLoader, WaterChallengeEntry, WeeklyMeals, .body

### Community 29 - "SavedRecipesView"
Cohesion: 0.21
Nodes (6): Saved_Previews, .previews, SavedRecipesView, .body, SearchTextField, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.15
Nodes (15): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, RecipeAction, .body (+7 more)

### Community 32 - "Text"
Cohesion: 0.08
Nodes (26): Text, .rowContent, NewPaywallExample, .body, NewPaywallExample_Previews, .previews, NewPaywallView, .body (+18 more)

### Community 35 - ".groceriesListView"
Cohesion: 0.33
Nodes (3): .groceriesListView, OnUserScroll, TrackScrolling

### Community 36 - "ProcessedRecipe"
Cohesion: 0.39
Nodes (3): ProcessedRecipe, RecipeSourceManager, FindRecipesManager

### Community 38 - "FoodPreference"
Cohesion: 0.25
Nodes (8): FoodPreference, flexible, glutenFree, halal, lowCarb, pescatarian, vegan, vegetarian

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.16
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.06
Nodes (19): NotificationManager, FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced, SubscriptionPlan (+11 more)

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.19
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - ".show"
Cohesion: 0.24
Nodes (6): ToastType, error, success, ToastVisibilityManager, SavedRestaurantsView, .body

### Community 44 - "RecipesView"
Cohesion: 0.29
Nodes (4): .view, RecipesView, .body, .placeholderCollectionView

### Community 45 - "NutritionalInfoView"
Cohesion: 0.29
Nodes (4): NutritionalInfoView, .body, NutritionalInfoView_Previews, .previews

### Community 46 - "FavoritesView"
Cohesion: 0.29
Nodes (6): FavoritesPreviews, .previews, FavoritesView, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView

### Community 48 - "MealPlanManager"
Cohesion: 0.15
Nodes (4): MealPlanManager, ReplaceMode, .body, Date

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 54 - "MealType"
Cohesion: 0.14
Nodes (12): MealSlot, .isEaten, .isFilled, .isPro, MealType, breakfast, dinner, .displayName (+4 more)

### Community 55 - "UnitConverter"
Cohesion: 0.08
Nodes (29): Kind, length, volume, weight, Measure, .combined, UnitConverter, UnitInfo (+21 more)

### Community 57 - "PlanView"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 61 - ".body"
Cohesion: 0.20
Nodes (5): LoadingVisibilityManager, TabVisibilityManager, PlanView, .body, .body

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 68 - "PreviewProvider"
Cohesion: 0.10
Nodes (15): ConfettiSwiftUI, EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, PlanView_Previews, .previews, TypingEffectView_Previews (+7 more)

### Community 69 - "Tab"
Cohesion: 0.22
Nodes (6): HomeSelectionManager, Tab, favorites, .icon, plan, .title

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 77 - "SaveExternalSourceCardView"
Cohesion: 0.40
Nodes (4): SaveExternalRecipeCardView_Preview, .previews, SaveExternalSourceCardView, .body

### Community 78 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 79 - "SubscriptionType"
Cohesion: 0.50
Nodes (4): .subscriptionType, SubscriptionType, free, pro

## Knowledge Gaps
- **218 isolated node(s):** `.freeSlotsLeft`, `.editableText`, `us`, `metric`, `.name` (+213 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 373 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **32 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Bool` connect `RatingPromptManager` to `RecipeDetailView`, `.show`, `String`, `GroceryItem`, `SwiftUI`, `.body`, `GroceryPickerSheet`, `RecipeIngredientsGridView`, `GroceriesView`, `SwiftUI`, `Color`, `.body`, `FoodSensitivity`, `String`, `GroceriesManager`, `String`, `RecipeModel`, `User`, `SingleSelectionRichButton`, `.body`, `DailyMeals`, `SavedRecipesView`, `LaunchAnimationView`, `View`, `Text`, `CategoryCollection`, `.groceriesListView`, `ProcessedRecipe`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `.show`, `RecipesView`, `NutritionalInfoView`, `MealPlanManager`, `Foundation`, `MealType`, `UnitConverter`, `PlanView`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `PreviewProvider`?**
  _High betweenness centrality (0.252) - this node is a cross-community bridge._
- **Are the 95 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 95 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.freeSlotsLeft`, `.editableText`, `us` to the rest of the system?**
  _218 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `.show` be split into smaller, more focused modules?**
  _Cohesion score 0.05096153846153846 - nodes in this community are weakly interconnected._
- **Why does `String` connect `String` to `RecipeDetailView`, `IconButton`, `.show`, `.body`, `CodingKeys`, `GroceryPickerSheet`, `RatingPromptManager`, `SwiftUI`, `Color`, `RoundedButton`, `FoodSensitivity`, `RecipeModel`, `User`, `SingleSelectionRichButton`, `SavedRecipesView`, `LaunchAnimationView`, `View`, `Text`, `Array`, `CategoryCollection`, `ProcessedRecipe`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `.show`, `MealPlanManager`, `Goal`, `MealType`, `PlanView`, `SavedSourceCard`, `PreviewProvider`, `Tab`, `CodingKeys`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`?**
  _High betweenness centrality (0.241) - this node is a cross-community bridge._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.09486166007905138 - nodes in this community are weakly interconnected._
- **Why does `GroceriesView` connect `GroceriesView` to `.groceriesListView`, `GroceryItem`, `ProcessedRecipe`, `RecipeIngredientsGridView`, `RatingPromptManager`, `RecipesView`, `Color`, `String`, `GroceriesManager`, `View`?**
  _High betweenness centrality (0.065) - this node is a cross-community bridge._