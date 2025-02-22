//
//  RecipeIngredientsGridView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct RecipeIngredientsGridView: View {
    @ObservedObject var viewModel: SharedViewModel
    var ingredients: [(Double, String, String)] // (Amount, Unit, Name)
    var servingValue: Double
    
    var isScaleVisible: Bool = true
    var isPaywallActionable: Bool = true

    @State var isSliderDisable: Bool = false
    @State var isSliderVisible: Bool = false
    @State private var shakeOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Section Title with Scale Button
            HStack {
                Text("Ingredients")
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                if isScaleVisible {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isSliderVisible.toggle()
                        }
                    }) {
                        HStack(spacing: 0) {
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: 18).bold())
                                .foregroundColor(.green)
                                .padding(.horizontal, 10)
                            
                            Text("Scale")
                                .font(.system(size: 16).bold())
                                .foregroundColor(.green)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Scale Slider
            if isSliderVisible {

                VStack(alignment: .leading) {
                    HStack {
                        Text("Scale: \(viewModel.value, specifier: "%.2f")x")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        Text("\(viewModel.value * servingValue, specifier: "%.2f") serving(s)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }
                    
                    Slider(value: $viewModel.value, in: 0.25...10.0, step: 0.25)
                        .padding(.horizontal)
                        .tint(.green)
                        .disabled(isSliderDisable)
                        .offset(x: shakeOffset)
                        .animation(.linear(duration: 0.1), value: shakeOffset) // One-time shake animation
                    
                }
                .padding(.top, 10)
                .onChange(of: viewModel.value, { oldValue, newValue in
                    if User.shared.subscription == .free {
                        
                        if isPaywallActionable {
                            PaywallVisibilityManager.show(triggeredBy: .attemptToScaleRecipeIngredients)
                        }
                        
                        startShakeAnimation()
                        viewModel.value = 1
                    }
                })
            }
            
            // Ingredients List
            VStack {
                ForEach(scaledIngredients, id: \.2) { (amount, unit, name) in
                    HStack(spacing: 5) {
                        // Bullet Point
                        Text("•")
                            .font(.subheadline.bold())
                        
                        // Attributed Ingredient String
                        Text(attributedIngredientString(amount: amount, unit: unit, name: name))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.vertical, 5)
                }
            }
            .padding(.top, isSliderVisible ? 0 : 10)
        }
    }
    
    private func startShakeAnimation() {
        shakeOffset = 10
        isSliderDisable = true
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shakeOffset = -10
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            shakeOffset = 0
            isSliderDisable = false
        }
    }
    
    /// Scaled ingredients based on the `scaleValue`.
    private var scaledIngredients: [(Double, String, String)] {
        return ingredients.map { (amount, unit, name) in
            let scaledAmount = amount * viewModel.value
            return (scaledAmount, unit, name)
        }
    }
    
    /// Generates an attributed ingredient string with colorized amount and unit.
    private func attributedIngredientString(amount: Double, unit: String, name: String) -> AttributedString {
        var attributedString = AttributedString()

        // Format the amount
        let formattedAmount: String
        if amount.truncatingRemainder(dividingBy: 1) == 0 {
            formattedAmount = String(format: "%.0f", amount) // Remove .0 if whole number
        } else if amount < 1 {
            formattedAmount = fractionalString(from: amount) // Convert fractional amounts
        } else {
            formattedAmount = String(format: "%.2f", amount) // Format with 2 decimal points
        }

        // Combine amount and unit if present
        let combinedAmountUnit = amount == 0 ? "" : "\(formattedAmount) \(unit)".trimmingCharacters(in: .whitespaces)

        if !combinedAmountUnit.isEmpty {
            var amountUnitString = AttributedString(combinedAmountUnit)
            amountUnitString.font = .system(size: 14).weight(.bold)
            amountUnitString.foregroundColor = .green
            attributedString += amountUnitString + AttributedString(" ")
        }

        // Add the ingredient name
        var nameString = AttributedString(name)
        nameString.font = .system(size: 14)
        nameString.foregroundColor = .black
        attributedString += nameString

        return attributedString
    }

    /// Converts a fractional double to a string representation (e.g., 0.5 -> "1/2").
    private func fractionalString(from value: Double) -> String {
        switch value {
        case 0.5: return "1/2"
        case 0.33: return "1/3"
        case 0.66: return "2/3"
        case 0.25: return "1/4"
        case 0.75: return "3/4"
        default: return String(value)
        }
    }
}

struct RecipeIngredientsGridView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeIngredientsGridView(
            viewModel: SharedViewModel(),
            ingredients: [
                (1, "cup", "Flour"),
                (2, "tbsp", "Sugar"),
                (3, "tsp", "Salt"),
                (0, "", "Butter"),
                (3, "cup", "Milk"),
                (5, "", "Eggs")
            ],
            servingValue: 2
        )
        
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
