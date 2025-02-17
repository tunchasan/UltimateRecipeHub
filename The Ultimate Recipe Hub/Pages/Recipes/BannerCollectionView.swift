//
//  CollectionView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 17.02.2025.
//

import SwiftUI

struct BannerCollectionView: View {
    @StateObject private var selectionManager = HomeSelectionManager.shared
    
    private let banners: [AnyView] = [
        AnyView(RecommendedPlanCardView(
                imageUrl: "Background2",
                action: {
                    //selectionManager.selectedTab = .plan
                })),
        
        AnyView(SaveExternalSourceCardView(
            imageUrl: "Background2",
            content: "Add your favorite restaurants \nfrom the web",
            destination: SavedRestaurantsView())),
        
        AnyView(SaveExternalSourceCardView(
            imageUrl: "Test1",
            content: "Add your favorite recipes \nfrom the web",
            destination: SavedRecipesView()))
    ]
    
    @State private var currentIndex = 0
    private let autoScrollInterval = 30.0 // Auto-scroll every 3 seconds

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(banners.indices, id: \.self) { index in
                    banners[index]
                        .tag(index)
                        .transition(.slide)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default indicators
            .frame(height: 200) // Adjust height as needed
            .onAppear(perform: startAutoScroll)

            // Custom Pagination Dots
            HStack(spacing: 8) {
                ForEach(banners.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.green : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 5)
        }
    }
    
    // Auto-scroll logic
    private func startAutoScroll() {
        Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % banners.count
            }
        }
    }
}
