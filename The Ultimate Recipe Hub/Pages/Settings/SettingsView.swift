//
//  SettingsView.swift
//  The Ultimate Recipe Hub
//
//  Settings, opened from the gear on the Recipes page (1.4). Units: Automatic, Metric or US,
//  with a live preview. Free for everyone.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UnitsSetting.storageKey) private var unitsSettingRaw: String = UnitsSetting.automatic.rawValue

    private var setting: UnitsSetting { UnitsSetting(rawValue: unitsSettingRaw) ?? .automatic }

    var body: some View {
        List {
            Section {
                ForEach(UnitsSetting.allCases) { option in
                    Button {
                        unitsSettingRaw = option.rawValue
                    } label: {
                        UnitsOptionRow(title: Self.title(of: option), subtitle: Self.subtitle(of: option),
                                       isSelected: option == setting)
                    }
                    .buttonStyle(.plain)
                }
            } header: {
                SectionTitle("Units")
            } footer: {
                // An info frame, like the note on recipe pages
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "info.circle")
                        .font(.subheadline.weight(.medium))
                        .padding(.top, 1)
                    // The three places in green, the app's colour for amounts
                    (Text("Recipes").foregroundColor(.green).bold() + Text(", ")
                        + Text("Cooking Mode").foregroundColor(.green).bold() + Text(" and your ")
                        + Text("Grocery List").foregroundColor(.green).bold()
                        + Text(" follow this. Grocery items you add yourself stay exactly as you typed them."))
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemBackground)))
                .padding(.horizontal, -16) // as wide as the list's rows
                .padding(.top, 6)
                .accessibilityElement(children: .combine)
            }

            Section {
                ForEach(Self.previewIngredients, id: \.name) { sample in
                    HStack(spacing: 12) {
                        Text(sample.name)
                        Spacer(minLength: 8)
                        Text(Self.previewAmount(sample, system: setting.system))
                            .fontWeight(.semibold)
                            .foregroundStyle(.green)
                            .lineLimit(1)
                            .contentTransition(.numericText())
                    }
                }
            } header: {
                SectionTitle("Preview · Chicken Piccata")
            }

            // How amounts are shown: one short row per rule, instead of a paragraph under the preview
            Section {
                AmountRuleRow(symbol: "fork.knife", color: .orange, title: "Spoons stay spoons",
                              detail: "Metric also shows ml: 1 tbsp (15 ml), because spoon sizes differ by country")
                AmountRuleRow(symbol: "cup.and.saucer.fill", color: .green, title: "Cups for things you can't pour",
                              detail: "Like chopped parsley. US cups (1 cup = 240 ml), with ml beside them in metric")
                AmountRuleRow(symbol: "thermometer.medium", color: .red, title: "Oven temperatures",
                              detail: "Always shown in both", trailing: "400°F (200°C)")
            } header: {
                SectionTitle("How amounts are shown")
            }
            .listSectionSpacing(12) // closer to the preview it explains
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: unitsSettingRaw)
        .sensoryFeedback(.selection, trigger: unitsSettingRaw)
        // Like a recipe page: no tab bar while Settings is open
        .onAppear { TabVisibilityManager.hideTabBar() }
        .onDisappear { TabVisibilityManager.showTabBar() }
    }

    // MARK: - Texts

    private static func title(of option: UnitsSetting) -> String {
        switch option {
        case .automatic: return "Automatic"
        case .metric: return "Metric"
        case .us: return "US"
        }
    }

    private static func subtitle(of option: UnitsSetting) -> String {
        switch option {
        case .automatic:
            let system = UnitsSetting.regionSystem == .metric ? "Metric" : "US"
            if let code = Locale.current.region?.identifier,
               let region = Locale.current.localizedString(forRegionCode: code) {
                return "From your region (\(region)): \(system)"
            }
            return "From your region: \(system)"
        case .metric: return "Grams and millilitres"
        case .us: return "Cups, ounces and pounds"
        }
    }

    // MARK: - Preview

    private struct PreviewIngredient {
        let name: String
        let amount: Double
        let unit: String
    }

    /// A US recipe, shown through the real converter, so the preview reads exactly like a recipe page.
    private static let previewIngredients = [
        PreviewIngredient(name: "All-purpose flour", amount: 0.5, unit: "cup"),
        PreviewIngredient(name: "Olive oil", amount: 0.25, unit: "cup"),
        PreviewIngredient(name: "Low-sodium chicken broth", amount: 1, unit: "cup"),
        PreviewIngredient(name: "Unsalted butter", amount: 3, unit: "tbsp"),
        PreviewIngredient(name: "Capers", amount: 2, unit: "tbsp"),
        PreviewIngredient(name: "Chopped parsley", amount: 0.25, unit: "cup")
    ]

    private static func previewAmount(_ sample: PreviewIngredient, system: UnitSystem) -> String {
        UnitConverter.measure(amount: sample.amount, unit: sample.unit, name: sample.name,
                              scale: 1, system: system)?.combined ?? "\(sample.amount) \(sample.unit)"
    }
}

/// A section title: capitals as iOS writes them, a little larger than the system's, so it reads as a heading.
private struct SectionTitle: View {
    let text: String
    init(_ text: String) { self.text = text }

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
    }
}

/// One choice in the Units section: title, subtitle and a check circle.
private struct UnitsOptionRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    /// 18 pt at the default text size, between body (17) and title 3 (20); grows with Dynamic Type.
    @ScaledMetric(relativeTo: .body) private var titleSize: CGFloat = 18

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: titleSize, weight: .semibold))
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundStyle(isSelected ? Color.green : Color(.tertiaryLabel))
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

/// One rule in "How amounts are shown": a coloured icon square, a title, a short detail and an optional pill.
private struct AmountRuleRow: View {
    let symbol: String
    let color: Color
    let title: String
    let detail: String
    var trailing: String? = nil

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 28, height: 28)
                .background(RoundedRectangle(cornerRadius: 7).fill(color))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(detail)
                    .font(.subheadline) // the same size as the Units subtitles
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let trailing {
                Spacer(minLength: 8)
                Text(trailing)
                    .font(.subheadline.weight(.bold))
                    .lineLimit(1)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(Color(.tertiarySystemFill)))
            }
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { SettingsView() }
}
