//
//  RecipesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import SwiftUI

struct RecipesView: View {
    @State private var recipeCollections: [RecipeCollection] = []
    @State private var popularRecipeCollections: [RecipeCollection] = []
    
    @State private var isLoading: Bool = true
    @StateObject private var selectionManager = HomeSelectionManager.shared
    @StateObject private var recipeCollectionManager = RecipeCollectionManager.shared

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 5) {
                    if isLoading {
                        ForEach(0..<5) { _ in
                            placeholderCollectionView
                                .redacted(reason: .placeholder)
                                .padding(.horizontal)
                        }
                    } else if recipeCollections.isEmpty {
                        Text("No recipes found.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        
                        if recipeCollections.count > 0 {
                            CollectionView(recipeCollection: recipeCollections[0])
                                .padding(.top, 20)
                        }
                        
                        RecommendedPlanCardView(imageUrl: "Background2", action: {
                            selectionManager.selectedTab = .plan
                        })
                        
                        SaveExternalSourceCardView(
                            imageUrl: "Test1",
                            content: "Add your favorite recipes \nfrom the web",
                            destination: SavedRecipesView())
                        .padding(.top, 20)
                        
                        VStack(spacing: 20) {
                            Text("Popular")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)

                            HStack(spacing: 20) {
                                if let easyDinnerCollection = popularRecipeCollections.first(where: { $0.name.caseInsensitiveCompare("Easy Dinner") == .orderedSame }) {
                                    NavigationLink(destination: CollectionDetailsView(recipeCollection: easyDinnerCollection)) {
                                        RichText(title: "Easy Dinner", emoji: "🍽️")
                                    }
                                } else {
                                    RichText(title: "Easy Dinner", emoji: "🍽️")
                                }

                                if let onePotCollection = popularRecipeCollections.first(where: { $0.name.caseInsensitiveCompare("One Pot") == .orderedSame }) {
                                    NavigationLink(destination: CollectionDetailsView(recipeCollection: onePotCollection)) {
                                        RichText(title: "One Pot", emoji: "🍲")
                                    }
                                } else {
                                    RichText(title: "One Pot", emoji: "🍲")
                                }
                            }

                            HStack(spacing: 20) {
                                if let pastaCollection = popularRecipeCollections.first(where: { $0.name.caseInsensitiveCompare("Pasta") == .orderedSame }) {
                                    NavigationLink(destination: CollectionDetailsView(recipeCollection: pastaCollection)) {
                                        RichText(title: "Pasta", emoji: "🍝")
                                    }
                                } else {
                                    RichText(title: "Pasta", emoji: "🍝")
                                }

                                if let dessertsCollection = popularRecipeCollections.first(where: { $0.name.caseInsensitiveCompare("Desserts") == .orderedSame }) {
                                    NavigationLink(destination: CollectionDetailsView(recipeCollection: dessertsCollection)) {
                                        RichText(title: "Desserts", emoji: "🍰")
                                    }
                                } else {
                                    RichText(title: "Desserts", emoji: "🍰")
                                }
                            }

                            HStack(spacing: 20) {
                                if let italianCollection = popularRecipeCollections.first(where: { $0.name.caseInsensitiveCompare("Italian") == .orderedSame }) {
                                    NavigationLink(destination: CollectionDetailsView(recipeCollection: italianCollection)) {
                                        RichText(title: "Italian", emoji: "🍕")
                                    }
                                } else {
                                    RichText(title: "Italian", emoji: "🍕")
                                }

                                if let soupsCollection = popularRecipeCollections.first(where: { $0.name.caseInsensitiveCompare("Soups") == .orderedSame }) {
                                    NavigationLink(destination: CollectionDetailsView(recipeCollection: soupsCollection)) {
                                        RichText(title: "Soups", emoji: "🥣")
                                    }
                                } else {
                                    RichText(title: "Soups", emoji: "🥣")
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                        
                        SaveExternalSourceCardView(
                            imageUrl: "Background2",
                            content: "Add your favorite restaurants \nfrom the web",
                            destination: SavedRestaurantsView())
                        .padding(.bottom, 30)
                        
                        ForEach(1..<recipeCollections.count, id: \.self) { index in
                            CollectionView(recipeCollection: recipeCollections[index])
                        }
                    }
                }
                .padding(.top, 10)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Recipes")
            .onAppear(perform: {
                loadRecipeCollections(isPopularCollection: true, using: recipeCollectionManager)
                loadRecipeCollections(isPopularCollection: false, using: recipeCollectionManager)
            })
        }
    }
    
    /// Loads recipe collections using `RecipeCollectionManager`.
    ///
    /// Fetches standard or popular collections based on `isPopular` and updates local properties.
    /// Utilizes caching to avoid redundant loading.
    ///
    /// - Parameters:
    ///   - isPopular: `true` for popular collections, `false` for standard.
    ///   - manager: A shared `RecipeCollectionManager` instance.
    private func loadRecipeCollections(
        isPopularCollection isPopular: Bool = false,
        using manager: RecipeCollectionManager
    ) {
        let collectionType: RecipeCollectionManager.CollectionType = isPopular ? .popularCollections : .collections
        
        if let response = isPopular ? manager.popularCollectionsResponse : manager.collectionsResponse {
            if isPopular {
                popularRecipeCollections = response.collections
            } else {
                recipeCollections = response.collections
            }
        } else {
            print("Failed to load or parse collections for \(collectionType).")
        }
        
        isLoading = false
    }
    
    /// Loads JSON data from a specified file in the app bundle.
    /// - Parameter resourceName: The name of the resource file (without extension).
    /// - Returns: The data from the file, or nil if the file could not be loaded.
    private func loadCollections(forResource resourceName: String) -> Data? {
        if let url = Bundle.main.url(forResource: resourceName, withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                print("Failed to load JSON from \(resourceName): \(error)")
            }
        } else {
            print("Resource \(resourceName).json not found.")
        }
        return nil
    }
    
    /// A placeholder for `CollectionView` while content is loading.
    private var placeholderCollectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 30)
                .cornerRadius(5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5) { _ in
                        VStack {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .cornerRadius(8)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 80, height: 16)
                                .cornerRadius(5)
                        }
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .padding(.vertical, 8)
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesView()
    }
}
