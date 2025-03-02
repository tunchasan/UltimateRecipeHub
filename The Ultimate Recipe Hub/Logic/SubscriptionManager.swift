//
//  SubscriptionManager.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 2.03.2025.
//

import SwiftUI
import RevenueCat

enum SubscriptionPlan: String {
    case monthly = "iOS_pro_monthly_199"
    case yearly = "iOS_pro_yearly_999"
    case lifetime = "iOS_pro_lifetime_1499"
}

class SubscriptionManager: ObservableObject {
    
    static let shared = SubscriptionManager()
    
    @Published var products: [StoreProduct] = []
    
    private init() {
        checkProStatus() // ✅ Automatically checks Pro status on init
    }
    
    func checkProStatus() {
        Purchases.shared.getCustomerInfo { customerInfo, error in
            if let customerInfo = customerInfo {
                DispatchQueue.main.async {
                    let isPro = customerInfo.entitlements["pro"]?.isActive ?? false
                    User.shared.subscription = isPro ? .pro : .free
                }
            } else {
                print("Error fetching customer info: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func fetchProducts() {
        let productIdentifiers = ["iOS_pro_monthly_199", "iOS_pro_yearly_999", "iOS_pro_lifetime_1499"]
        
        Purchases.shared.getProducts(productIdentifiers) { products in
            DispatchQueue.main.async {
                self.products = products
            }
        }
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
