//
//  RoundedButton.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 1.03.2025.
//

import SwiftUI

struct PaywallButton: View {
    var title: String
    var badgeText: String = ""
    var subTitle: String
    var priceText: String
    var periodText: String = ""
    var discountText: String = ""
    var isSelected: Bool = false
    /// Shows a green "RECOMMENDED" tag on the card's top edge (Lifetime).
    var isRecommended: Bool = false
    /// Prices still loading from the App Store: the price lines show as softly pulsing grey bars, at the same
    /// size, so nothing moves when the prices arrive.
    var isLoading: Bool = false
    var backgroundColor: Color = PaywallStyle.card
    var foregroundColor: Color = .white
    var action: () -> Void
    
    // While prices load, the card is neutral: no badge, no RECOMMENDED tag, no tick, outline, glow or grow.
    // They all appear (animated) once the prices arrive.
    private var showsBadge: Bool { !isLoading && !badgeText.isEmpty }
    private var showsSelected: Bool { isSelected && !isLoading }
    private var showsRecommended: Bool { isRecommended && !isLoading }
    
    /// 1.3.2 look: a round tick shows the chosen plan; the chosen card gets a green outline, a soft glow and
    /// grows by 5%.
    var body: some View {
        Button(action: action) {
            cardRow
                .padding(.horizontal, 16)
                .frame(height: 70)
                .foregroundColor(foregroundColor)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(backgroundColor)
                        // Chosen plan: an even green glow all around (tight + wide); others: a small dark shadow.
                        .shadow(
                            color: showsSelected ? PaywallStyle.green.opacity(0.4) : .black.opacity(0.18),
                            radius: showsSelected ? 7 : 3,
                            y: showsSelected ? 0 : 2
                        )
                        .shadow(
                            color: PaywallStyle.green.opacity(showsSelected ? 0.18 : 0),
                            radius: 14
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(PaywallStyle.green, lineWidth: 3)
                        .shadow(color: PaywallStyle.green.opacity(0.5), radius: 3) // the outline itself glows
                        .opacity(showsSelected ? 1 : 0)
                )
                .overlay(alignment: .topLeading) {
                    if showsRecommended {
                        Text("RECOMMENDED")
                            .font(.system(size: 11, weight: .heavy))
                            .tracking(0.6)
                            .foregroundColor(.white)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 3)
                            .background(Capsule().fill(PaywallStyle.green))
                            .offset(x: 50, y: -10)
                            .accessibilityHidden(true)
                    }
                }
                .scaleEffect(showsSelected ? 1.05 : 1) // the chosen plan grows a little
                .animation(.spring(response: 0.3, dampingFraction: 0.75), value: showsSelected)
                .animation(.easeOut(duration: 0.25), value: isLoading) // badges and tag fade in with the prices
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityAddTraits(showsSelected ? .isSelected : [])
        .accessibilityHint(showsRecommended ? "Recommended" : "")
    }
    
    /// Tick, plan name with badge and the line under it, then the prices on the right. The name side gets its
    /// full width first; the prices use what's left: the crossed-out price sits left of the price when there's
    /// room, and moves above it when there isn't (long prices such as ₺1.199,88 next to ₺499,99). So nothing
    /// overlaps and the card never gets wider than the screen allows.
    private var cardRow: some View {
        HStack(spacing: 10) {
            selectionTick
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                    
                    if showsBadge {
                        Text(badgeText)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(PaywallStyle.badge))
                            .fixedSize()
                    }
                }
                
                Text(subTitle)
                    .font(.system(size: 14))
                    .foregroundColor(PaywallStyle.secondaryText)
                    .loadingPlaceholder(isLoading)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.85)
            .layoutPriority(1) // the name side gets its full width before the prices
            
            ViewThatFits(in: .horizontal) {
                priceColumn(stacked: false).fixedSize()
                priceColumn(stacked: true).fixedSize()
            }
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .loadingPlaceholder(isLoading)
        }
    }
    
    /// Price and period on the right. Side by side: "$23.88 $9.99" / "per year". Stacked: the crossed-out
    /// price on its own line above the price.
    @ViewBuilder
    private func priceColumn(stacked: Bool) -> some View {
        let discount = Text(discountText)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(PaywallStyle.strikePrice)
            .strikethrough()
        let price = Text(priceText)
            .font(.system(size: 19, weight: .bold).monospacedDigit())
        
        VStack(alignment: .trailing, spacing: stacked ? 0 : 2) {
            if stacked {
                if !discountText.isEmpty { discount }
                price
            } else {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    if !discountText.isEmpty { discount }
                    price
                }
            }
            
            if !periodText.isEmpty {
                Text(periodText)
                    .font(.system(size: 13))
                    .foregroundColor(PaywallStyle.secondaryText)
            }
        }
    }
    
    /// Empty ring, or a filled green circle with a tick on the chosen plan.
    private var selectionTick: some View {
        ZStack {
            Circle()
                .strokeBorder(PaywallStyle.tickRing, lineWidth: 2)
                .opacity(showsSelected ? 0 : 1)
            
            Circle()
                .fill(PaywallStyle.green)
                .opacity(showsSelected ? 1 : 0)
            
            Image(systemName: "checkmark")
                .font(.system(size: 12, weight: .heavy))
                .foregroundColor(.white)
                .opacity(showsSelected ? 1 : 0)
        }
        .frame(width: 24, height: 24)
        .accessibilityHidden(true)
    }
}

/// Paywall colours (1.3.2). The paywall always has a white background.
enum PaywallStyle {
    static let ink = Color(red: 0x1C / 255, green: 0x1C / 255, blue: 0x1E / 255)            // title and feature text
    static let card = Color(red: 0x1C / 255, green: 0x1C / 255, blue: 0x1E / 255)           // plan cards
    static let green = Color(red: 0x34 / 255, green: 0xC7 / 255, blue: 0x59 / 255)          // ticks, outline, recommended tag
    static let buttonGreen = Color(red: 0x24 / 255, green: 0x8A / 255, blue: 0x3D / 255)    // Continue: keeps white text readable
    static let badge = Color(red: 0xAF / 255, green: 0x52 / 255, blue: 0xDE / 255)          // purple plan badges
    static let secondaryText = Color(red: 0xAE / 255, green: 0xAE / 255, blue: 0xB2 / 255)  // detail lines on the dark cards
    static let strikePrice = Color(red: 0xFF / 255, green: 0x9F / 255, blue: 0x0A / 255)    // crossed-out 12 x Monthly price
    static let tickRing = Color(red: 0x63 / 255, green: 0x63 / 255, blue: 0x66 / 255)       // empty selection ring
    static let footnote = Color(red: 0x6E / 255, green: 0x6E / 255, blue: 0x73 / 255)       // line under Continue and links
}

#Preview {
    PaywallButton(
        title: "Monthly",
        badgeText: "3 days free",
        subTitle: "$1.99/month",
        priceText: "$1.99",
        periodText: "per month",
        discountText: "23.99"
    ) {
        
    }
}

extension View {
    /// Grey placeholder bars with a gentle pulse while `isLoading`; the view as is otherwise.
    func loadingPlaceholder(_ isLoading: Bool) -> some View {
        modifier(LoadingPlaceholder(isLoading: isLoading))
    }
}

private struct LoadingPlaceholder: ViewModifier {
    let isLoading: Bool
    @State private var dimmed = false
    
    func body(content: Content) -> some View {
        content
            .redacted(reason: isLoading ? .placeholder : [])
            .opacity(isLoading && dimmed ? 0.45 : 1)
            .onAppear { if isLoading { startPulse() } }
            .onChange(of: isLoading) { _, loading in
                if loading { startPulse() } else { withAnimation(.easeOut(duration: 0.2)) { dimmed = false } }
            }
    }
    
    private func startPulse() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) { dimmed = true }
    }
}
