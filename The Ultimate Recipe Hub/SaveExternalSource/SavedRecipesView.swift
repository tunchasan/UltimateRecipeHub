//
//  SavedRecipesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import SwiftUI

struct SavedRecipesView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var sourceManager = ExternalSourceManager.shared
    @StateObject private var metadataFetcher = MetadataFetcher()
    
    @State private var searchText: String = ""
    @State private var clipboardContent: String = ""
    
    private func validateUrl(_ url: String, completion: @escaping (Bool) -> Void) {
        metadataFetcher.isValidUrl(url) { isValid in
            DispatchQueue.main.async {
                completion(isValid)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack (spacing:5) {
                Text("Saved Recipes")
                    .font(.title.bold())
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if sourceManager.SavedRecipes.count > 0 {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 150), spacing: 15)],
                            spacing: 15
                        ) {
                            ForEach(sourceManager.SavedRecipes.reversed()) { recipe in
                                SavedSourceCard(
                                    id: .constant(recipe.id),
                                    source: .constant(recipe.url),
                                    isRecipe: true,
                                    onRemoveAction: {
                                        ToastVisibilityManager.show(for: "Source removed!")
                                    }
                                )
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal)
                    .scrollIndicators(.hidden)
                }
                
                else {
                    Spacer()
                    VStack (alignment: .leading, spacing: 20) {
                        Text("🔗 Copy the URL of your favorite recipe")
                            .font(.system(size: 16).bold())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Text("🕵️‍♂️ We’ll detect it automatically")
                            .font(.system(size: 16).bold())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Text("🔍 Tap the Search button to continue")
                            .font(.system(size: 16).bold())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)

                        Text("✨ Sit back and watch the magic happen! 🚀")
                            .font(.system(size: 16).bold())
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                }
                
                SearchTextField(
                    text: $searchText,
                    buttonAction: {
                        print("Search button tapped with URL: \(searchText)")
                        handleAddRecipe()
                    })
                .padding(.top, 5)
                .padding(.bottom, 15)
                .padding(.horizontal)
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                updateClipboardContent()
            }
        }
        .onAppear {
            TabVisibilityManager.hideTabBar()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                updateClipboardContent()
            }
        }
        .onDisappear(perform: {
            TabVisibilityManager.showTabBar()
        })
    }
    
    private func handleAddRecipe() {
        if !sourceManager.isRecipeExist(url: searchText) {
            
            validateUrl(searchText) { isValid in
                if isValid {
                    let result = sourceManager.addRecipe(url: searchText)
                    if result {
                        ToastVisibilityManager.show(for: "Source added!")
                        clipboardContent = ""
                        searchText = ""
                    }
                    
                } else {
                    ToastVisibilityManager.show(for: "Invalid URL!", with: .error)
                    print("URL is invalid")
                    clipboardContent = ""
                }
            }
        }
        else {
            ToastVisibilityManager.show(for: "Dublicate detected!", with: .error, additional: "Source already added")
            clipboardContent = ""
        }
    }
    
    private func updateClipboardContent() {
        // Check if the clipboard contains a URL without accessing its content
        if UIPasteboard.general.hasURLs {
            // Safely access the clipboard content
            if let content = UIPasteboard.general.string, content != clipboardContent {
                clipboardContent = content // Update clipboard content
                searchText = clipboardContent // Set the content to searchText
            }
        } else {
            print("Clipboard does not contain a URL")
        }
    }
}

struct Saved_Previews: PreviewProvider {
    static var previews: some View {
        SavedRecipesView()
    }
}
