//
//  SubscriptionManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.03.2025.
//

import SwiftUI
import RevenueCat
import Foundation

enum SubscriptionPlan: String {
    case monthly = "iOS_pro_monthly_199"
    case yearly = "iOS_pro_yearly_999"
    case lifetime = "iOS_pro_lifetime_1499"
}

class SubscriptionManager: ObservableObject {
    
    static let shared = SubscriptionManager()
    
    @Published var products: [StoreProduct] = []
    
    private init() {
        fetchProducts() // ✅ Ensures products load at startup
        checkProStatus()
    }
    
    /// DEBUG builds only: launching with `-debugForcePro YES` (Edit Scheme → Run → Arguments)
    /// makes the app act as Pro for testing. Release builds always use the real RevenueCat entitlement.
    static var isDebugProForced: Bool {
        #if DEBUG
        return UserDefaults.standard.bool(forKey: "debugForcePro")
        #else
        return false
        #endif
    }
    
    func checkProStatus() {
        if SubscriptionManager.isDebugProForced {
            DispatchQueue.main.async { User.shared.subscription = .pro }
        }
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let customerInfo = customerInfo {
                DispatchQueue.main.async {
                    let isPro = customerInfo.entitlements["pro"]?.isActive ?? false
                    User.shared.subscription = isPro || SubscriptionManager.isDebugProForced ? .pro : .free
                }
            } else {
                print("Error fetching customer info: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchProducts() {
        let productIdentifiers = [
            SubscriptionPlan.monthly.rawValue,
            SubscriptionPlan.yearly.rawValue,
            SubscriptionPlan.lifetime.rawValue
        ]
        
        Purchases.shared.getProducts(productIdentifiers) { products in
            DispatchQueue.main.async {
                self.products = products
                print("✅ Products Fetched: \(products.map { $0.productIdentifier })") // Debugging
            }
        }
    }
    
    func getProduct(for plan: SubscriptionPlan) -> StoreProduct? {
        let product = products.first { $0.productIdentifier == plan.rawValue }
        print("🔍 getProduct: Looking for \(plan.rawValue), Found: \(product?.productIdentifier ?? "nil")") // Debugging
        return product
    }
    
    func restorePurchases(completion: @escaping (Result<Bool, Error>) -> Void) {
        Purchases.shared.restorePurchases { customerInfo, error in
            if let error = error {
                completion(.failure(error)) // ✅ Return failure with error
            } else if let customerInfo = customerInfo {
                let hasProAccess = customerInfo.entitlements["pro"]?.isActive ?? false
                completion(.success(hasProAccess)) // ✅ Return success if "pro" is active
            } else {
                completion(.success(false)) // ✅ No active subscription
            }
        }
    }
    
    func purchase(plan: SubscriptionPlan, completion: @escaping (Result<Bool, Error>) -> Void) {
        Purchases.shared.getProducts([plan.rawValue]) { products in
            guard let product = products.first else {
                completion(.failure(NSError(domain: "PurchaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Product not found"])))
                return
            }
            
            Purchases.shared.purchase(product: product) { transaction, customerInfo, error, userCancelled in
                if let error = error {
                    completion(.failure(error)) // ✅ Return failure
                } else if let customerInfo = customerInfo {
                    let hasProAccess = customerInfo.entitlements["pro"]?.isActive ?? false
                    completion(.success(hasProAccess)) // ✅ Return success if "pro" is active
                } else {
                    completion(.success(false)) // ✅ No active subscription
                }
            }
        }
    }
}

extension SubscriptionManager {
    
    /// ✅ Returns the properly formatted monthly price text
    func getMonthlyPriceText(for yearlyProduct: StoreProduct) -> String {
        let monthlyPrice = (yearlyProduct.price as NSDecimalNumber).doubleValue / 12
        return formatPrice(monthlyPrice, currencyCode: yearlyProduct.currencyCode)
    }
    
    /// ✅ Returns the properly formatted discounted full-year price text
    func getDiscountText(for yearlyProduct: StoreProduct, using monthlyProduct: StoreProduct) -> String {
        let discountedPrice = (monthlyProduct.price as NSDecimalNumber).doubleValue * 12
        return formatPrice(discountedPrice, currencyCode: yearlyProduct.currencyCode)
    }
    
    /// ✅ Formats the price correctly using the currency code
    private func formatPrice(_ price: Double, currencyCode: String?) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode ?? Locale.current.currency?.identifier ?? "USD" // ✅ Correct way

        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}
