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
                        replaceRecipeClick: {
                            openSecondPage = true
                        },
                        replacedRecipeClick: {
                            openFirstPage = true
                        }
                    )
                    
                    ReplacingInfoView()
                }
                .padding()
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
                .font(.system(size: 28))
                .opacity(0.75)
            
            RecipeDetailView(
                recipe: replaceMode.replaceRecipe!.recipe,
                compressionRecipe: replaceMode.replacedRecipe!.recipe) {
                    replaceRecipeClick()
                }
            
        }
    }
}

struct RecipeDetailView: View {
    let recipe: RecipeModel
    let compressionRecipe: RecipeModel
    var action: ()-> Void
    
    var body: some View {
        VStack(spacing: 15) {
            Button(action: {
                action()
            }, label: {
                Image(recipe.name)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                    .clipped()
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.75), radius: 3)
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
