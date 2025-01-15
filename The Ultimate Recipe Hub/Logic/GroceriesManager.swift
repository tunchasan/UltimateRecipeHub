//
//  GroceryItem.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 15.01.2025.
//

import SwiftUI
import Combine
import Foundation

struct GroceryItem: Identifiable, Codable {
    let id: UUID // Unique identifier
    let firstText: String
    let secondText: String
    var isChecked: Bool
    
    init(firstText: String, secondText: String, isChecked: Bool = false) {
        self.id = UUID() // Automatically generate a unique ID
        self.firstText = firstText
        self.secondText = secondText
        self.isChecked = isChecked
    }
}

class GroceriesManager: ObservableObject {
    
    // Singleton instance
    static let shared = GroceriesManager()
    
    @Published private(set) var groceries: [GroceryItem] = []
    
    private let userDefaultsKey = "groceries"
    
    init() {
        loadGroceriesFromUserDefaults()
    }
    
    func addGroceries(from ingredients: [Ingredient]) {
        let newGroceries = ingredients.map { ingredient in
            // Format the amount
            let formattedAmount: String
            if ingredient.ingredientAmount.truncatingRemainder(dividingBy: 1) == 0 {
                formattedAmount = String(format: "%.0f", ingredient.ingredientAmount) // Remove .0 if whole number
            } else if ingredient.ingredientAmount < 1 {
                formattedAmount = fractionalString(from: ingredient.ingredientAmount) // Convert fractional amounts
            } else {
                formattedAmount = String(format: "%.2f", ingredient.ingredientAmount) // Format with 2 decimal points
            }

            // Combine the formatted amount and unit
            let firstText = "\(formattedAmount) \(ingredient.ingredientUnit)".trimmingCharacters(in: .whitespaces)

            return GroceryItem(
                firstText: firstText,
                secondText: ingredient.ingredientName
            )
        }

        // Append new groceries and save
        groceries.append(contentsOf: newGroceries)
        saveGroceriesToUserDefaults()
    }

    /// Converts a fractional double to a string representation (e.g., 0.5 -> "1/2").
    /// - Parameter value: The fractional double.
    /// - Returns: A string representation of the fraction.
    private func fractionalString(from value: Double) -> String {
        switch value {
        case 0.5: return "1/2"
        case 0.33: return "1/3"
        case 0.66: return "2/3"
        case 0.25: return "1/4"
        case 0.75: return "3/4"
        default: return String(value) // Default to string if no matching case
        }
    }
    
    func toggleCheckStatus(for id: UUID) {
        if let index = groceries.firstIndex(where: { $0.id == id }) {
            groceries[index].isChecked.toggle()
            saveGroceriesToUserDefaults()
        }
    }
    
    func removeGrocery(by id: UUID) {
        if let index = groceries.firstIndex(where: { $0.id == id }) {
            groceries.remove(at: index)
            saveGroceriesToUserDefaults()
        }
    }
    
    func clearAll() {
        groceries.removeAll()
        saveGroceriesToUserDefaults()
    }
    
    func uncheckedGroceriesText() -> String {
        groceries
            .filter { !$0.isChecked }
            .map { $0.firstText.isEmpty ? $0.secondText : "\($0.firstText) \($0.secondText)" }
            .joined(separator: "\n")
    }
    
    private func saveGroceriesToUserDefaults() {
        if let data = try? JSONEncoder().encode(groceries) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadGroceriesFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedGroceries = try? JSONDecoder().decode([GroceryItem].self, from: data) {
            groceries = savedGroceries
        }
    }
}

extension GroceriesManager {
    /// Returns the count of unchecked grocery items.
    func uncheckedItemCount() -> Int {
        return groceries.filter { !$0.isChecked }.count
    }
}
