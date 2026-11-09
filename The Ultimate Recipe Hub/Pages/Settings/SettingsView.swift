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
                Text("Units")
            } footer: {
                Text("Recipes, Cooking Mode and your grocery list follow this. Items you type yourself stay as you wrote them.")
            }

            Section {
                Text("Chicken Piccata · 6 servings")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
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
                HStack {
                    Text("Preview")
                    Spacer()
                    Text(setting.system == .metric ? "Metric" : "US units")
                        .foregroundStyle(.green)
                }
            } footer: {
                Text("Spoons stay as spoons. Tablespoons also show ml in metric, because spoon sizes differ between countries.")
            }

            Section {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Oven temperatures")
                        Text("Always shown in both")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 8)
                    Text("400°F (200°C)")
                        .font(.subheadline.weight(.bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Capsule().fill(Color(.tertiarySystemFill)))
                }
                .accessibilityElement(children: .combine)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.default, value: unitsSettingRaw)
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
        PreviewIngredient(name: "Capers", amount: 2, unit: "tbsp")
    ]

    private static func previewAmount(_ sample: PreviewIngredient, system: UnitSystem) -> String {
        UnitConverter.measure(amount: sample.amount, unit: sample.unit, name: sample.name,
                              scale: 1, system: system)?.combined ?? "\(sample.amount) \(sample.unit)"
    }
}

/// One choice in the Units section: title, subtitle and a check circle.
private struct UnitsOptionRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body.weight(.semibold))
                Text(subtitle)
                    .font(.footnote)
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

#Preview {
    NavigationStack { SettingsView() }
}
