//
//  ServingsStepper.swift
//  The Ultimate Recipe Hub
//
//  The servings row (1.3.3): one component for the grocery picker and the recipe page, so both always
//  look and behave the same. Whole servings, 1 to 24 (half steps for small recipes: roadmap "Later · Ideas").
//

import SwiftUI

/// 👥 Servings, "Recipe makes 4" (with Reset once changed), and a − 4 + pill, on a soft orange band.
struct ServingsStepper: View {
    @Binding var servings: Int
    /// What the recipe makes as written.
    let baseServings: Int
    /// How far the orange band reaches past the row on each side: the screen's side margin,
    /// so the band runs edge to edge while the icon lines up with the content around it.
    var bandBleed: CGFloat = 16
    /// Free users on the recipe page: a PRO badge beside "Servings" and a lightly blurred − 4 + pill; a tap shakes the pill
    /// and call `onLockedTap` (the paywall) instead of changing.
    var isLocked: Bool = false
    var onLockedTap: () -> Void = {}

    @State private var shakeOffset: CGFloat = 0

    private var maxServings: Int { max(24, servings) }

    var body: some View {
        let isChanged = servings != baseServings
        HStack(spacing: 12) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.orange)
                .frame(width: 38, height: 38)
                .background(Circle().fill(Color.orange.opacity(0.16)))

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text("Servings")
                        .font(.system(size: 17, weight: .semibold))
                    if isLocked {
                        proBadge
                    }
                }
                if isLocked {
                    // Free users: what the recipe makes (they still need it); "Scale it with Pro" sits over the stepper.
                    Text("Recipe makes \(baseServings)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                } else if isChanged {
                    HStack(spacing: 4) {
                        Text("Recipe makes \(baseServings) ·")
                            .foregroundColor(.secondary)
                        Button("Reset") {
                            withAnimation(.easeInOut(duration: 0.2)) { servings = baseServings }
                        }
                        .foregroundColor(.orange)
                    }
                    .font(.system(size: 14, weight: .medium))
                    .transition(.opacity)
                } else {
                    Text("Recipe makes \(baseServings)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            // − 4 + in one white pill
            HStack(spacing: 4) {
                stepperButton("minus", label: "Fewer servings", isEnabled: servings > 1) { servings -= 1 }
                Text("\(servings)")
                    .font(.system(size: 18, weight: .semibold))
                    .monospacedDigit()
                    .contentTransition(.numericText(value: Double(servings)))
                    .blur(radius: isLocked ? 3.5 : 0) // free users: the number itself is hidden, the − / + stay readable
                    .frame(minWidth: 40)
                    .accessibilityLabel(isLocked ? "\(servings) servings, Pro" : "\(servings) servings")
                stepperButton("plus", label: "More servings", isEnabled: servings < maxServings) { servings += 1 }
            }
            .padding(3)
            .background(Capsule().fill(Color(.secondarySystemGroupedBackground)))
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
            // Free users: a frosted, locked control, lightly blurred so it still reads as a stepper.
            .blur(radius: isLocked ? 2 : 0)
            .offset(x: shakeOffset)
        }
        // Locked: the whole band is one button to the paywall, so no tap goes nowhere.
        .contentShape(Rectangle())
        .onTapGesture {
            guard isLocked else { return }
            shake()
            onLockedTap()
        }
        .accessibilityElement(children: isLocked ? .combine : .contain)
        .accessibilityAddTraits(isLocked ? .isButton : [])
        .accessibilityHint(isLocked ? "Pro feature. Opens the upgrade screen." : "")
        .padding(.vertical, 12)
        .padding(.top, isLocked ? 6 : 0) // free users: room under the "Scale it with Pro" chip that dips onto the band
        .background(Color.orange.opacity(0.09).padding(.horizontal, -bandBleed))
        .animation(.easeInOut(duration: 0.2), value: isChanged)
        .sensoryFeedback(.selection, trigger: servings)
    }

    /// The app's PRO badge (white on green, as on Pro recipe cards), beside "Servings".
    /// A tap opens the paywall, like − / +.
    private var proBadge: some View {
        Button {
            shake()
            onLockedTap()
        } label: {
            Text("PRO")
                .font(.system(size: 12, weight: .heavy))
                .tracking(0.4)
                .foregroundColor(.white)
                .padding(.horizontal, 9)
                .padding(.vertical, 3)
                .background(Capsule().fill(Color.green))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Pro feature")
    }

    /// Round orange − / + inside the pill; grey when it can't go further.
    private func stepperButton(_ symbol: String, label: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button {
            if isLocked {
                shake()
                onLockedTap()
            } else {
                withAnimation(.easeInOut(duration: 0.2)) { action() }
            }
        } label: {
            // Free users see it as it is (the PRO badge and the purple chip say it's Pro); a tap opens the paywall.
            Image(systemName: symbol)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isEnabled ? .orange : Color(.systemGray3))
                .frame(width: 33, height: 33)
                .background(Circle().fill(isEnabled ? Color.orange.opacity(0.16) : Color(.systemGray6)))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled && !isLocked)
        .accessibilityLabel(label)
    }

    /// The same short shake the old locked Scale button had.
    private func shake() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation(.linear(duration: 0.1)) { shakeOffset = 10 }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 0.1)) { shakeOffset = -10 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.linear(duration: 0.1)) { shakeOffset = 0 }
        }
    }
}
