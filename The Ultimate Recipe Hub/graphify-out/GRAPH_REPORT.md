# Graph Report - The Ultimate Recipe Hub  (2026-11-10)

## Corpus Check
- 900 files · ~236,624 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1315 nodes · 3310 edges · 91 communities (55 shown, 36 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 351 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `1a44351c`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- NotificationManager
- IconButton
- PlanDayView
- String
- .init
- SwiftUI
- .body
- CodingKeys
- Text
- GroceryPickerSheet
- RecipeIngredientsGridView
- GroceriesView
- RatingPromptManager
- MultipleSelectionRichButton
- Color
- .body
- RoundedButton
- PaywallTrigger
- FoodSensitivity
- GroceriesView.swift
- GroceriesManager
- String
- RecipeModel
- User
- .updateRecipe
- .body
- .body
- MealPlanLoader
- SavedRecipesView
- LaunchAnimationView
- View
- NewPaywallView
- Array
- CategoryCollection
- TypingEffectView
- ProcessedRecipe
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- .show
- HomeView.swift
- .formatPrice
- ServingsStepper
- MealPlanManager
- GroceryRow
- Foundation
- SafariView
- Goal
- .purchase
- MealType
- UnitConverter
- LoadingPlaceholder
- PlanView
- OnboardingHealtyMealPage
- RateUsView
- .show
- .body
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- RecipeCard.swift
- WaterProgressView
- PreviewProvider
- Tab
- PaywallVisibilityManager
- CodingKeys
- CLAUDE.md
- DateStatus
- SaveExternalSourceCardView
- DifficultyType
- SubscriptionType
- SubscriptionPlan

## God Nodes (most connected - your core abstractions)
1. `Text` - 97 edges
2. `GroceriesView` - 64 edges
3. `MealPlanManager` - 43 edges
4. `RatingPromptManager` - 40 edges
5. `GroceriesManager` - 40 edges
6. `CodingKeys` - 40 edges
7. `GroceryItem` - 37 edges
8. `UnitConverter` - 36 edges
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

## Communities (91 total, 36 thin omitted)

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - "PlanDayView"
Cohesion: 0.11
Nodes (13): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, AlertState, none, override, remove (+5 more)

### Community 3 - "String"
Cohesion: 0.26
Nodes (3): GroceryDisplay, GroceryFormatter, .display

### Community 5 - "SwiftUI"
Cohesion: 0.12
Nodes (7): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body, OnboardingPreferencesPage, OnBoardingView, .body

### Community 6 - ".body"
Cohesion: 0.07
Nodes (12): FavoriteRecipesManager, .body, AddToMealPlanFooter, .body, DirectionView, .cookingServingsText, RecipeDetails, .body (+4 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (34): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+26 more)

### Community 8 - "Text"
Cohesion: 0.12
Nodes (15): Text, .body, .rowContent, .footerDot, .footnote, .title, PaywallButton, .body (+7 more)

### Community 9 - "GroceryPickerSheet"
Cohesion: 0.20
Nodes (9): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .scale, IngredientChecklist (+1 more)

### Community 10 - "RecipeIngredientsGridView"
Cohesion: 0.12
Nodes (16): CheckableButton, .body, ConversionNoteView, IngredientLineBox, RecipeIngredientsGridView, .body, .conversionNote, .firstHighlightedIndex (+8 more)

### Community 11 - "GroceriesView"
Cohesion: 0.09
Nodes (21): recipes, GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem (+13 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.05
Nodes (34): Bool, Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays (+26 more)

### Community 13 - "MultipleSelectionRichButton"
Cohesion: 0.21
Nodes (4): MultipleSelectionRichButton, .body, MultipleSelectionRichButtonRed, .body

### Community 14 - "Color"
Cohesion: 0.18
Nodes (17): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+9 more)

### Community 16 - "RoundedButton"
Cohesion: 0.12
Nodes (9): RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body, .body, SegmentedProgressBar (+1 more)

### Community 17 - "PaywallTrigger"
Cohesion: 0.12
Nodes (17): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+9 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.11
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "GroceriesView.swift"
Cohesion: 0.12
Nodes (11): AddItemTip, .body, .addItemBar, GroceriesView_Previews, .previews, OnUserScroll, RecipeRemoval, .buttonTitle (+3 more)

### Community 21 - "GroceriesManager"
Cohesion: 0.11
Nodes (12): groceries, GroceriesManager, .freeSlotsLeft, GroceryItem, .editableText, RecipeAmount, .allCheckedView, .body (+4 more)

### Community 22 - "String"
Cohesion: 0.08
Nodes (15): HydrationMessageManager, CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection, RecipeCollectionsResponse, String (+7 more)

### Community 23 - "RecipeModel"
Cohesion: 0.27
Nodes (14): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+6 more)

### Community 26 - ".body"
Cohesion: 0.10
Nodes (12): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, ExternalCollectionRecipeCard, ExternalCollectionView, .body (+4 more)

### Community 27 - ".body"
Cohesion: 0.08
Nodes (18): AlertToast, MultiTitledHeader, .body, Kingfisher, LoadingView, .body, MainView, .body (+10 more)

### Community 29 - "SavedRecipesView"
Cohesion: 0.21
Nodes (6): Saved_Previews, .previews, SavedRecipesView, .body, SearchTextField, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.29
Nodes (7): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, RoundedImage, .body

### Community 32 - "NewPaywallView"
Cohesion: 0.13
Nodes (14): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footnoteText, .fullHeroHeight, .hero (+6 more)

### Community 36 - "ProcessedRecipe"
Cohesion: 0.22
Nodes (3): ProcessedRecipe, RecipeSourceManager, FindRecipesManager

### Community 38 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.18
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.16
Nodes (8): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced, UltimateRecipeHub, .body

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.27
Nodes (4): .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - ".show"
Cohesion: 0.22
Nodes (6): ToastType, error, success, ToastVisibilityManager, SavedRestaurantsView, .body

### Community 44 - "HomeView.swift"
Cohesion: 0.50
Nodes (4): HomeView, .body, SuccessView_Previews, .previews

### Community 45 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 47 - "ServingsStepper"
Cohesion: 0.31
Nodes (4): ServingsStepper, .body, .maxServings, .proBadge

### Community 48 - "MealPlanManager"
Cohesion: 0.18
Nodes (6): DailyMeals, MealPlanManager, ReplaceMode, WaterChallengeEntry, WeeklyMeals, .body

### Community 49 - "GroceryRow"
Cohesion: 0.40
Nodes (5): GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 54 - "MealType"
Cohesion: 0.12
Nodes (15): MealEntry, MealSlot, .isEaten, .isFilled, .isPro, MealType, breakfast, dinner (+7 more)

### Community 55 - "UnitConverter"
Cohesion: 0.09
Nodes (29): Kind, length, volume, weight, Measure, .combined, UnitConverter, UnitInfo (+21 more)

### Community 57 - "PlanView"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 61 - ".body"
Cohesion: 0.21
Nodes (5): LoadingVisibilityManager, TabVisibilityManager, PlanView, .body, .body

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 65 - "RecipeCard.swift"
Cohesion: 0.27
Nodes (8): RecipeAction, .body, RecipeCard, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 67 - "WaterProgressView"
Cohesion: 0.21
Nodes (4): WaterProgressView, .body, WaterWave, .animatableData

### Community 68 - "PreviewProvider"
Cohesion: 0.11
Nodes (12): ConfettiSwiftUI, NutritionalInfoView, NutritionalInfoView_Previews, .previews, PlanView_Previews, .previews, TypingEffectView_Previews, .previews (+4 more)

### Community 69 - "Tab"
Cohesion: 0.07
Nodes (20): HomeSelectionManager, Tab, favorites, .icon, plan, .title, .view, FavoritesPreviews (+12 more)

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 76 - "DateStatus"
Cohesion: 0.33
Nodes (5): DateStatus, future, past, today, tomorrow

### Community 77 - "SaveExternalSourceCardView"
Cohesion: 0.40
Nodes (4): SaveExternalRecipeCardView_Preview, .previews, SaveExternalSourceCardView, .body

### Community 78 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 79 - "SubscriptionType"
Cohesion: 0.50
Nodes (4): .subscriptionType, SubscriptionType, free, pro

### Community 87 - "SubscriptionPlan"
Cohesion: 0.17
Nodes (10): SubscriptionPlan, lifetime, monthly, yearly, NewPaywallExample, .body, NewPaywallExample_Previews, .previews (+2 more)

## Knowledge Gaps
- **218 isolated node(s):** `us`, `metric`, `.name`, `automatic`, `metric` (+213 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 367 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **36 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `IconButton`, `PlanDayView`, `.body`, `CodingKeys`, `Text`, `GroceryPickerSheet`, `RatingPromptManager`, `MultipleSelectionRichButton`, `Color`, `RoundedButton`, `FoodSensitivity`, `RecipeModel`, `User`, `.updateRecipe`, `.body`, `.body`, `SavedRecipesView`, `LaunchAnimationView`, `View`, `NewPaywallView`, `Array`, `CategoryCollection`, `TypingEffectView`, `ProcessedRecipe`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `.show`, `.formatPrice`, `ServingsStepper`, `Goal`, `.purchase`, `MealType`, `PlanView`, `.show`, `SavedSourceCard`, `RecipeCard.swift`, `WaterProgressView`, `Tab`, `CodingKeys`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`, `SubscriptionPlan`?**
  _High betweenness centrality (0.313) - this node is a cross-community bridge._
- **Are the 95 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 95 INFERRED edges - model-reasoned connections that need verification._
- **What connects `us`, `metric`, `.name` to the rest of the system?**
  _218 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `PlanDayView` be split into smaller, more focused modules?**
  _Cohesion score 0.11076923076923077 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `RatingPromptManager` to `PlanDayView`, `String`, `.init`, `SwiftUI`, `.body`, `Text`, `GroceryPickerSheet`, `RecipeIngredientsGridView`, `GroceriesView`, `MultipleSelectionRichButton`, `Color`, `.body`, `RoundedButton`, `FoodSensitivity`, `GroceriesView.swift`, `GroceriesManager`, `String`, `RecipeModel`, `User`, `.body`, `SavedRecipesView`, `LaunchAnimationView`, `View`, `NewPaywallView`, `CategoryCollection`, `TypingEffectView`, `ProcessedRecipe`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `.show`, `ServingsStepper`, `MealPlanManager`, `GroceryRow`, `Foundation`, `.purchase`, `MealType`, `UnitConverter`, `LoadingPlaceholder`, `PlanView`, `.show`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `RecipeCard.swift`, `WaterProgressView`, `PreviewProvider`, `Tab`?**
  _High betweenness centrality (0.193) - this node is a cross-community bridge._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.11695906432748537 - nodes in this community are weakly interconnected._
- **Why does `GroceriesView` connect `GroceriesView` to `ProcessedRecipe`, `Tab`, `.show`, `RatingPromptManager`, `Color`, `GroceriesView.swift`, `GroceriesManager`, `View`?**
  _High betweenness centrality (0.083) - this node is a cross-community bridge._