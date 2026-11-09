# Graph Report - The Ultimate Recipe Hub  (2026-11-09)

## Corpus Check
- 900 files · ~236,322 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1312 nodes · 3296 edges · 95 communities (68 shown, 27 thin omitted)
- Extraction: 89% EXTRACTED · 11% INFERRED · 0% AMBIGUOUS · INFERRED: 351 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `03a45867`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- NotificationManager
- IconButton
- PlanDayView
- String
- GroceryPickerSheet
- SwiftUI
- .body
- CodingKeys
- PaywallButton
- EmptyRecipeSlot
- Text
- GroceriesView
- RatingPromptManager
- GroceryItem
- Color
- .body
- RoundedButton
- PaywallTrigger
- FoodSensitivity
- GroceriesView.swift
- GroceriesManager
- IngredientMentions
- RecipeModel
- User
- RecipeCollection
- .body
- .body
- RateUsView
- .show
- LaunchAnimationView
- View
- NewPaywallView
- Foundation
- MealPlanManager
- NewPaywallView.swift
- ProcessedRecipe
- ExternalSourceManager
- FoodPreference
- MealPlanManager.swift
- SubscriptionManager
- OnboardTypingEffectView
- MetadataFetcher
- SavedRestaurantsView
- Tab
- .formatPrice
- RecipeCollectionManager
- SwiftUI
- MealPlanManager
- String
- BannerCollectionView
- SafariView
- Goal
- .purchase
- MealType
- UnitConverter
- String
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
- RecipeDetailView
- CodingKeys
- CLAUDE.md
- ObservableObject
- Pause
- DateStatus
- SaveExternalSourceCardView
- DifficultyType
- SubscriptionType
- .highlightedSteps
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
- `.body` --calls--> `RichButton`  [INFERRED]
  Pages/Recipe/AddToMealPlanFooter.swift → Components/RichButton.swift
- `.progress` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift
- `.recipeNamesOnList` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift
- `.visibleGroceries` --references--> `GroceriesManager`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/GroceriesManager.swift

## Import Cycles
- None detected.

## Communities (95 total, 27 thin omitted)

### Community 1 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 2 - "PlanDayView"
Cohesion: 0.23
Nodes (6): PlanDayView, .allSlotsFilled, .areAllSlotsNotFilled, .body, .expandedContent, .headerSection

### Community 3 - "String"
Cohesion: 0.26
Nodes (3): GroceryDisplay, GroceryFormatter, .display

### Community 4 - "GroceryPickerSheet"
Cohesion: 0.17
Nodes (10): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .items, .scale (+2 more)

### Community 5 - "SwiftUI"
Cohesion: 0.09
Nodes (8): OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body, OnboardingPreferencesPage, OnboardingSensitivityPage, OnBoardingView, .body

### Community 6 - ".body"
Cohesion: 0.08
Nodes (9): FavoriteRecipesManager, DirectionView, .cookingServingsText, RecipeDetails, .body, .listScale, .listServingsText, SharedViewModel (+1 more)

### Community 7 - "CodingKeys"
Cohesion: 0.06
Nodes (34): CodingKeys, altAmount, altApprox, altEach, altUnit, calories, cookTime, cuisine (+26 more)

### Community 8 - "PaywallButton"
Cohesion: 0.17
Nodes (8): LoadingPlaceholder, PaywallButton, .cardRow, .selectionTick, .showsBadge, .showsRecommended, .showsSelected, View

### Community 9 - "EmptyRecipeSlot"
Cohesion: 0.50
Nodes (4): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews

### Community 10 - "Text"
Cohesion: 0.08
Nodes (25): Text, CheckableButton, .body, .rowContent, .body, ConversionNoteView, .body, IngredientLineBox (+17 more)

### Community 11 - "GroceriesView"
Cohesion: 0.08
Nodes (20): GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem, .emptyArtAndTitle (+12 more)

### Community 12 - "RatingPromptManager"
Cohesion: 0.12
Nodes (14): Bool, Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays (+6 more)

### Community 13 - "GroceryItem"
Cohesion: 0.27
Nodes (3): GroceryItem, .editableText, RecipeAmount

### Community 14 - "Color"
Cohesion: 0.07
Nodes (24): MultipleSelectionRichButton, .body, MultipleSelectionRichButtonRed, .body, IconTextButton, .body, LightTextButton, .body (+16 more)

### Community 15 - ".body"
Cohesion: 0.20
Nodes (5): DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body

### Community 16 - "RoundedButton"
Cohesion: 0.12
Nodes (9): RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body, .body, SegmentedProgressBar (+1 more)

### Community 17 - "PaywallTrigger"
Cohesion: 0.10
Nodes (18): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+10 more)

### Community 18 - "FoodSensitivity"
Cohesion: 0.11
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 20 - "GroceriesView.swift"
Cohesion: 0.15
Nodes (10): AddItemTip, .body, .addItemBar, GroceriesView_Previews, .previews, OnUserScroll, RecipeRemoval, .buttonTitle (+2 more)

### Community 21 - "GroceriesManager"
Cohesion: 0.14
Nodes (6): groceries, GroceriesManager, .freeSlotsLeft, .allCheckedView, .body, .hasCheckedItemsToToggle

### Community 23 - "RecipeModel"
Cohesion: 0.23
Nodes (15): Array, Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType (+7 more)

### Community 25 - "RecipeCollection"
Cohesion: 0.29
Nodes (5): RecipeCollection, RecipeCollectionsResponse, CollectionDetailsView, CollectionView, .body

### Community 26 - ".body"
Cohesion: 0.17
Nodes (8): SeeAllLabel, .body, ExternalCollectionView, .body, SeeAllCard, .body, SeeAllCard_Previews, .previews

### Community 27 - ".body"
Cohesion: 0.15
Nodes (10): AlertToast, LoadingView, .body, MainView, .body, ContentView, .body, Save_Previews (+2 more)

### Community 28 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 29 - ".show"
Cohesion: 0.27
Nodes (4): Saved_Previews, .previews, SavedRecipesView, .body

### Community 30 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 31 - "View"
Cohesion: 0.26
Nodes (8): RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, RoundedImage, .body

### Community 32 - "NewPaywallView"
Cohesion: 0.14
Nodes (13): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footerDot, .footnote, .footnoteText (+5 more)

### Community 34 - "MealPlanManager"
Cohesion: 0.19
Nodes (3): CategoryCollection, MealPlanManager, ReplaceMode

### Community 35 - "NewPaywallView.swift"
Cohesion: 0.22
Nodes (8): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, PaywallSelection, firstPackage, secondPackage, thirdPackage

### Community 36 - "ProcessedRecipe"
Cohesion: 0.46
Nodes (4): ProcessedRecipe, RecipeSourceManager, .body, RecipeCard

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

### Community 43 - "SavedRestaurantsView"
Cohesion: 0.21
Nodes (4): SavedRestaurantsView, .body, SearchTextField, .body

### Community 44 - "Tab"
Cohesion: 0.16
Nodes (10): HomeSelectionManager, HomeView, .body, SuccessView_Previews, .previews, Tab, favorites, .icon (+2 more)

### Community 45 - ".formatPrice"
Cohesion: 0.25
Nodes (3): .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 46 - "RecipeCollectionManager"
Cohesion: 0.33
Nodes (4): CollectionType, collections, popularCollections, RecipeCollectionManager

### Community 47 - "SwiftUI"
Cohesion: 0.12
Nodes (10): MultiTitledHeader, .body, Kingfisher, OnboardingPageContent, .body, AddToMealPlanFooter, .body, RecipeTagGridView (+2 more)

### Community 48 - "MealPlanManager"
Cohesion: 0.15
Nodes (7): DailyMeals, MealEntry, MealPlanLoader, WaterChallengeEntry, WeeklyMeals, .body, Date

### Community 49 - "String"
Cohesion: 0.14
Nodes (10): recipes, .groceriesListView, .recipeSections, GroceryRow, .body, .menuItems, .rowButton, .servingsSuffix (+2 more)

### Community 52 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 53 - ".purchase"
Cohesion: 0.29
Nodes (3): .bottomSection, .body, PaywallStyle

### Community 54 - "MealType"
Cohesion: 0.11
Nodes (14): .body, FindRecipesManager, MealSlot, .isEaten, .isFilled, .isPro, MealType, breakfast (+6 more)

### Community 55 - "UnitConverter"
Cohesion: 0.09
Nodes (29): Kind, length, volume, weight, Measure, .combined, UnitConverter, UnitInfo (+21 more)

### Community 56 - "String"
Cohesion: 0.33
Nodes (3): HydrationMessageManager, String, .capitalizedWords

### Community 57 - "PlanView"
Cohesion: 0.25
Nodes (6): AlertState, create, none, override, remove, PlanPageMenuButton

### Community 59 - "FavoritesView"
Cohesion: 0.40
Nodes (4): FavoritesView, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView

### Community 61 - ".body"
Cohesion: 0.23
Nodes (5): .view, TabVisibilityManager, PlanView, .body, .body

### Community 64 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 65 - "RecipeCard.swift"
Cohesion: 0.27
Nodes (7): RecipeAction, .body, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 67 - "WaterProgressView"
Cohesion: 0.21
Nodes (4): WaterProgressView, .body, WaterWave, .animatableData

### Community 68 - "PreviewProvider"
Cohesion: 0.10
Nodes (14): ConfettiSwiftUI, NutritionalInfoView_Previews, .previews, PlanView_Previews, .previews, TypingEffectView_Previews, .previews, FavoritesPreviews (+6 more)

### Community 69 - "RecipesView"
Cohesion: 0.33
Nodes (3): RecipesView, .body, .placeholderCollectionView

### Community 70 - "RecipeDetailView"
Cohesion: 0.21
Nodes (8): RecipeComparisonView, .body, RecipeDetailView, RecipeDetailView_Previews, ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 71 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 73 - "ObservableObject"
Cohesion: 0.25
Nodes (5): LoadingVisibilityManager, ToastType, error, success, ToastVisibilityManager

### Community 75 - "Pause"
Cohesion: 0.33
Nodes (6): Pause, closedCookingMode, closedReplaceScreen, leftRecipe, openedPlanPage, switchedTab

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

### Community 80 - ".highlightedSteps"
Cohesion: 0.39
Nodes (3): DirectionsView, .body, HighlightedStepsBox

### Community 87 - "SubscriptionPlan"
Cohesion: 0.17
Nodes (8): SubscriptionPlan, lifetime, monthly, yearly, RevenueCat, StoreKit, UltimateRecipeHub, .body

### Community 90 - "AlertState"
Cohesion: 0.50
Nodes (4): AlertState, none, override, remove

## Knowledge Gaps
- **218 isolated node(s):** `.placeholderCollectionView`, `.setting`, `.body`, `.isServingsLocked`, `.servingsBinding` (+213 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 365 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **27 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `IconButton`, `PlanDayView`, `GroceryPickerSheet`, `.body`, `CodingKeys`, `PaywallButton`, `EmptyRecipeSlot`, `Text`, `RatingPromptManager`, `Color`, `.body`, `RoundedButton`, `FoodSensitivity`, `IngredientMentions`, `RecipeModel`, `User`, `RecipeCollection`, `.show`, `LaunchAnimationView`, `View`, `NewPaywallView`, `MealPlanManager`, `ProcessedRecipe`, `ExternalSourceManager`, `FoodPreference`, `MealPlanManager.swift`, `SubscriptionManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `SavedRestaurantsView`, `Tab`, `.formatPrice`, `RecipeCollectionManager`, `SwiftUI`, `Goal`, `.purchase`, `MealType`, `PlanView`, `.show`, `SavedSourceCard`, `RecipeCard.swift`, `WaterProgressView`, `RecipeDetailView`, `CodingKeys`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`, `.highlightedSteps`, `SubscriptionPlan`?**
  _High betweenness centrality (0.279) - this node is a cross-community bridge._
- **Are the 95 inferred relationships involving `Text` (e.g. with `.body` and `.body`) actually correct?**
  _`Text` has 95 INFERRED edges - model-reasoned connections that need verification._
- **What connects `.placeholderCollectionView`, `.setting`, `.body` to the rest of the system?**
  _218 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `SwiftUI` be split into smaller, more focused modules?**
  _Cohesion score 0.09486166007905138 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `RatingPromptManager` to `PlanDayView`, `String`, `GroceryPickerSheet`, `SwiftUI`, `.body`, `PaywallButton`, `EmptyRecipeSlot`, `Text`, `GroceriesView`, `GroceryItem`, `Color`, `.body`, `RoundedButton`, `FoodSensitivity`, `GroceriesView.swift`, `GroceriesManager`, `IngredientMentions`, `RecipeModel`, `User`, `RecipeCollection`, `.show`, `LaunchAnimationView`, `View`, `NewPaywallView`, `Foundation`, `MealPlanManager`, `ProcessedRecipe`, `ExternalSourceManager`, `SubscriptionManager`, `MetadataFetcher`, `SavedRestaurantsView`, `MealPlanManager`, `String`, `.purchase`, `MealType`, `UnitConverter`, `PlanView`, `.show`, `.body`, `SavedSourceCard`, `RateUsPrePromptVisibilityManager`, `WaterProgressView`, `RecipesView`, `RecipeDetailView`, `.random`?**
  _High betweenness centrality (0.233) - this node is a cross-community bridge._
- **Should `.body` be split into smaller, more focused modules?**
  _Cohesion score 0.08377896613190731 - nodes in this community are weakly interconnected._
- **Why does `SwiftUI` connect `SwiftUI` to `IconButton`, `String`, `GroceryPickerSheet`, `SwiftUI`, `PaywallButton`, `EmptyRecipeSlot`, `Text`, `Color`, `.body`, `RoundedButton`, `FoodSensitivity`, `GroceriesView.swift`, `RecipeCollection`, `.body`, `.body`, `RateUsView`, `.show`, `LaunchAnimationView`, `View`, `Foundation`, `NewPaywallView.swift`, `ExternalSourceManager`, `OnboardTypingEffectView`, `MetadataFetcher`, `SavedRestaurantsView`, `Tab`, `BannerCollectionView`, `SafariView`, `UnitConverter`, `String`, `OnboardingHealtyMealPage`, `RateUsPrePromptVisibilityManager`, `FTMealPlanGenerateView`, `RecipeCard.swift`, `WaterProgressView`, `PreviewProvider`, `RecipeDetailView`, `DateStatus`, `SaveExternalSourceCardView`, `.highlightedSteps`, `SubscriptionPlan`?**
  _High betweenness centrality (0.066) - this node is a cross-community bridge._