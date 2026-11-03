import SwiftUI

struct BannerCollectionView: View {
    @StateObject private var selectionManager = HomeSelectionManager.shared
    @State private var currentIndex = 0
    @State private var timer: Timer?
    
    private let autoScrollInterval = 10.0

    private let banners: [() -> AnyView] = [
        {
            AnyView(RecommendedPlanCardView(
                image: "Recommended Plan",
                title: "Hungry for Inspiration?",
                contentVSpace: 20,
                imageSize: 105,
                description: "Let's create a perfect personalized\nmeal plan for you.",
                buttonText: "Create a meal plan",
                buttonColor: .purple,
                action: {
                    HomeSelectionManager.shared.selectedTab = .plan
                }
            ))
        },
        {
            AnyView(RecommendedPlanCardView(
                image: "SaveRecipe",
                title: "Save It. Cook It. Love It!",
                imageSize: 80,
                imageOffsetLeading: 20,
                description: "Found something tasty online?\nSave it instantly and keep them all\nin one place.",
                buttonText: "Save a recipe",
                buttonColor: .purple,
                action: {
                    HomeSelectionManager.shared.triggerNavigateToSavedRecipes()
                }
            ))
        },
        {
            AnyView(RecommendedPlanCardView(
                image: "SaveRestaurant",
                title: "Never Lose a Great Spot Again!",
                contentVSpace: 22.5,
                imageSize: 105,
                description: "Save and organize links to your\nfavorite restaurants all in one place!",
                buttonText: "Save a restaurant",
                buttonColor: .purple,
                action: {
                    HomeSelectionManager.shared.triggerNavigateToSavedRestaurants()
                }
            ))
        }
    ]

    /// Screenshot mode (Debug only; always false in Release): without "Save a restaurant" (the last banner).
    private var visibleBanners: [() -> AnyView] {
        ScreenshotMode.isOn ? Array(banners.dropLast()) : banners
    }

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                ForEach(visibleBanners.indices, id: \.self) { index in
                    visibleBanners[index]()
                        .tag(index)
                        .transition(.slide)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 180)

            // Custom Pagination Dots
            HStack(spacing: 8) {
                ForEach(visibleBanners.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.purple : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 5)
        }
        .onAppear {
            // Screenshot mode: rests on "Save It. Cook It. Love It!", no auto-scroll
            if ScreenshotMode.isOn {
                currentIndex = 1
                return
            }
            startAutoScroll()
        }
        .onDisappear {
            stopAutoScroll()
        }
    }

    // Starts auto-scroll
    private func startAutoScroll() {
        stopAutoScroll() // Clear any existing timers first
        timer = Timer.scheduledTimer(withTimeInterval: autoScrollInterval, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentIndex = (currentIndex + 1) % visibleBanners.count
            }
        }
    }
    
    // Stops auto-scroll when the view disappears
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}
