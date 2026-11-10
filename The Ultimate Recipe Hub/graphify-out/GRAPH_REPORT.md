# Graph Report - The Ultimate Recipe Hub  (2026-11-11)

## Corpus Check
- 900 files · ~238,536 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1331 nodes · 3355 edges · 93 communities (57 shown, 36 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 353 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `10220796`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- RecipeDetailView
- IconButton
- .show
- String
- UnitsSetting
- SwiftUI
- RecipeDetails
- CodingKeys
- GroceryPickerSheet
- RecipeIngredientsGridView
- GroceriesView
- RatingPromptManager
- SwiftUI
- Color
- MealSlot
- RoundedButton
- .show
- FoodSensitivity
- String
- GroceriesManager
- IngredientMentions
- RecipeModel
- User
- PaywallButton
- .body
- .body
- DailyMeals
- SavedRestaurantsView
- LaunchAnimationView
- View
- Text
- Array
- MealPlanManager
- GroceriesView.swift
- PreviewProvider
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- String
- RecipeCollectionManager
- Text
- RecipesView
- BannerCollectionView
- .updateRecipe
- .body
- Foundation
- SafariView
- Goal
- SubscriptionPlan
- UnitConverter
- PlanPageMenuButton
- OnboardingHealtyMealPage
- RateUsView
- NotificationManager
- .body
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- .highlightedSteps
- RecipeCard.swift
- MealType
- Tab
- .purchase
- CodingKeys
- CLAUDE.md
- DirectionView
- SaveExternalSourceCardView
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
- `.body` --calls--> `RichButton`  [INFERRED]
  Pages/Recipe/AddToMealPlanFooter.swift → Components/RichButton.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultipleSelectionRichButton.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultipleSelectionRichButtonRed.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/MultiTitledHeader.swift → Logic/Text+ReadableFractions.swift
- `.body` --calls--> `Text`  [INFERRED]
  Components/RichButton.swift → Logic/Text+ReadableFractions.swift

## Import Cycles
- None detected.

## Communities (93 total, 36 thin omitted)

### Community 0 - "RecipeDetailView"
Cohesion: 0.23
Nodes (7): RecipeComparisonView, .body, RecipeDetailView, RecipeDetailView_Previews, .previews, ReplacingInfoView, .body

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - ".show"
Cohesion: 0.06
Nodes (24): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, AlertState, none, override, remove (+16 more)

### Community 4 - "UnitsSetting"
Cohesion: 0.14
Nodes (16): UnitsSetting, .activeSystem, automatic, .current, .id, metric, .regionSystem, .system (+8 more)

### Community 5 - "SwiftUI"
Cohesion: 0.12
Nodes (7): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body, OnboardingPreferencesPage, OnBoardingView, .body

### Community 6 - "RecipeDetails"
Cohesion: 0.19
Nodes (4): RecipeDetails, .listScale, .listServingsText, SharedViewModel

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (33): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+25 more)

### Community 9 - "GroceryPickerSheet"
Cohesion: 0.11
Nodes (14): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .items, .scale (+6 more)

### Community 10 - "RecipeIngredientsGridView"
Cohesion: 0.12
Nodes (16): CheckableButton, .body, ConversionNoteView, IngredientLineBox, RecipeIngredientsGridView, .body, .conversionNote, .firstHighlightedIndex (+8 more)

### Community 11 - "GroceriesView"
Cohesion: 0.09
Nodes (19): GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .allCheckedView, .canSubmitNewItem (+11 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.09
Nodes (20): Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays, Key (+12 more)

### Community 13 - "SwiftUI"
Cohesion: 0.11
Nodes (10): MultiTitledHeader, .body, Kingfisher, OnboardingPageContent, .body, AddToMealPlanFooter, .body, RecipeTagGridView (+2 more)

### Community 14 - "Color"
Cohesion: 0.13
Nodes (17): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+9 more)

### Community 15 - "MealSlot"
Cohesion: 0.11
Nodes (13): MealEntry, ProcessedRecipe, RecipeSourceManager, DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body (+5 more)

### Community 16 - "RoundedButton"
Cohesion: 0.10
Nodes (11): MultipleSelectionRichButton, .body, RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body (+3 more)

### Community 17 - ".show"
Cohesion: 0.05
Nodes (24): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+16 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.13
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "String"
Cohesion: 0.21
Nodes (8): recipes, .recipeSections, GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix, RecipeSection

### Community 21 - "GroceriesManager"
Cohesion: 0.13
Nodes (13): groceries, GroceriesManager, .freeSlotsLeft, GroceryDisplay, GroceryItem, .display, .editableText, RecipeAmount (+5 more)

### Community 23 - "RecipeModel"
Cohesion: 0.26
Nodes (13): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+5 more)

### Community 25 - "PaywallButton"
Cohesion: 0.17
Nodes (9): LoadingPlaceholder, PaywallButton, .body, .cardRow, .selectionTick, .showsBadge, .showsRecommended, .showsSelected (+1 more)

### Community 26 - ".body"
Cohesion: 0.10
Nodes (15): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, ExternalCollectionView, .body, SeeAllCard (+7 more)

### Community 27 - ".body"
Cohesion: 0.15
Nodes (10): AlertToast, LoadingView, .body, MainView, .body, ContentView, .body, Save_Previews (+2 more)

### Community 28 - "DailyMeals"
Cohesion: 0.17
Nodes (6): DailyMeals, MealPlanLoader, WaterChallengeEntry, WeeklyMeals, .body, Date

### Community 29 - "SavedRestaurantsView"
Cohesion: 0.18
Nodes (4): SavedRestaurantsView, .body, SearchTextField, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.26
Nodes (8): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, RoundedImage, .body

### Community 32 - "Text"
Cohesion: 0.09
Nodes (20): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, NewPaywallView, .body, .compactHeroHeight, .continueButtonSubText (+12 more)

### Community 34 - "MealPlanManager"
Cohesion: 0.22
Nodes (3): CategoryCollection, MealPlanManager, ReplaceMode

### Community 35 - "GroceriesView.swift"
Cohesion: 0.17
Nodes (8): AddItemTip, .body, .addItemBar, OnUserScroll, RecipeRemoval, .buttonTitle, .title, TrackScrolling

### Community 36 - "PreviewProvider"
Cohesion: 0.12
Nodes (12): ConfettiSwiftUI, NutritionalInfoView_Previews, .previews, PlanView_Previews, .previews, TypingEffectView_Previews, .previews, GroceriesView_Previews (+4 more)

### Community 38 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.18
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.17
Nodes (7): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced, .planCards

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.23
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - "String"
Cohesion: 0.40
Nodes (3): HydrationMessageManager, String, .capitalizedWords

### Community 44 - "RecipeCollectionManager"
Cohesion: 0.24
Nodes (6): CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection, RecipeCollectionsResponse

### Community 45 - "Text"
Cohesion: 0.18
Nodes (9): Text, .emptyArtAndTitle, .progressPill, .rowContent, .footerDot, .footnote, .title, .body (+1 more)

### Community 46 - "RecipesView"
Cohesion: 0.12
Nodes (12): .view, FavoritesPreviews, .previews, FavoritesView, .body, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView (+4 more)

### Community 48 - ".updateRecipe"
Cohesion: 0.22
Nodes (4): .body, FindRecipesManager, ReplaceRecipe, .body

### Community 49 - ".body"
Cohesion: 0.20
Nodes (4): MultipleSelectionRichButtonRed, .body, OnboardingSensitivityPage, .body

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 54 - "SubscriptionPlan"
Cohesion: 0.17
Nodes (8): SubscriptionPlan, lifetime, monthly, yearly, RevenueCat, StoreKit, UltimateRecipeHub, .body

### Community 55 - "UnitConverter"
Cohesion: 0.13
Nodes (14): Bool, Kind, length, volume, weight, Measure, .combined, UnitConverter (+6 more)

### Community 57 - "PlanPageMenuButton"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 61 - ".body"
Cohesion: 0.14
Nodes (11): LoadingVisibilityManager, TabVisibilityManager, ToastType, error, success, ToastVisibilityManager, PlanView, .body (+3 more)

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 65 - ".highlightedSteps"
Cohesion: 0.33
Nodes (4): steps, DirectionsView, .body, HighlightedStepsBox

### Community 67 - "RecipeCard.swift"
Cohesion: 0.27
Nodes (7): RecipeAction, .body, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 68 - "MealType"
Cohesion: 0.25
Nodes (8): MealType, breakfast, dinner, .displayName, lunch, sideBreakfast, sideDinner, sideLunch

### Community 69 - "Tab"
Cohesion: 0.18
Nodes (9): HomeSelectionManager, HomeView, SuccessView_Previews, .previews, Tab, favorites, .icon, plan (+1 more)

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
- **218 isolated node(s):** `us`, `metric`, `.name`, `automatic`, `metric` (+213 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 372 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `RecipeDetailView`, `IconButton`, `.show`, `String`, `CodingKeys`, `GroceryPickerSheet`, `GroceriesView`, `RatingPromptManager`, `SwiftUI`, `Color`, `MealSlot`, `RoundedButton`, `.show`, `FoodSensitivity`, `IngredientMentions`, `RecipeModel`, `User`, `PaywallButton`, `.body`, `SavedRestaurantsView`, `LaunchAnimationView`, `View`, `Text`, `Array`, `MealPlanManager`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `RecipeCollectionManager`, `.updateRecipe`, `.body`, `Goal`, `SubscriptionPlan`, `PlanPageMenuButton`, `.body`, `SavedSourceCard`, `.highlightedSteps`, `RecipeCard.swift`, `MealType`, `Tab`, `.purchase`, `CodingKeys`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`?**
  _High betweenness centrality (0.274) - this node is a cross-community bridge._
- **Are the 95 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 95 INFERRED edges - model-reasoned connections that need verification._
- **What connects `us`, `metric`, `.name` to the rest of the system?**
  _218 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `.show` be split into smaller, more focused modules?**
  _Cohesion score 0.05920444033302498 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `UnitConverter` to `RecipeDetailView`, `.show`, `String`, `UnitsSetting`, `SwiftUI`, `RecipeDetails`, `GroceryPickerSheet`, `RecipeIngredientsGridView`, `GroceriesView`, `RatingPromptManager`, `Color`, `MealSlot`, `RoundedButton`, `.show`, `FoodSensitivity`, `String`, `GroceriesManager`, `IngredientMentions`, `RecipeModel`, `User`, `PaywallButton`, `.body`, `DailyMeals`, `SavedRestaurantsView`, `LaunchAnimationView`, `View`, `Text`, `MealPlanManager`, `GroceriesView.swift`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `RecipesView`, `.updateRecipe`, `.body`, `Foundation`, `PlanPageMenuButton`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `.purchase`, `DirectionView`, `.addCustomItem`?**
  _High betweenness centrality (0.246) - this node is a cross-community bridge._
- **Should `UnitsSetting` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Why does `Text` connect `Text` to `RecipeDetailView`, `IconButton`, `.show`, `UnitsSetting`, `SwiftUI`, `RecipeDetails`, `GroceryPickerSheet`, `RecipeIngredientsGridView`, `GroceriesView`, `RatingPromptManager`, `SwiftUI`, `Color`, `RoundedButton`, `.show`, `String`, `GroceriesManager`, `PaywallButton`, `.body`, `.body`, `DailyMeals`, `SavedRestaurantsView`, `View`, `Text`, `GroceriesView.swift`, `OnboardTypingEffectView`, `MetadataFetcher`, `RecipesView`, `.updateRecipe`, `.body`, `OnboardingHealtyMealPage`, `RateUsView`, `.body`, `SavedSourceCard`, `FTMealPlanGenerateView`, `.highlightedSteps`, `RecipeCard.swift`, `.purchase`, `SaveExternalSourceCardView`?**
  _High betweenness centrality (0.070) - this node is a cross-community bridge._