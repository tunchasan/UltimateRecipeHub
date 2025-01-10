//
//  RecipesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 10.01.2025.
//

import SwiftUI

struct RecipesView: View {
    @State private var recipeCollections: [RecipeCollection] = []
    @State private var isLoading: Bool = true
    @StateObject private var selectionManager = HomeSelectionManager.shared
    
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
                                RichButton(title: "Easy Dinner", emoji: "🍽️", action: {
                                    print("Easy Dinner tapped")
                                })
                                RichButton(title: "One Pot", emoji: "🍲", action: {
                                    print("One Pot tapped")
                                })
                            }
                            
                            HStack(spacing: 20) {
                                RichButton(title: "Pasta", emoji: "🍝", action: {
                                    print("Pasta Paradise tapped")
                                })
                                RichButton(title: "Desserts", emoji: "🍰", action: {
                                    print("Desserts tapped")
                                })
                            }
                            
                            HStack(spacing: 20) {
                                RichButton(title: "Italian", emoji: "🍕", action: {
                                    print("Italian tapped")
                                })
                                RichButton(title: "Soups", emoji: "🥣", action: {
                                    print("Soups tapped")
                                })
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
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Recipes")
            .onAppear(perform: loadRecipeCollections)
        }
    }
    
    /// Loads recipe collections from the JSON data using `RecipeCollectionParser`.
    private func loadRecipeCollections() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Simulate loading delay
            guard let jsonData = loadCollections() else {
                print("Failed to load sample JSON.")
                isLoading = false
                return
            }
            
            let parser = RecipeCollectionParser()
            if let response = parser.parseRecipeCollections(from: jsonData) {
                recipeCollections = response.collections
            } else {
                print("Failed to parse JSON.")
            }
            
            isLoading = false
        }
    }
    
    /// Loads sample JSON data from a file or embedded resource.
    private func loadCollections() -> Data? {
        if let url = Bundle.main.url(forResource: "Collections", withExtension: "json") {
            do {
                return try Data(contentsOf: url)
            } catch {
                print("Failed to load JSON: \(error)")
            }
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
