//
//  NewPaywallView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 28.02.2025.
//

import SwiftUI
import RevenueCat

enum PaywallSelection {
    case firstPackage
    case secondPackage
    case thirdPackage
}

struct NewPaywallView: View {
    var directory: PaywallVisibilityManager.PaywallTrigger
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var subscriptionManager = SubscriptionManager.shared
    @ObservedObject private var user = User.shared

    @State var selection: PaywallSelection = .thirdPackage // opens on Lifetime, the recommended plan
    @State private var openTermsAndConditions = false
    @State private var openPrivacyAndPolicy = false
    @State private var isOperating = false
    @State private var isCloseButtonVisible = true
    /// Test switch: with the launch argument -PaywallPretendLoading (Debug builds only), the prices stay in their
    /// loading look for 5 seconds each time the paywall opens. Prices normally load at app start, so the
    /// loading look is otherwise hard to see.
    @State private var pretendLoading = false

    /// The plan Continue buys always follows the highlighted plan. (Before 1.3.2 Annual was highlighted on open
    /// but Continue bought Monthly until a plan was tapped.)
    private var package: SubscriptionPlan {
        switch selection {
        case .firstPackage: return .monthly
        case .secondPackage: return .yearly
        case .thirdPackage: return .lifetime
        }
    }

    /// The monthly free trial, only for people who can still get it. Nil = no trial wording anywhere.
    private var monthlyTrial: SubscriptionManager.FreeTrial? { subscriptionManager.monthlyFreeTrial }

    private var continueButtonText: String {
        if selection == .firstPackage, let monthlyTrial { return monthlyTrial.buttonText }
        return "Continue"
    }

    private var continueButtonSubText: String {
        guard selection == .firstPackage, monthlyTrial != nil,
              let monthly = subscriptionManager.getProduct(for: .monthly) else { return "" }
        return "then \(monthly.localizedPriceString)/month"
    }
    
    /// Photo height: 19% of the screen (at most 165 pt), growing to 27% (at most 250 pt) when there's room left
    /// over, so big phones don't get an empty gap above Continue.
    private var compactHeroHeight: CGFloat { min(UIScreen.main.bounds.height * 0.19, 165) }
    private var fullHeroHeight: CGFloat { min(UIScreen.main.bounds.height * 0.27, 250) } // big phones: more photo, less gap

    var body: some View {
        // Most iPhones: everything fits, so there's no scroll view (iOS fades content near a scroll view's edge)
        // and the photo takes the room that's left, up to 27% of the screen. Small iPhones: a short photo and
        // only the features scroll; the plans and Continue always stay on screen.
        ViewThatFits(in: .vertical) {
            paywallPage(scrolls: false)
            paywallPage(scrolls: true)
        }
        .ignoresSafeArea(.container, edges: .bottom) // the links sit just above the home bar instead of a tall empty strip
        .sheet(isPresented: $openTermsAndConditions) { // ✅ Opens Safari in a modal sheet
            if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                SafariView(url: url)
            }
        }
        .sheet(isPresented: $openPrivacyAndPolicy) { // ✅ Opens Safari in a modal sheet
            if let url = URL(string: "https://tunchasan.github.io/Recipe-Hub-Meal-Planner-Pro/privacypolicy/") {
                SafariView(url: url)
            }
        }
        .onAppear {
            subscriptionManager.fetchProducts() // ✅ Ensure products load when the view appears
            #if DEBUG
            let args = ProcessInfo.processInfo.arguments
            if args.contains("-PaywallPretendLoading") || args.contains("PaywallPretendLoading") {
                pretendLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { pretendLoading = false }
            }
            #endif
        }
        .onDisappear(perform: {
            if directory == PaywallVisibilityManager.PaywallTrigger.endOfOnboardingPage{
                user.isOnBoardingCompleted = true
            }
        })
        .task(id: directory) {
            guard directory == PaywallVisibilityManager.PaywallTrigger.endOfOnboardingPage else {
                isCloseButtonVisible = true
                return
            }
            
            isCloseButtonVisible = false
            
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            withAnimation(.easeInOut) {
                isCloseButtonVisible = true
            }
        }
    }
    
    /// The whole paywall: photo, title, features and plans, then Continue and the links.
    /// Layout order: the text, plans and Continue get their full size first; the photo then takes what's left
    /// (between its compact and full height); any space after that goes above Continue.
    @ViewBuilder
    private func paywallPage(scrolls: Bool) -> some View {
        VStack(spacing: 0) {
            hero
                .frame(
                    minHeight: compactHeroHeight,
                    idealHeight: compactHeroHeight,
                    maxHeight: scrolls ? compactHeroHeight : fullHeroHeight
                )
                .layoutPriority(1)
            
            VStack(spacing: 0) {
                title
                
                if scrolls {
                    // Small iPhones: only the features scroll, so all three plans (including the selected
                    // Lifetime card) and Continue are always on screen.
                    ScrollView {
                        featureList
                            .padding(.vertical, 4)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .padding(.top, 10)
                    
                    planCards
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    featureList
                        .padding(.top, 14)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(.top, -36) // the title sits on the photo's faded bottom edge
            .layoutPriority(2)
            
            if !scrolls {
                // Room left after the photo reaches its full height (big phones): up to 12 pt above the
                // plans, the rest above Continue, so the two gaps look about the same.
                Spacer(minLength: 0)
                    .frame(maxHeight: 12)
                
                planCards
                    .padding(.top, 10)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(2)
                
                Spacer(minLength: 0)
            }
            
            bottomSection
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(2)
        }
    }
    
    /// The food photo, fading into white at the bottom, with the close button. Fills whatever height it's given.
    private var hero: some View {
        ZStack(alignment: .topTrailing) {
            Color.clear
                .overlay(
                    Image("PaywallStock2")
                        .resizable()
                        .scaledToFill()
                )
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.clear,
                    Color.clear,
                    Color.clear,
                    Color.white.opacity(0.8),
                    Color.white
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(PaywallStyle.ink)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Color.white.opacity(0.92)).shadow(color: .black.opacity(0.18), radius: 2, y: 1))
                    .frame(width: 44, height: 44) // bigger tap area, same look
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Close")
            .padding(.top, 6)
            .padding(.trailing, 6)
            .disabled(!isCloseButtonVisible)
            .opacity(isCloseButtonVisible ? 1 : 0)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var title: some View {
        Text("Unlock All Pro Features")
            .font(.system(size: 32, weight: .heavy))
            .tracking(-0.5)
            .foregroundColor(PaywallStyle.ink)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, 16)
    }
    
    private var featureList: some View {
        VStack(alignment: .leading, spacing: 10) {
            featureRow("Unlimited personalized meal plans")
            featureRow("Hundreds of exclusive recipes")
            featureRow("One-tap grocery lists from any recipe")
            featureRow("Calories and macros for every recipe")
            featureRow("Access to the water challenge")
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// Monthly, Annual and Lifetime. The three cards are always there; while the App Store prices load, their
    /// price lines show as pulsing grey bars, so the page (and the photo) keep their size when the prices arrive.
    private var planCards: some View {
        let monthly = pretendLoading ? nil : subscriptionManager.getProduct(for: .monthly)
        let yearly = pretendLoading ? nil : subscriptionManager.getProduct(for: .yearly)
        let lifetime = pretendLoading ? nil : subscriptionManager.getProduct(for: .lifetime)
        
        return VStack(spacing: 16) { // room for the selected card's grow effect and the RECOMMENDED tag
            PaywallButton(
                title: "Monthly",
                badgeText: monthlyTrial?.badgeText ?? "",
                subTitle: "Billed monthly",
                priceText: monthly?.localizedPriceString ?? "$0.00",
                periodText: "per month",
                isSelected: selection == .firstPackage,
                isLoading: monthly == nil
            ) { select(.firstPackage) }
            .disabled(isOperating)
            .allowsHitTesting(monthly != nil) // not tappable while the price loads (without iOS greying it out)
            
            PaywallButton(
                title: "Annual",
                badgeText: monthly.flatMap { m in yearly.map { savingsBadge(yearly: $0, monthly: m) } } ?? "",
                subTitle: yearly.map { "Just \(subscriptionManager.getMonthlyPriceText(for: $0))/month" } ?? "Just $0.00/month",
                priceText: yearly?.localizedPriceString ?? "$00.00",
                periodText: "per year",
                discountText: monthly.flatMap { m in yearly.map { subscriptionManager.getDiscountText(for: $0, using: m) } } ?? "$00.00",
                isSelected: selection == .secondPackage,
                isLoading: monthly == nil || yearly == nil
            ) { select(.secondPackage) }
            .disabled(isOperating)
            .allowsHitTesting(monthly != nil && yearly != nil) // not tappable while the price loads (without iOS greying it out)
            
            PaywallButton(
                title: "Lifetime",
                badgeText: "Best Value",
                subTitle: "Pay once, yours forever",
                priceText: lifetime?.localizedPriceString ?? "$00.00",
                periodText: "one time",
                isSelected: selection == .thirdPackage,
                isRecommended: true,
                isLoading: lifetime == nil
            ) { select(.thirdPackage) }
            .disabled(isOperating)
            .allowsHitTesting(lifetime != nil) // not tappable while the price loads (without iOS greying it out)
        }
        .padding(.top, 12)
        .padding(.bottom, 8) // room for the selected card's glow
        .padding(.horizontal, 24)
    }
    
    private func select(_ plan: PaywallSelection) {
        guard !isOperating else { return }
        withAnimation { selection = plan }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    /// Continue stays disabled until the highlighted plan's price has loaded.
    private var isSelectedPlanLoaded: Bool { !pretendLoading && subscriptionManager.getProduct(for: package) != nil }
    
    /// Continue, the line under it, and Restore · Terms of Use · Privacy Policy.
    private var bottomSection: some View {
        VStack (spacing: 8) { // gap between the line under Continue and the links
            
            VStack (spacing: 0) {
                Button(action: {
                    if !isOperating {
                        withAnimation { isOperating = true }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        subscriptionManager.purchase(plan: package) { result in
                            switch result {
                            case .success(let hasProAccess):
                                if hasProAccess {
                                    User.shared.subscription = .pro
                                    print("✅ Purchase successful: User has Pro access")
                                    presentationMode.wrappedValue.dismiss()
                                } else {
                                    print("⚠️ Purchase completed: No active subscription")
                                    presentationMode.wrappedValue.dismiss()
                                }
                            case .failure(let error):
                                print("❌ Purchase failed: \(error.localizedDescription)")
                                
                                withAnimation {
                                    isOperating = false
                                }
                            }
                        }
                    }
                }) {
                    VStack (spacing: 4){
                        if isOperating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                        else {
                            Text(continueButtonText)
                                .font(.system(size: 18, weight: .bold))
                            
                            if !continueButtonSubText.isEmpty {
                                Text(continueButtonSubText)
                                    .font(.system(size: 13, weight: .semibold))
                                    .opacity(0.92)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, minHeight: 58) // same height with or without the trial line, so nothing moves
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(PaywallStyle.buttonGreen) // darker than system green so the white text reads in sunlight
                            .shadow(color: PaywallStyle.buttonGreen.opacity(0.3), radius: 6, y: 4)
                    )
                }
                .padding(.top, 14)
                .padding(.bottom, 12) // a little room above the line under Continue
                .padding(.horizontal, 24)
                .buttonStyle(PlainButtonStyle())
                .disabled(!isSelectedPlanLoaded)
                .opacity(isSelectedPlanLoaded ? 1 : 0.6)
                .animation(.easeOut(duration: 0.2), value: isSelectedPlanLoaded)
                
                footnote
                    .lineLimit(1)
                    .minimumScaleFactor(0.85) // the trial line is long; one line keeps the page from jumping
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
            // Restore · Terms of Use · Privacy Policy, centred, as in the canvas design
            HStack(spacing: 15) { // room around the dots
                footerLink("Restore") {
                    withAnimation { isOperating = true }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    subscriptionManager.restorePurchases { result in
                        switch result {
                        case .success(let hasProAccess):
                            if hasProAccess {
                                User.shared.subscription = .pro
                                print("✅ Restore successful: User has Pro access")
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                print("⚠️ Restore completed: No active subscription")
                                withAnimation {
                                    isOperating = false
                                }
                            }
                        case .failure(let error):
                            print("❌ Restore failed: \(error.localizedDescription)")
                            withAnimation {
                                isOperating = false
                            }
                        }
                    }
                }
                
                footerDot
                
                footerLink("Terms of Use") {
                    openTermsAndConditions = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                
                footerDot
                
                footerLink("Privacy Policy") {
                    openPrivacyAndPolicy = true
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .padding(.horizontal, 24)
        }
        .padding(.bottom, 22) // clears the home bar
    }
    
    /// One footer link: 13 pt grey text with a taller tap area. Dimmed and disabled while a purchase runs.
    private func footerLink(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13))
                .foregroundColor(PaywallStyle.footnote.opacity(isOperating ? 0.5 : 1))
                .padding(.horizontal, 2)
                .frame(height: 24)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isOperating)
    }
    
    private var footerDot: some View {
        Text("·")
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(PaywallStyle.footnote)
            .accessibilityHidden(true)
    }
    
    /// Reusable HStack for Features
    func featureRow(_ text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(PaywallStyle.green)
            
            Text(text)
                .font(.system(size: 17))
                .foregroundColor(PaywallStyle.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.9) // long lines shrink slightly instead of wrapping
        }
    }

    /// "Save 58%": what Annual saves against 12 months of Monthly in this store's prices, rounded down so it
    /// never overstates. Empty (no badge) if Annual somehow isn't cheaper.
    private func savingsBadge(yearly: StoreProduct, monthly: StoreProduct) -> String {
        let yearlyPrice = (yearly.price as NSDecimalNumber).doubleValue
        let twelveMonths = (monthly.price as NSDecimalNumber).doubleValue * 12
        guard twelveMonths > 0, yearlyPrice < twelveMonths else { return "" }
        let percent = Int(((1 - yearlyPrice / twelveMonths) * 100).rounded(.down))
        return "Save \(percent)%"
    }

    /// The line under Continue: what happens next for the highlighted plan.
    @ViewBuilder private var footnote: some View {
        if selection == .firstPackage, monthlyTrial != nil {
            (Text("No payment now").fontWeight(.semibold).foregroundColor(PaywallStyle.ink)
             + Text(" · Cancel any time before the trial ends").foregroundColor(PaywallStyle.footnote))
                .font(.system(size: 13))
        } else {
            Text(footnoteText)
                .font(.system(size: 13))
                .foregroundColor(PaywallStyle.footnote)
        }
    }


    private var footnoteText: String {
        switch selection {
        case .firstPackage: return "Renews monthly. Cancel any time in Settings."
        case .secondPackage: return "Renews yearly. Cancel any time in Settings."
        case .thirdPackage: return "One payment. No subscription."
        }
    }
}

struct NewPaywallExample: View {
    @State private var isSheetPresented = true
    
    var body: some View {
        VStack {
            Button("Open Sheet") {
                isSheetPresented = true
            }
            .padding()
        }
        .sheet(isPresented: $isSheetPresented) {
            NewPaywallView(directory: .attemptAddRecipeToFavoritesOver3)
                .interactiveDismissDisabled(true)
        }
    }
}

struct NewPaywallExample_Previews: PreviewProvider {
    static var previews: some View {
        NewPaywallExample()
    }
}
