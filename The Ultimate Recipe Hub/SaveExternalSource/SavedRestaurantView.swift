//
//  SavedRecipesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 23.12.2024.
//

import SwiftUI

struct SavedRestaurantsView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var sourceManager = ExternalSourceManager.shared
    @StateObject private var metadataFetcher = MetadataFetcher()
    
    @State private var searchText: String = ""
    @State private var alertColor: Color = .gray
    @State private var showInfoSheet: Bool = false
    @State private var clipboardContent: String = ""
    @State private var infoMessage: String = "The URL is invalid"
    
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
                Text("Saved Restaurants")
                    .font(.title.bold())
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 150), spacing: 15)],
                        spacing: 15
                    ) {
                        ForEach(sourceManager.SavedRestaurants.reversed()) { recipe in
                            SavedSourceCard(
                                id: .constant(recipe.id),
                                source: .constant(recipe.url),
                                isRecipe: false,
                                onRemoveAction: {
                                    infoMessage = "Source removed successfuly"
                                    alertColor = .gray
                                    showInfoSheet = true
                                }
                            )
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top, 10)
                .padding(.horizontal)
                .scrollIndicators(.hidden)
                
                SearchTextField(
                    text: $searchText,
                    buttonAction: {
                        print("Search button tapped with URL: \(searchText)")
                        handleAddRestaurant()
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
        .sheet(isPresented: $showInfoSheet, content: {
            ZStack {
                HStack (spacing: -10){
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.white)
                        .font(Font.system(size: 24, weight: .medium))
                    
                    Text(infoMessage)
                        .padding()
                        .foregroundColor(.white)
                        .font(Font.system(size: 18))
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            .presentationDetents([.height(50), .medium])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(alertColor)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    showInfoSheet = false
                }
            }
        })
    }
    
    private func handleAddRestaurant() {
        if !sourceManager.isRestaurantExist(url: searchText) {
            
            validateUrl(searchText) { isValid in
                if isValid {
                    let result = sourceManager.addRestaurant(url: searchText)
                    if result {
                        infoMessage = "Source added successfuly"
                        alertColor = .green.opacity(0.7)
                        clipboardContent = ""
                        showInfoSheet = true
                        searchText = ""
                    }
                } else {
                    print("URL is invalid")
                    infoMessage = "The URL is invalid"
                    clipboardContent = ""
                    alertColor = .gray
                    showInfoSheet = true
                }
            }
        }
        else {
            clipboardContent = ""
            infoMessage = "URL is already added"
            alertColor = .gray
            showInfoSheet = true
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

struct SavedRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        SavedRestaurantsView()
    }
}
