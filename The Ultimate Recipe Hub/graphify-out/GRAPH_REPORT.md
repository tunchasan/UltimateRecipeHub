# Graph Report - The Ultimate Recipe Hub  (2026-11-07)

## Corpus Check
- 898 files · ~229,840 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 1221 nodes · 2934 edges · 80 communities (58 shown, 22 thin omitted)
- Extraction: 91% EXTRACTED · 9% INFERRED · 0% AMBIGUOUS · INFERRED: 259 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `38ff1273`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Bool
- String
- Color
- LaunchAnimationView
- RecipeCard
- Date
- GroceriesManager
- SwiftUI
- RecipeCollectionManager
- CodingKeys
- .show
- .body
- MealPlanManager
- GroceriesView
- GroceryItem
- GroceryPickerSheet
- GroceriesView.swift
- RoundedButton
- .body
- ProcessedRecipe
- FoodSensitivity
- OnboardTypingEffectView
- SubscriptionManager
- RecipeModel
- NewPaywallView
- ObservableObject
- .show
- RecipeCollectionType
- .body
- User
- RateUsView
- IconButton
- WaterProgressView
- MetadataFetcher
- ExternalSourceManager
- FoodPreference
- PreviewProvider
- View
- .purchase
- SavedRestaurantsView
- GroceryRow
- Foundation
- MultipleSelectionRichButton
- RecipeDetailView
- .formatPrice
- SafariView
- Goal
- SubscriptionPlan
- NewPaywallView.swift
- MealType
- TrackScrolling
- ServingsStepper
- .body
- FTMealPlanGenerateView
- OnboardingHealtyMealPage
- DateStatus
- SavedSourceCard
- CodingKeys
- .updateRecipe
- SaveExternalSourceCardView
- MealPlanLoader
- DifficultyType
- SubscriptionType
- AlertState
- NutritionalInfoView
- RateUsPrePromptVisibilityManager
- FreeTrial

## God Nodes (most connected - your core abstractions)
1. `GroceriesView` - 64 edges
2. `MealPlanManager` - 43 edges
3. `RatingPromptManager` - 40 edges
4. `GroceriesManager` - 38 edges
5. `CodingKeys` - 36 edges
6. `GroceryItem` - 35 edges
7. `NewPaywallView` - 32 edges
8. `RecipeIngredientsGridView` - 30 edges
9. `User` - 30 edges
10. `MealSlot` - 30 edges

## Surprising Connections (you probably didn't know these)
- `.body` --calls--> `RoundedButton`  [INFERRED]
  OnboardingMealPlanPage.swift → Components/RoundedButton.swift
- `.emptyStateView` --calls--> `RoundedButton`  [INFERRED]
  Pages/Favorites/FavoritesView.swift → Components/RoundedButton.swift
- `.body` --calls--> `RichButton`  [INFERRED]
  Pages/Recipe/AddToMealPlanFooter.swift → Components/RichButton.swift
- `.body` --calls--> `RoundedImage`  [INFERRED]
  Pages/Recipes/Collections/SeeAllCard.swift → RecipeCard.swift
- `.body` --calls--> `Text`  [INFERRED]
  Pages/Groceries/GroceriesView.swift → Logic/Text+ReadableFractions.swift

## Import Cycles
- None detected.

## Communities (80 total, 22 thin omitted)

### Community 0 - "Bool"
Cohesion: 0.06
Nodes (29): Bool, Counter, aiCoachSwaps, eatenMeals, favoritesAdded, groceryRecipes, planAdds, waterGoalDays (+21 more)

### Community 1 - "String"
Cohesion: 0.06
Nodes (19): GroceryFormatter, HydrationMessageManager, String, .capitalizedWords, DirectionsView, .body, HighlightedStepsBox, IngredientMentions (+11 more)

### Community 2 - "Color"
Cohesion: 0.19
Nodes (16): IconTextButton, .body, LightTextButton, .body, RichButton, .body, RichLockedTextButton, .body (+8 more)

### Community 3 - "LaunchAnimationView"
Cohesion: 0.08
Nodes (8): RoundedCorner, View, AppleShape, LaunchAnimationView, .body, LaunchClock, ImageCache, UIKit

### Community 4 - "RecipeCard"
Cohesion: 0.27
Nodes (8): RecipeAction, .body, RecipeCard, RecipeCard_Previews, RecipeTitle, .body, RecommendedPlanCardView, .body

### Community 5 - "Date"
Cohesion: 0.13
Nodes (13): EmptyRecipeSlot, .isPastDay, EmptyRecipeSlot_Previews, .previews, MealSlot, .isEaten, .isFilled, .isPro (+5 more)

### Community 6 - "GroceriesManager"
Cohesion: 0.15
Nodes (9): GroceriesManager, .freeSlotsLeft, .allCheckedView, .body, .hasCheckedItemsToToggle, .progress, .recipeNamesOnList, .visibleGroceries (+1 more)

### Community 7 - "SwiftUI"
Cohesion: 0.10
Nodes (11): MultiTitledHeader, .body, Kingfisher, OnboardingCookingSkillPage, OnboardingGoalPage, OnboardingMealPlanPage, .body, OnboardingPreferencesPage (+3 more)

### Community 8 - "RecipeCollectionManager"
Cohesion: 0.05
Nodes (30): Tab, favorites, .icon, plan, .title, .view, CollectionType, collections (+22 more)

### Community 9 - "CodingKeys"
Cohesion: 0.07
Nodes (30): CodingKeys, calories, cookTime, cuisine, description, difficulty, dishType, duration (+22 more)

### Community 10 - ".show"
Cohesion: 0.07
Nodes (24): PaywallTrigger, attemptAddExternalRecipeOver1, attemptAddExternalRestaurantOver1, attemptAddRecipeToFavoritesOver3, attemptDisplayDayPlanMacros, attemptDisplayRecipeMacros, attemptGenerateNextDayPlan, attemptGenerateTodayPlanOnceAgain (+16 more)

### Community 11 - ".body"
Cohesion: 0.05
Nodes (20): FavoriteRecipesManager, FavoritesPreviews, .previews, FavoritesView, .body, .emptyArtAndTitle, .emptyArtWidth, .emptyStateView (+12 more)

### Community 12 - "MealPlanManager"
Cohesion: 0.17
Nodes (9): DailyMeals, MealEntry, MealPlanManager, ReplaceMode, WaterChallengeEntry, WeeklyMeals, .body, .body (+1 more)

### Community 13 - "GroceriesView"
Cohesion: 0.08
Nodes (20): recipes, GroceriesMenuButton, .body, GroceriesView, .addItemButton, .addItemFieldRow, .allCheckedMessage, .canSubmitNewItem (+12 more)

### Community 14 - "GroceryItem"
Cohesion: 0.17
Nodes (5): groceries, GroceryDisplay, GroceryItem, .display, .editableText

### Community 15 - "GroceryPickerSheet"
Cohesion: 0.18
Nodes (9): ChecklistItem, GroceryPickerSheet, .baseServings, .body, .header, .isUpdate, .scale, IngredientChecklist (+1 more)

### Community 16 - "GroceriesView.swift"
Cohesion: 0.15
Nodes (11): AddItemTip, .body, CheckableButton, .body, .addItemBar, GroceriesView_Previews, .previews, OnUserScroll (+3 more)

### Community 17 - "RoundedButton"
Cohesion: 0.12
Nodes (9): RoundedButton, .body, SingleSelectionRichButton, .body, .body, .body, .body, SegmentedProgressBar (+1 more)

### Community 18 - ".body"
Cohesion: 0.14
Nodes (10): AlertState, create, none, override, remove, PlanPageMenuButton, PlanView, .body (+2 more)

### Community 19 - "ProcessedRecipe"
Cohesion: 0.19
Nodes (4): CategoryCollection, ProcessedRecipe, RecipeSourceManager, FindRecipesManager

### Community 20 - "FoodSensitivity"
Cohesion: 0.10
Nodes (13): FoodSensitivity, avoidAlcohol, avoidChicken, avoidDairy, avoidEgg, avoidFruit, avoidGrains, avoidMeat (+5 more)

### Community 21 - "OnboardTypingEffectView"
Cohesion: 0.29
Nodes (4): OnboardingAICoachPage, .body, OnboardTypingEffectView, .body

### Community 23 - "RecipeModel"
Cohesion: 0.23
Nodes (15): Array, Ingredient, Macros, ProcessedDetails, ProcessedInformations, RecipeModel, .combinedTags, .difficultyType (+7 more)

### Community 24 - "NewPaywallView"
Cohesion: 0.12
Nodes (13): NewPaywallView, .body, .compactHeroHeight, .continueButtonText, .featureList, .footerDot, .footnote, .footnoteText (+5 more)

### Community 25 - "ObservableObject"
Cohesion: 0.29
Nodes (3): LoadingVisibilityManager, TabVisibilityManager, .body

### Community 26 - ".show"
Cohesion: 0.21
Nodes (6): Saved_Previews, .previews, SavedRecipesView, .body, SearchTextField, .body

### Community 27 - "RecipeCollectionType"
Cohesion: 0.18
Nodes (10): MealPlanCollectionLoader, MealSlot.MealType, .collectionType, RecipeCollectionType, breakfast, dinner, lunch, sideBreakfast (+2 more)

### Community 28 - ".body"
Cohesion: 0.11
Nodes (11): AlertToast, LoadingView, .body, NotificationManager, MainView, .body, ContentView, .body (+3 more)

### Community 29 - "User"
Cohesion: 0.15
Nodes (3): User, OnboardingSensitivityPage, .body

### Community 30 - "RateUsView"
Cohesion: 0.40
Nodes (4): RateUsPreviews, .previews, RateUsView, .body

### Community 31 - "IconButton"
Cohesion: 0.18
Nodes (9): IconButton, .body, .headerButtons, PaywallExample, .body, PaywallExample_Previews, .previews, PaywallView (+1 more)

### Community 32 - "WaterProgressView"
Cohesion: 0.21
Nodes (4): WaterProgressView, .body, WaterWave, .animatableData

### Community 33 - "MetadataFetcher"
Cohesion: 0.19
Nodes (5): ExternalCollectionRecipeCard, .body, MetadataFetcher, WebpageMetadata, SwiftSoup

### Community 35 - "FoodPreference"
Cohesion: 0.15
Nodes (12): CookingSkill, advanced, beginner, intermediate, FoodPreference, flexible, glutenFree, halal (+4 more)

### Community 36 - "PreviewProvider"
Cohesion: 0.14
Nodes (10): HomeSelectionManager, HomeView, .body, SuccessView_Previews, .previews, ToastType, error, success (+2 more)

### Community 37 - "View"
Cohesion: 0.21
Nodes (10): ConfettiSwiftUI, RecipePlanCard, .body, RecipePlanCard_Previews, .previews, RecipePlanCardBadges, .body, DirectionView_Previews (+2 more)

### Community 38 - ".purchase"
Cohesion: 0.29
Nodes (3): .bottomSection, .body, PaywallStyle

### Community 39 - "SavedRestaurantsView"
Cohesion: 0.27
Nodes (4): SavedRestaurant_Previews, .previews, SavedRestaurantsView, .body

### Community 41 - "GroceryRow"
Cohesion: 0.18
Nodes (9): Text, .emptyArtAndTitle, .progressPill, GroceryRow, .body, .menuItems, .rowButton, .rowContent (+1 more)

### Community 42 - "Foundation"
Cohesion: 0.15
Nodes (5): Combine, Foundation, OnboardingPageContent, .body, ExternalSource

### Community 43 - "MultipleSelectionRichButton"
Cohesion: 0.21
Nodes (4): MultipleSelectionRichButton, .body, MultipleSelectionRichButtonRed, .body

### Community 44 - "RecipeDetailView"
Cohesion: 0.21
Nodes (8): RecipeComparisonView, .body, RecipeDetailView, RecipeDetailView_Previews, ReplaceRecipe, .body, ReplacingInfoView, .body

### Community 45 - ".formatPrice"
Cohesion: 0.29
Nodes (6): SubscriptionManager, .isDebugFreeForced, .isDebugProForced, .continueButtonSubText, .isSelectedPlanLoaded, .planCards

### Community 47 - "Goal"
Cohesion: 0.22
Nodes (9): Goal, buildHealthierHabits, eatHealthy, gainWeight, loseWeight, maintainWeight, none, planWeeklyMeals (+1 more)

### Community 48 - "SubscriptionPlan"
Cohesion: 0.25
Nodes (6): SubscriptionPlan, lifetime, monthly, yearly, RevenueCat, StoreKit

### Community 49 - "NewPaywallView.swift"
Cohesion: 0.22
Nodes (8): NewPaywallExample, .body, NewPaywallExample_Previews, .previews, PaywallSelection, firstPackage, secondPackage, thirdPackage

### Community 50 - "MealType"
Cohesion: 0.22
Nodes (8): MealType, breakfast, dinner, .displayName, lunch, sideBreakfast, sideDinner, sideLunch

### Community 52 - "ServingsStepper"
Cohesion: 0.31
Nodes (4): ServingsStepper, .body, .maxServings, .proBadge

### Community 53 - ".body"
Cohesion: 0.18
Nodes (5): DirectionState, emptySlot, filledSlot, FindSuitableRecipesView, .body

### Community 54 - "FTMealPlanGenerateView"
Cohesion: 0.32
Nodes (6): FTMealPlanGenerateView, .body, NonDismissableSheetExample, .body, NonDismissableSheetExample_Previews, .previews

### Community 56 - "DateStatus"
Cohesion: 0.18
Nodes (6): Array, DateStatus, future, past, today, tomorrow

### Community 58 - "CodingKeys"
Cohesion: 0.33
Nodes (5): CodingKeys, processedDetails, processedRecipesEasy, processedRecipesHard, processedRecipesIntermediate

### Community 60 - "SaveExternalSourceCardView"
Cohesion: 0.40
Nodes (4): SaveExternalRecipeCardView_Preview, .previews, SaveExternalSourceCardView, .body

### Community 62 - "DifficultyType"
Cohesion: 0.50
Nodes (4): DifficultyType, advanced, beginner, intermediate

### Community 63 - "SubscriptionType"
Cohesion: 0.50
Nodes (4): .subscriptionType, SubscriptionType, free, pro

### Community 64 - "AlertState"
Cohesion: 0.50
Nodes (4): AlertState, none, override, remove

### Community 65 - "NutritionalInfoView"
Cohesion: 0.29
Nodes (4): NutritionalInfoView, .body, NutritionalInfoView_Previews, .previews

### Community 68 - "FreeTrial"
Cohesion: 0.40
Nodes (3): FreeTrial, .badgeText, .buttonText

## Knowledge Gaps
- **222 isolated node(s):** `.emptyArtTopPadding`, `.emptyArtWidth`, `.allCheckedMessage`, `.addItemButton`, `.fieldPlaceholder` (+217 more)
  These have ≤1 connection - possible missing edges. (Counts symbols only; 363 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **22 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `String` connect `String` to `Bool`, `Color`, `LaunchAnimationView`, `RecipeCard`, `Date`, `GroceriesManager`, `SwiftUI`, `RecipeCollectionManager`, `CodingKeys`, `.show`, `.body`, `GroceriesView`, `GroceryItem`, `GroceryPickerSheet`, `GroceriesView.swift`, `RoundedButton`, `.body`, `ProcessedRecipe`, `FoodSensitivity`, `OnboardTypingEffectView`, `SubscriptionManager`, `RecipeModel`, `NewPaywallView`, `.show`, `RecipeCollectionType`, `User`, `IconButton`, `WaterProgressView`, `MetadataFetcher`, `ExternalSourceManager`, `FoodPreference`, `View`, `.purchase`, `SavedRestaurantsView`, `GroceryRow`, `Foundation`, `MultipleSelectionRichButton`, `RecipeDetailView`, `.formatPrice`, `Goal`, `SubscriptionPlan`, `MealType`, `ServingsStepper`, `.body`, `SavedSourceCard`, `CodingKeys`, `.updateRecipe`, `SaveExternalSourceCardView`, `DifficultyType`, `SubscriptionType`, `FreeTrial`, `.addCustomItem`?**
  _High betweenness centrality (0.414) - this node is a cross-community bridge._
- **What connects `.emptyArtTopPadding`, `.emptyArtWidth`, `.allCheckedMessage` to the rest of the system?**
  _222 weakly-connected nodes found - possible missing edges._
- **Should `Bool` be split into smaller, more focused modules?**
  _Cohesion score 0.06335403726708075 - nodes in this community are weakly interconnected._
- **Why does `Bool` connect `Bool` to `String`, `Color`, `LaunchAnimationView`, `RecipeCard`, `Date`, `GroceriesManager`, `SwiftUI`, `RecipeCollectionManager`, `.show`, `.body`, `MealPlanManager`, `GroceriesView`, `GroceryItem`, `GroceryPickerSheet`, `GroceriesView.swift`, `RoundedButton`, `.body`, `ProcessedRecipe`, `FoodSensitivity`, `RecipeModel`, `NewPaywallView`, `ObservableObject`, `.show`, `User`, `WaterProgressView`, `MetadataFetcher`, `ExternalSourceManager`, `View`, `.purchase`, `SavedRestaurantsView`, `GroceryRow`, `Foundation`, `MultipleSelectionRichButton`, `RecipeDetailView`, `.formatPrice`, `TrackScrolling`, `ServingsStepper`, `.body`, `SavedSourceCard`, `NutritionalInfoView`, `RateUsPrePromptVisibilityManager`, `.addCustomItem`?**
  _High betweenness centrality (0.162) - this node is a cross-community bridge._
- **Should `String` be split into smaller, more focused modules?**
  _Cohesion score 0.05636114911080711 - nodes in this community are weakly interconnected._
- **Why does `SwiftUI` connect `SwiftUI` to `Bool`, `String`, `Color`, `LaunchAnimationView`, `RecipeCard`, `Date`, `RecipeCollectionManager`, `.show`, `.body`, `GroceryItem`, `GroceryPickerSheet`, `GroceriesView.swift`, `RoundedButton`, `.body`, `FoodSensitivity`, `OnboardTypingEffectView`, `.show`, `.body`, `User`, `RateUsView`, `IconButton`, `WaterProgressView`, `MetadataFetcher`, `ExternalSourceManager`, `PreviewProvider`, `View`, `SavedRestaurantsView`, `GroceryRow`, `Foundation`, `MultipleSelectionRichButton`, `RecipeDetailView`, `SafariView`, `SubscriptionPlan`, `NewPaywallView.swift`, `ServingsStepper`, `.body`, `FTMealPlanGenerateView`, `OnboardingHealtyMealPage`, `DateStatus`, `SaveExternalSourceCardView`, `NutritionalInfoView`, `RateUsPrePromptVisibilityManager`?**
  _High betweenness centrality (0.065) - this node is a cross-community bridge._
- **Should `LaunchAnimationView` be split into smaller, more focused modules?**
  _Cohesion score 0.08156028368794327 - nodes in this community are weakly interconnected._