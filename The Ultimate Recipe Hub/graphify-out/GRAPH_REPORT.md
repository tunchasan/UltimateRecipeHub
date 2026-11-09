# Graph Report - The Ultimate Recipe Hub  (2026-11-09)

## Corpus Check
- 900 files · ~236,342 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1312 nodes · 3298 edges · 88 communities (57 shown, 31 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 351 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `b59e1705`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- NotificationManager
- IconButton
- PlanDayView
- String
- .migrateToRecipeAmounts
- SwiftUI
- .body
- CodingKeys
- PaywallButton
- EmptyRecipeSlot
- Text
- GroceriesView
- RatingPromptManager
- RoundedButton
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
- NewPaywallView.swift
- ProcessedRecipe
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- .show
- Tab
- .formatPrice
- MealPlanManager
- String
- BannerCollectionView
- SafariView
- Goal
- .purchase
- MealType
- UnitConverter
- PlanView
- OnboardingHealtyMealPage
- FavoritesView
- .show
- .body
- SavedSourceCard
- RateUsPrePromptVisibilityManager
- FTMealPlanGenerateView
- RecipeCard.swift
- WaterProgressView
- PreviewProvider
- RecipesView
- CodingKeys
- CLAUDE.md
- DateStatus
- SaveExternalSourceCardView
- DifficultyType
- SubscriptionType
- SubscriptionPlan
- AlertState

## God Nodes (most connected - your core abstractions)
1. `Text` - 97 edges
2. `GroceriesView` - 64 edges
3. `MealPlanManager` - 43 edges
4. `RatingPromptManager` - 40 edges
5. `GroceriesManager` - 40 edges
6. `CodingKeys` - 40 edges
7. `GroceryItem` - 37 edges
8. `UnitConverter` - 35 edges
9. `RecipeIngredientsGridView` - 34 edges
10. `NewPaywallView` - 32 edges

## Surprising Connections (you probably didn't know these)
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Settings/SettingsView.swift → Logic/Text+ReadableFractions.swift
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

## Communities (88 total, 31 thin omitted)

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - "PlanDayView"
Cohesion: 0.23
Nodes (6): PlanDayView, .allSlotsFilled, .areAllSlotsNotFilled, .body, .expandedContent, .headerSection

### Community 3 - "String"
Cohesion: 0.19
Nodes (4): GroceryDisplay, GroceryFormatter, .display, RecipeAmount

### Community 5 - "SwiftUI"
Cohesion: 0.12
Nodes (7): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body, OnboardingPreferencesPage, OnBoardingView, .body

### Community 6 - ".body"
Cohesion: 0.06
Nodes (14): FavoriteRecipesManager, .body, AddToMealPlanFooter, .body, DirectionView, .cookingServingsText, RecipeDetails, .body (+6 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (33): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+25 more)

### Community 8 - "PaywallButton"
Cohesion: 0.17
Nodes (8): LoadingPlaceholder, PaywallButton, .cardRow, .selectionTick, .showsBadge, .showsRecommended, .showsSelected, View

### Community 9 - "EmptyRecipeSlot"
Cohesion: 0.50
Nodes (4): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews

### Community 10 - "Text"
Cohesion: 0.06
Nodes (34): Text, .body, CheckableButton, .body, .rowContent, ChecklistItem, GroceryPickerSheet, .baseServings (+26 more)

### Community 11 - "GroceriesView"
Cohesion: 0.09
Nodes (17): GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem, .emptyArtAndTitle (+9 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.05
Nodes (35): Bool, ReplaceMode, Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds (+27 more)

### Community 13 - "RoundedButton"
Cohesion: 0.17
Nodes (5): MultipleSelectionRichButton, .body, RoundedButton, .body, .body

### Community 14 - "Color"
Cohesion: 0.07
Nodes (28): MultipleSelectionRichButtonRed, .body, IconTextButton, .body, LightTextButton, .body, RichButton, .body (+20 more)

### Community 16 - "RoundedButton"
Cohesion: 0.18
Nodes (6): SingleSelectionRichButton, .body, .body, .body, SegmentedProgressBar, .body

### Community 17 - "PaywallTrigger"
Cohesion: 0.10
Nodes (18): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+10 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.10
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "GroceriesView.swift"
Cohesion: 0.13
Nodes (11): AddItemTip, .body, .addItemBar, .groceriesListView, GroceriesView_Previews, .previews, OnUserScroll, RecipeRemoval (+3 more)

### Community 21 - "GroceriesManager"
Cohesion: 0.13
Nodes (11): groceries, GroceriesManager, .freeSlotsLeft, GroceryItem, .editableText, .allCheckedView, .body, .hasCheckedItemsToToggle (+3 more)

### Community 22 - "String"
Cohesion: 0.06
Nodes (21): Combine, Foundation, HydrationMessageManager, CollectionType, collections, popularCollections, RecipeCollectionManager, RecipeCollection (+13 more)

### Community 23 - "RecipeModel"
Cohesion: 0.27
Nodes (14): Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType, .formattedIngredients (+6 more)

### Community 26 - ".body"
Cohesion: 0.13
Nodes (11): CollectionDetailsView, CollectionView, .body, SeeAllLabel, .body, ExternalCollectionView, .body, SeeAllCard (+3 more)

### Community 27 - ".body"
Cohesion: 0.11
Nodes (14): AlertToast, HomeView, .body, SuccessView_Previews, .previews, LoadingView, .body, MainView (+6 more)

### Community 29 - "SavedRecipesView"
Cohesion: 0.21
Nodes (4): SavedRecipesView, .body, SearchTextField, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.10
Nodes (7): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, UIKit

### Community 31 - "View"
Cohesion: 0.29
Nodes (7): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, RoundedImage, .body

### Community 32 - "NewPaywallView"
Cohesion: 0.14
Nodes (13): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footerDot, .footnote, .footnoteText (+5 more)

### Community 35 - "NewPaywallView.swift"
Cohesion: 0.22
Nodes (8): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, PaywallSelection, firstPackage, secondPackage, thirdPackage

### Community 36 - "ProcessedRecipe"
Cohesion: 0.24
Nodes (3): ProcessedRecipe, RecipeSourceManager, FindRecipesManager

### Community 38 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 39 - "MealPlanManager.swift"
Cohesion: 0.18
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 40 - "SubscriptionManager"
Cohesion: 0.22
Nodes (6): FreeTrial, .badgeText, .buttonText, SubscriptionManager, .isDebugFreeForced, .isDebugProForced

### Community 41 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 42 - "MetadataFetcher"
Cohesion: 0.23
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 43 - ".show"
Cohesion: 0.22
Nodes (6): ToastType, error, success, ToastVisibilityManager, SavedRestaurantsView, .body

### Community 44 - "Tab"
Cohesion: 0.16
Nodes (8): HomeSelectionManager, LoadingVisibilityManager, Tab, favorites, .icon, plan, .title, TabVisibilityManager

### Community 45 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 48 - "MealPlanManager"
Cohesion: 0.20
Nodes (5): DailyMeals, MealPlanManager, WaterChallengeEntry, WeeklyMeals, .body

### Community 49 - "String"
Cohesion: 0.16
Nodes (9): recipes, .recipeSections, GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix, RecipeSection (+1 more)

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 53 - ".purchase"
Cohesion: 0.29
Nodes (3): .bottomSection, .body, PaywallStyle

### Community 54 - "MealType"
Cohesion: 0.12
Nodes (13): MealEntry, MealSlot, .isEaten, .isFilled, .isPro, MealType, breakfast, dinner (+5 more)

### Community 55 - "UnitConverter"
Cohesion: 0.09
Nodes (29): Kind, length, volume, weight, Measure, .combined, UnitConverter, UnitInfo (+21 more)

### Community 57 - "PlanView"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "FavoritesView"
Cohesion: 0.29
Nodes (6): FavoritesPreviews, .previews, FavoritesView, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView

### Community 61 - ".body"
Cohesion: 0.30
Nodes (3): PlanView, .body, .body

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
Cohesion: 0.10
Nodes (15): MultiTitledHeader, .body, ConfettiSwiftUI, Kingfisher, PlanView_Previews, .previews, TypingEffectView_Previews, .previews (+7 more)

### Community 69 - "RecipesView"
Cohesion: 0.22
Nodes (6): .view, RecipesView, .body, .placeholderCollectionView, RecipesView_Previews, .previews

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 76 - "DateStatus"
Cohesion: 0.18
Nodes (6): Array, DateStatus, future, past, today, tomorrow

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
Nodes (8): SubscriptionPlan, lifetime, monthly, yearly, RevenueCat, StoreKit, UltimateRecipeHub, .body

### Community 90 - "AlertState"
Cohesion: 0.50
Nodes (4): AlertState, none, override, remove

## Knowledge Gaps
- **218 isolated node(s):** `.setting`, `UserNotifications`, `.body`, `.isServingsLocked`, `.servingsBinding` (+213 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 366 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **31 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `IconButton`, `PlanDayView`, `.body`, `CodingKeys`, `PaywallButton`, `EmptyRecipeSlot`, `Text`, `RatingPromptManager`, `RoundedButton`, `Color`, `RoundedButton`, `FoodSensitivity`, `RecipeModel`, `User`, `.updateRecipe`, `SavedRecipesView`, `View`, `NewPaywallView`, `Array`, `CategoryCollection`, `ProcessedRecipe`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `.show`, `Tab`, `.formatPrice`, `Goal`, `.purchase`, `MealType`, `PlanView`, `.show`, `SavedSourceCard`, `RecipeCard.swift`, `WaterProgressView`, `PreviewProvider`, `CodingKeys`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`, `SubscriptionPlan`?**
  _High betweenness centrality (0.269) - this node is a cross-community bridge._
- **Are the 95 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 95 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.setting`, `UserNotifications`, `.body` to the rest of the system?**
  _218 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.11695906432748537 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `RatingPromptManager` to `PlanDayView`, `String`, `.migrateToRecipeAmounts`, `SwiftUI`, `.body`, `PaywallButton`, `EmptyRecipeSlot`, `Text`, `GroceriesView`, `RoundedButton`, `Color`, `.body`, `RoundedButton`, `FoodSensitivity`, `GroceriesView.swift`, `GroceriesManager`, `String`, `RecipeModel`, `User`, `.body`, `SavedRecipesView`, `LaunchAnimationView`, `View`, `NewPaywallView`, `CategoryCollection`, `ProcessedRecipe`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `.show`, `Tab`, `MealPlanManager`, `String`, `.purchase`, `MealType`, `UnitConverter`, `PlanView`, `.show`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `RecipeCard.swift`, `WaterProgressView`, `RecipesView`?**
  _High betweenness centrality (0.212) - this node is a cross-community bridge._
- **Should `.body` be split into smaller, more focused modules?**
  _Cohesion score 0.06387921022067364 - nodes in this community are weakly interconnected._
- **Why does `GroceriesView` connect `GroceriesView` to `ProcessedRecipe`, `RecipesView`, `.show`, `RatingPromptManager`, `Color`, `String`, `GroceriesView.swift`, `GroceriesManager`, `View`?**
  _High betweenness centrality (0.088) - this node is a cross-community bridge._