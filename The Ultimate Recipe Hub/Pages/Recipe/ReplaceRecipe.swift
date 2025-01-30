//
//  ReplaceRecipe.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct ReplaceRecipe: View {
        
    @State private var openFirstPage: Bool = false
    
    @State private var openSecondPage: Bool = false
    
    var mealPlanner = MealPlanManager.shared
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 20) {
                    RecipeComparisonView(
                        replaceMode: mealPlanner.replaceMode,
                        showSuggestion: mealPlanner.replaceMode.showSuggestion,
                        replaceRecipeClick: {
                            openSecondPage = true
                        },
                        replacedRecipeClick: {
                            openFirstPage = true
                        }
                    )
                    
                    ReplacingInfoView()
                }
                .padding(.top)
                .padding(.horizontal)
                .scrollIndicators(.hidden)
            }
            
            RichButton(
                title: "REPLACE",
                emoji: "",
                backgroundColor: .green,
                minHeight: 43,
                emojiFontSize: 30,
                titleFontSize: 18,
                emojiColor: .white,
                titleColor: .white,
                useSystemImage: false,
                action: { performReplaceAction() }
            )
            .padding([.top, .horizontal])
            .background(Color.gray.opacity(0.1))
        }
        .sheet(isPresented: $openFirstPage, onDismiss: {
            openFirstPage = false
        }) {
            RecipeDetails(
                model: mealPlanner.replaceMode.replacedRecipe!,
                canAddToPlan: false,
                isCookingModeEnable: false
            )
        }
        .sheet(isPresented: $openSecondPage, onDismiss: {
            openSecondPage = false
        }) {
            RecipeDetails(
                model: mealPlanner.replaceMode.replaceRecipe!,
                canAddToPlan: false,
                isCookingModeEnable: false
            )
        }
    }
    
    private func performReplaceAction() {
        MealPlanManager.shared.updateRecipe()
        print("Replace action triggered")
        presentationMode.wrappedValue.dismiss()
    }
}

struct RecipeComparisonView: View {
    
    var replaceMode: ReplaceMode
    
    var showSuggestion: Bool = false
    
    var replaceRecipeClick: ()-> Void
    
    var replacedRecipeClick: ()-> Void
        
    var body: some View {
        VStack(spacing: 20) {
            RecipeDetailView(
                recipe: replaceMode.replacedRecipe!.recipe,
                compressionRecipe: replaceMode.replaceRecipe!.recipe) {
                    replacedRecipeClick()
                }
            
            Image(systemName: "repeat")
                .font(.system(size: 24))
                .opacity(0.5)
            
            RecipeDetailView(
                suggestionBadge: showSuggestion,
                recipe: replaceMode.replaceRecipe!.recipe,
                compressionRecipe: replaceMode.replacedRecipe!.recipe) {
                    replaceRecipeClick()
                }
            
        }
    }
}

struct RecipeDetailView: View {
    var suggestionBadge: Bool = false
    let recipe: RecipeModel
    let compressionRecipe: RecipeModel
    var action: ()-> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                action()
            }, label: {
                ZStack {
                    Image(recipe.name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: UIScreen.main.bounds.height * 0.15)
                        .clipped()
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.75), radius: 3)
                    
                    if suggestionBadge {
                        Text("👨‍🍳  Chef's Suggestion")
                            .font(.subheadline.bold())
                            .foregroundColor(.green)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.25), radius: 1, y:-1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .offset(x: 10, y: -15)
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.15)
            })
            .buttonStyle(PlainButtonStyle())
            
            Text(recipe.name)
                .font(.system(size: 16).bold())
                .frame(maxWidth: .infinity)
                .lineLimit(1)
            
            HStack(spacing: 10) {
                RichTextButton(
                    title: "\(recipe.calories)",
                    subTitle: "Calories",
                    titleColor: recipe.calories > compressionRecipe.calories ? .orange : .green,
                    titleFontSize: 20,
                    action: {}
                )
                RichTextButton(
                    title: "\(recipe.macros.protein)gr",
                    subTitle: "Protein",
                    titleColor: recipe.macros.protein < compressionRecipe.macros.protein ? .orange : .green,
                    titleFontSize: 20,
                    action: {}
                )
                RichTextButton(
                    title: "\(recipe.macros.carbs)gr",
                    subTitle: "Carb",
                    titleColor: recipe.macros.carbs > compressionRecipe.macros.carbs ? .orange : .green,
                    titleFontSize: 20,
                    action: {}
                )
                RichTextButton(
                    title: "\(recipe.macros.fat)gr",
                    subTitle: "Fat",
                    titleColor: recipe.macros.fat > compressionRecipe.macros.fat ? .orange : .green,
                    titleFontSize: 20,
                    action: {}
                )
            }
            .padding(.vertical, 10)
            .background(.white)
            .cornerRadius(15)
            .shadow(radius: 3, x: 1, y: 2)
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(
            suggestionBadge: true,
            recipe: RecipeModel(
                name: "Broccoli, White Bean & Cheddar Bake",
                description: "A rich and hearty Haitian vegetable stew.",
                tag1: ["Dinner", "Hearty"],
                tag2: ["Vegetarian", "Comfort Food"],
                sourceURL: "https://example.com",
                imageURL: "Haitian Legim",
                ratingCount: 125,
                reviewCount: 50,
                rating: 4.8,
                serves: 4,
                subscription: "Pro",
                prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
                cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
                mealType: ["Dinner"],
                dishType: "Stew",
                specialConsideration: ["Vegetarian"],
                preparationType: ["Slow Cooked"],
                ingredientsFilter: ["Vegetables"],
                cuisine: "Haitian",
                difficulty: "Intermediate",
                macros: Macros(carbs: 45, protein: 10, fat: 20),
                ingredients: [
                    Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
                    Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
                ],
                steps: ["Chop vegetables.", "Cook until tender."],
                calories: 200
            ),
            compressionRecipe: RecipeModel(
                name: "BLT Salad",
                description: "A rich and hearty Haitian vegetable stew.",
                tag1: ["Dinner", "Hearty"],
                tag2: ["Vegetarian", "Comfort Food"],
                sourceURL: "https://example.com",
                imageURL: "Haitian Legim",
                ratingCount: 125,
                reviewCount: 50,
                rating: 4.8,
                serves: 4,
                subscription: "Pro",
                prepTime: TimeInfo(duration: 15, timeUnit: "minutes"),
                cookTime: TimeInfo(duration: 45, timeUnit: "minutes"),
                mealType: ["Dinner"],
                dishType: "Stew",
                specialConsideration: ["Vegetarian"],
                preparationType: ["Slow Cooked"],
                ingredientsFilter: ["Vegetables"],
                cuisine: "Haitian",
                difficulty: "Intermediate",
                macros: Macros(carbs: 45, protein: 10, fat: 20),
                ingredients: [
                    Ingredient(ingredientName: "Eggplant", ingredientAmount: 2, ingredientUnit: "pcs"),
                    Ingredient(ingredientName: "Carrot", ingredientAmount: 1, ingredientUnit: "pcs")
                ],
                steps: ["Chop vegetables.", "Cook until tender."],
                calories: 200
            ),
            action: { print("Recipe clicked!") }
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

struct ReplacingInfoView: View {
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: 32).bold())
                .foregroundColor(.orange)
            
            VStack(alignment: .leading) {
                Text(replacingText())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func replacingText() -> AttributedString {
        var attributedString = AttributedString("")
        
        // Access the replaceMode directly
        let replaceMode = MealPlanManager.shared.replaceMode
        
        // Helper to extract the first two words
        func firstTwoWords(from text: String?) -> String {
            guard let text = text else { return "an unknown recipe" }
            let words = text.split(separator: " ").prefix(2)
            return words.joined(separator: " ")
        }
        
        // Extract and format components
        let replacedName = firstTwoWords(from: replaceMode.replacedRecipe?.recipe.name)
        let replacingName = firstTwoWords(from: replaceMode.replaceRecipe?.recipe.name)
        let slotName = replaceMode.replacedSlotType?.displayName ?? "an unknown meal slot"
        let formattedDate = replaceMode.replacedDate?.formatted(as: "d MMMM") ?? "a future date"
        
        // Create the attributed text
        var fullString = AttributedString("You are replacing ")
        attributedString += fullString
        
        var replacedNameAttr = AttributedString(replacedName)
        replacedNameAttr.foregroundColor = .orange
        replacedNameAttr.font = .body.bold()
        attributedString += replacedNameAttr
        
        fullString = AttributedString(" with ")
        attributedString += fullString
        
        var replacingNameAttr = AttributedString(replacingName)
        replacingNameAttr.foregroundColor = .green
        replacingNameAttr.font = .body.bold()
        attributedString += replacingNameAttr
        
        fullString = AttributedString(" for your ")
        attributedString += fullString
        
        var slotAttr = AttributedString(slotName)
        slotAttr.foregroundColor = .black
        slotAttr.font = .body.bold()
        attributedString += slotAttr
        
        fullString = AttributedString(" on ")
        attributedString += fullString
        
        var dateAttr = AttributedString(formattedDate)
        dateAttr.foregroundColor = .black
        dateAttr.font = .body.bold()
        attributedString += dateAttr
        
        return attributedString
    }
}
extension Date {
    /// Formats the date using the specified format string.
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
