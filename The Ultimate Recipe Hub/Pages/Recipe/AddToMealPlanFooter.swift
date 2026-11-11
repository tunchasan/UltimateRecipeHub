//
//  AddToMealPlanFooter.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

/// The recipe page's meal plan button, in a light band at the bottom of the page (1.4).
/// One flat green button, 18 pt, with an icon. When this week's plan already has the recipe, a line
/// under it, in the band's bottom space, says where ("In your plan: Tuesday dinner") and the button
/// offers "Add to another day". The button sits in the same spot either way.
/// Opened to replace a planned meal, it says "Use this recipe".
struct AddToMealPlanFooter: View {

    enum Style: Equatable {
        case add
        /// Already in this week's plan: "Tuesday dinner", "today's lunch +1"
        case planned(String)
        /// Opened to replace a planned meal
        case use
    }

    var style: Style = .add
    var action: () -> Void // Action to perform on button tap

    /// 18 pt at the default text size; grows with Dynamic Type.
    @ScaledMetric(relativeTo: .body) private var titleSize: CGFloat = 18
    @ScaledMetric(relativeTo: .body) private var statusSize: CGFloat = 15
    @ScaledMetric(relativeTo: .body) private var buttonHeight: CGFloat = 54

    var body: some View {
        VStack(spacing: 4) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                action()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: icon)
                        .font(.system(size: titleSize + 1, weight: .semibold))
                    Text(title)
                        .font(.system(size: titleSize, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, minHeight: buttonHeight)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.green)) // flat: no shadow
                .contentShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
            .accessibilityLabel(title)

            // The band's bottom space: where the recipe already is, or empty. The same height either way,
            // so the button doesn't move when the recipe gets planned.
            Group {
                if case .planned(let when) = style {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Image(systemName: "checkmark.circle.fill")
                        (Text("In your plan: ") + Text(when).bold())
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .font(.system(size: statusSize, weight: .medium))
                    .foregroundColor(.green)
                    .accessibilityElement(children: .combine)
                }
            }
            .frame(maxWidth: .infinity, minHeight: statusSize + 4)
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 2)
        // One band down to the screen's bottom edge, so the space under the button belongs to it
        .background(Color.gray.opacity(0.075).ignoresSafeArea(edges: .bottom))
    }

    private var title: String {
        switch style {
        case .add: return "Add to meal plan"
        case .planned: return "Add to another day"
        case .use: return "Use this recipe"
        }
    }

    private var icon: String {
        switch style {
        case .add, .planned: return "calendar.badge.plus"
        case .use: return "arrow.triangle.2.circlepath"
        }
    }
}
