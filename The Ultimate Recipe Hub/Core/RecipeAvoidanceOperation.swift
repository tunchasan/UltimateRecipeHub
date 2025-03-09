//
//  RecipeAvoidanceCoder.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 9.03.2025.
//

import SwiftUI
import Foundation

/// **Recipe Avoidance Encoder & Decoder**
struct RecipeAvoidanceOperation {
    
    /// ✅ **Bitmask Mapping**
    private static let avoidanceBitMask: [FoodSensitivity: Int] = [
        .avoidChicken:  1 << 0,  // 00000000001 -> 0x1
        .avoidFruit:    1 << 1,  // 00000000010 -> 0x2
        .avoidGrains:   1 << 2,  // 00000000100 -> 0x4
        .avoidSeafood:  1 << 3,  // 00000001000 -> 0x8
        .avoidEgg:      1 << 4,  // 00000010000 -> 0x10
        .avoidPork:     1 << 5,  // 00000100000 -> 0x20
        .avoidMeat:     1 << 6,  // 00001000000 -> 0x40
        .avoidSpice:    1 << 7,  // 00010000000 -> 0x80
        .avoidDairy:    1 << 8,  // 00100000000 -> 0x100
        .avoidNuts:     1 << 9,  // 01000000000 -> 0x200
        .avoidAlcohol:  1 << 10  // 10000000000 -> 0x400
    ]
    
    /// ✅ **Encodes Selected Avoidances into a Hex Code**
    static func encodeAvoidance(_ avoidances: [FoodSensitivity]) -> String {
        var avoidanceBitmask = 0

        for item in avoidances {
            if let bitValue = avoidanceBitMask[item] {
                avoidanceBitmask |= bitValue
            }
        }

        return String(format: "%x", avoidanceBitmask) // ✅ Lowercase Hex String
    }
    
    /// ✅ **Encodes Selected Avoidances into a Hex Code**
    static func encodeAvoidance(_ avoidances: Set<FoodSensitivity>) -> String {
        var avoidanceBitmask = 0

        for item in avoidances {
            if let bitValue = avoidanceBitMask[item] {
                avoidanceBitmask |= bitValue
            }
        }

        return String(format: "%x", avoidanceBitmask) // ✅ Lowercase Hex String
    }
    
    /// ✅ **Decodes a Hex Code into a List of Avoidances**
    static func decodeAvoidance(from hexCode: String) -> [FoodSensitivity] {
        // ✅ Convert Hex to Integer
        guard let bitmask = Int(hexCode, radix: 16) else {
            return [] // ✅ Return empty list if invalid hex
        }

        var detectedAvoidances: [FoodSensitivity] = []

        // ✅ Check which bits are set correctly
        for (avoidance, bitValue) in avoidanceBitMask {
            if (bitmask & bitValue) == bitValue {  // ✅ Fix: Proper bitmask check
                detectedAvoidances.append(avoidance)
            }
        }

        return detectedAvoidances
    }
    
    /// ✅ **Checks if a recipe is safe for the user**
    /// - Parameters:
    ///   - userAvoidanceHex: The user's avoidance bitmask in hex string format.
    ///   - recipeHex: The recipe's bitmask in hex string format.
    /// - Returns: `true` if **no conflicts**, `false` if a conflict is found.
    static func isRecipeSafe(userAvoidanceHex: String, recipeHex: String) -> Bool {
        guard let userBitmask = Int(userAvoidanceHex, radix: 16),
              let recipeBitmask = Int(recipeHex, radix: 16) else {
            return false // ❌ Invalid hex input, treat as conflict
        }

        return (userBitmask & recipeBitmask) == 0
    }
    
    /// ✅ **Extracts the avoidance bitmask from a recipe ID**
    /// - Parameter recipeID: A string in the format `{unique_hex_id}_{avoidance_bitmask}`
    /// - Returns: The extracted avoidance bitmask as a string, or `nil` if invalid format.
    static func extractAvoidanceBitmask(from recipeID: String) -> String? {
        let components = recipeID.split(separator: "_")

        // ✅ Ensure format is correct (must have at least 2 parts)
        guard components.count == 2 else { return nil }

        return String(components[1]) // ✅ Return the avoidance bitmask part
    }
}
