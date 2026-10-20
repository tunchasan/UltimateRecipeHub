//
//  GroceriesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 15.01.2025.
//

import UIKit
import SwiftUI
import AlertToast

struct GroceriesView: View {
    @ObservedObject var groceriesManager = GroceriesManager.shared
    @State private var showAlert = false
    @State private var isAddingItem = false
    @State private var newItemText = ""
    @FocusState private var isAddFieldFocused: Bool
    /// Items checked since the last scroll: they stay in place until the list is scrolled.
    @State private var justCheckedIDs: Set<UUID> = []
    /// Eye button: shows the checked items that were hidden.
    @State private var showCheckedItems = false
    /// Bumped after an item is added, so the list scrolls up to show it.
    @State private var scrollToTopTrigger = 0
    /// Items added since the add bar opened: they keep a soft orange background until the bar closes.
    @State private var highlightedIDs: Set<UUID> = []
    /// Set when the user closes the add-field tip with ×; it never shows again.
    @AppStorage("groceryAddTipClosed") private var isAddTipClosed = false
    /// The item being edited in the bar (long press → Edit); nil while adding.
    @State private var editingItemID: UUID?
    /// Scrolls an item into view: the one being edited, once the keyboard is up.
    @State private var revealItemID: UUID?
    /// Long press → Open recipe.
    @State private var openedRecipe: ProcessedRecipe?
    /// The grocery item's name, highlighted on the recipe page.
    @State private var openedRecipeIngredient: String?
    @State private var isRecipeOpen = false
    /// Long press → "Remove all from <recipe>", waiting for confirmation.
    @State private var pendingRecipeRemoval: RecipeRemoval?
    @ObservedObject private var tabVisibilityManager = TabVisibilityManager.shared
    /// Height of the empty page with the keyboard closed. Kept while adding, so the page doesn't move.
    @State private var emptyPageHeight: CGFloat?
    /// Slow "breathing" of the empty page's "Add an item" button.
    @State private var isAddButtonBreathing = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if groceriesManager.groceries.isEmpty {
                    emptyStateView
                } else {
                    groceriesListView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottomTrailing) {
                // Hidden on the empty screen, which has its own "Add an item" button.
                if !isAddingItem && !groceriesManager.groceries.isEmpty {
                    addItemButton
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .safeAreaInset(edge: .bottom) {
                if isAddingItem {
                    addItemBar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .toolbar {
                if !groceriesManager.groceries.isEmpty {
                    toolbarContent
                }
            }
            .navigationTitle("Groceries")
            .toolbar(tabVisibilityManager.isVisible ? .visible : .hidden, for: .tabBar)
            .navigationDestination(isPresented: $isRecipeOpen) {
                if let openedRecipe {
                    // Opened from a grocery item, to check the recipe: no meal-plan, cooking or cart actions.
                    RecipeDetails(
                        model: openedRecipe,
                        canAddToPlan: false,        // no calendar button, no "Add to meal plan" footer
                        isCookingModeEnable: false, // no "Start Cooking" button
                        shouldManageTabBarVisibility: true,
                        isShoppingToolbarButtonEnabled: false, // its ingredients are already on the list
                        highlightedIngredient: openedRecipeIngredient // opens at the ingredients, this one highlighted
                    )
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .onDisappear {
            // Coming back to Groceries shows a clean list: anything checked is tucked away.
            justCheckedIDs.removeAll()
            highlightedIDs.removeAll()
        }
        .onChange(of: isAddingItem) { _, isAdding in
            // The add bar closed: the newly added items fade back to normal.
            if !isAdding && !highlightedIDs.isEmpty {
                highlightedIDs.removeAll() // each row fades out on its own (see GroceryRow)
            }
            if !isAdding {
                // Leaving edit mode: forget the item and its text, so the next add starts empty.
                if editingItemID != nil {
                    editingItemID = nil
                    newItemText = ""
                }
                revealItemID = nil
            }
        }
        .onChange(of: hasCheckedItemsToToggle) { _, hasItems in
            if !hasItems { showCheckedItems = false }
        }
        .onChange(of: isAddFieldFocused) { _, isFocused in
            if !isFocused {
                withAnimation(.easeInOut(duration: 0.2)) { isAddingItem = false }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("All the items in the list will be deleted!"),
                primaryButton: .default(
                    Text("Cancel"),
                    action: {
                        
                    }
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: {
                        groceriesManager.clearAll()
                        ToastVisibilityManager.show(for: "Your list deleted!")
                    }
                )
            )
        }
        .confirmationDialog(
            pendingRecipeRemoval?.title ?? "",
            isPresented: Binding(
                get: { pendingRecipeRemoval != nil },
                set: { if !$0 { pendingRecipeRemoval = nil } }
            ),
            titleVisibility: .visible,
            presenting: pendingRecipeRemoval
        ) { removal in
            Button(removal.buttonTitle, role: .destructive) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    groceriesManager.removeItems(fromRecipe: removal.recipeID)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// Empty-list illustration width: 90% of the screen, fixed, so the keyboard can't shrink it.
    private var emptyArtWidth: CGFloat { UIScreen.main.bounds.width * 0.9 }
    
    /// Empty list, in the style of the first onboarding pages: the hand-drawn grocery illustration
    /// pinned at the top, then the line of text, the green "Add an item" button and a "Browse recipes"
    /// link, centred in the space left below the illustration.
    /// Static: the content is an overlay on an empty layer (an overlay never takes part in layout), and
    /// its height is the page height measured with the keyboard closed. So the keyboard and add bar can't
    /// resize or move it, and it can't push them; the add bar simply covers its bottom.
    private var emptyStateView: some View {
        Color.clear
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear { rememberEmptyPageHeight(geometry.size.height) }
                        .onChange(of: geometry.size.height) { _, height in rememberEmptyPageHeight(height) }
                }
            )
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    // The onboarding "Meal Plan" drawing with its empty side margins trimmed,
                    // at 90% of the screen width (image is 1020×768).
                    Image("Groceries Empty")
                        .resizable()
                        .scaledToFit()
                        .frame(width: emptyArtWidth, height: emptyArtWidth * 768 / 1020)
                        .accessibilityHidden(true)
                    
                    // Says plainly that the list is empty, right under the illustration.
                    // Smaller than the large "Groceries" title, so the two don't compete.
                    Text("\(Text("Your list").foregroundColor(.green)) is empty")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 8)
                    
                    // Centred in the space between the illustration and the tab bar.
                    VStack(spacing: 32) {
                        Text("Add what you need, or tap the cart\non any recipe to add its ingredients.")
                            .font(.system(size: 18))
                            .lineSpacing(2)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 14) {
                            RoundedButton(title: "Add an item", maxWidth: 200, action: openAddField)
                                // Invitation: grows ~6% while a green glow brightens, then settles.
                                .scaleEffect(isAddButtonBreathing ? 1.06 : 1)
                                .shadow(
                                    color: .green.opacity(isAddButtonBreathing ? 0.55 : 0.1),
                                    radius: isAddButtonBreathing ? 16 : 4,
                                    y: 4
                                )
                                .animation(
                                    reduceMotion ? nil : .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                                    value: isAddButtonBreathing
                                )
                                .onAppear { isAddButtonBreathing = !reduceMotion }
                                .onDisappear { isAddButtonBreathing = false }
                            
                            Button("Browse recipes") {
                                HomeSelectionManager.shared.selectedTab = .recipes
                            }
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.green)
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .padding(.top, 24)
                .frame(height: emptyPageHeight, alignment: .top)
            }
            .contentShape(Rectangle())
            .onTapGesture { closeAddField() }
    }
    
    /// Only measured with the keyboard closed; while adding, the page keeps the height it had.
    private func rememberEmptyPageHeight(_ height: CGFloat) {
        guard !isAddingItem, height > 0 else { return }
        emptyPageHeight = height
    }
    
    private var groceriesListView: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                if visibleGroceries.isEmpty {
                    allCheckedView
                }
                LazyVStack(spacing: 0) {
                    ForEach(visibleGroceries, id: \.id) { grocery in
                        let display = grocery.display
                        VStack(spacing: 0) {
                            GroceryRow(
                                name: display.name,
                                quantity: display.quantity,
                                isMeasured: display.isMeasured,
                                isChecked: grocery.isChecked,
                                isHighlighted: highlightedIDs.contains(grocery.id) || editingItemID == grocery.id,
                                toggle: { toggleItem(grocery) },
                                delete: { groceriesManager.removeGrocery(by: grocery.id) },
                                recipeName: grocery.recipeName,
                                onEdit: { startEditing(grocery) },
                                onOpenRecipe: { openRecipe(for: grocery) },
                                onRemoveRecipeItems: { confirmRemoval(for: grocery) }
                            )
                            Divider()
                                .padding(.leading, 34) // circle (22) + spacing (12): starts under the name, like the reference design
                        }
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 96) // keeps the last item clear of the floating + button
                .padding(.horizontal, 16)
                // While adding, rows don't react: a tap closes the add bar instead of checking an item.
                .allowsHitTesting(!isAddingItem)
            }
            // Like Messages: the list scrolls with the keyboard up; a tap on the list closes the add bar.
            .scrollDismissesKeyboard(.never)
            .simultaneousGesture(
                TapGesture().onEnded { closeAddField() },
                including: isAddingItem ? .all : .subviews
            )
            .modifier(OnUserScroll(action: hideJustCheckedItems))
            .onChange(of: scrollToTopTrigger) { _, _ in
                // New items go to the top: bring them into view.
                guard let first = visibleGroceries.first else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(first.id, anchor: .top)
                }
            }
            .onChange(of: revealItemID) { _, id in
                guard let id else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(id, anchor: .center)
                }
            }
        }
    }
    
    // MARK: - Checked items
    
    /// What the list shows: unchecked items, items checked since the last scroll,
    /// and every checked item while the eye button is on.
    private var visibleGroceries: [GroceryItem] {
        groceriesManager.groceries.filter {
            !$0.isChecked || showCheckedItems || justCheckedIDs.contains($0.id)
        }
    }
    
    /// True when there are checked items the eye button can show or hide.
    private var hasCheckedItemsToToggle: Bool {
        groceriesManager.groceries.contains { $0.isChecked && !justCheckedIDs.contains($0.id) }
    }
    
    private func toggleItem(_ item: GroceryItem) {
        if item.isChecked {
            justCheckedIDs.remove(item.id)
        } else {
            justCheckedIDs.insert(item.id) // stays visible until the next scroll
        }
        groceriesManager.toggleCheckStatus(for: item.id)
    }
    
    private func hideJustCheckedItems() {
        guard !justCheckedIDs.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.35)) {
            justCheckedIDs.removeAll()
        }
    }
    
    /// Shown when every item is checked and hidden.
    private var allCheckedView: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .font(.system(size: 40))
                .foregroundColor(.green.opacity(0.8))
            Text("Everything is checked")
                .font(.headline)
                .foregroundColor(.gray)
            Text("Tap the eye to see your checked items.")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
        .transition(.opacity)
    }
    
    // MARK: - Add your own item
    
    private var addItemButton: some View {
        Button(action: openAddField) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Circle().fill(Color.green))
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
        .accessibilityLabel("Add an item")
    }
    
    private var addItemBar: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !isAddTipClosed && editingItemID == nil {
                AddItemTip {
                    withAnimation(.easeInOut(duration: 0.2)) { isAddTipClosed = true }
                }
                .transition(.opacity)
            }
            addItemFieldRow
        }
        .padding(.horizontal, 12)
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background {
            // Same colour as the page, and it runs down behind the keyboard,
            // so no strip shows between the bar and the keyboard.
            Color(.systemBackground)
                .ignoresSafeArea(.all, edges: .bottom)
                .overlay(alignment: .top) { Divider() }
        }
        .onAppear {
            DispatchQueue.main.async { isAddFieldFocused = true }
        }
    }
    
    private var addItemFieldRow: some View {
        HStack(spacing: 10) {
            Button {
                closeAddField()
            } label: {
                Image(systemName: "keyboard.chevron.compact.down")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
            }
            .accessibilityLabel("Close")
            
            // Vertical axis: Return inserts a newline instead of closing the keyboard,
            // so we turn each line into an item and keep the field open for the next one.
            TextField(fieldPlaceholder, text: $newItemText, axis: .vertical)
                .lineLimit(1...3)
                .focused($isAddFieldFocused)
                .textInputAutocapitalization(.sentences)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(.secondarySystemBackground)))
                .onChange(of: newItemText) { _, value in
                    if value.contains(where: \.isNewline) {
                        handleNewlines(in: value)
                    }
                }
            
            Button(action: submit) {
                Image(systemName: editingItemID == nil ? "arrow.up.circle.fill" : "checkmark.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(canSubmitNewItem ? .green : .gray.opacity(0.4))
                    .contentTransition(.symbolEffect(.replace))
            }
            .disabled(!canSubmitNewItem)
            .accessibilityLabel(submitLabel)
        }
    }
    
    private var fieldPlaceholder: String {
        editingItemID == nil ? "What do you need? e.g. 2 eggs" : "Edit item"
    }
    
    private var submitLabel: String {
        editingItemID == nil ? "Add" : "Save"
    }
    
    private var canSubmitNewItem: Bool {
        !newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func openAddField() {
        guard groceriesManager.canAddCustomItems() else { return }
        withAnimation(.easeInOut(duration: 0.2)) { isAddingItem = true }
    }
    
    /// Closes the add bar directly, so it also closes if the keyboard never came up.
    private func closeAddField() {
        isAddFieldFocused = false
        withAnimation(.easeInOut(duration: 0.2)) { isAddingItem = false }
    }
    
    /// The bar's button and Return: add a new item, or save the item being edited.
    private func submit() {
        if editingItemID == nil {
            submitNewItem()
        } else {
            submitEdit()
        }
    }
    
    private func submitNewItem() {
        addItems([newItemText])
        newItemText = ""
    }
    
    /// Each finished line becomes an item; a pasted list ("Milk\nEggs\nBread") adds all of them.
    /// While editing, Return saves the edit instead.
    private func handleNewlines(in value: String) {
        var lines = value.components(separatedBy: .newlines)
        if editingItemID != nil {
            newItemText = lines.first ?? ""
            submitEdit()
            return
        }
        let unfinished = lines.removeLast() // text after the last Return stays in the field
        addItems(lines)
        newItemText = unfinished
    }
    
    private func addItems(_ names: [String]) {
        let existingIDs = Set(groceriesManager.groceries.map(\.id))
        var addedAny = false
        withAnimation(.easeInOut(duration: 0.25)) {
            // Reversed, so the items end up on the list in the order they were typed.
            for name in names.reversed() {
                if groceriesManager.addCustomItem(name) {
                    addedAny = true
                }
            }
        }
        if addedAny {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            scrollToTopTrigger += 1
            // Mark what was added in this session; the highlight clears when the add bar closes.
            highlightedIDs.formUnion(Set(groceriesManager.groceries.map(\.id)).subtracting(existingIDs))
        }
    }
    
    // MARK: - Long-press actions
    
    /// Edit: the add bar opens filled with the item, e.g. "4 tbsp Olive oil"; Return saves.
    private func startEditing(_ item: GroceryItem) {
        editingItemID = item.id
        newItemText = item.editableText
        withAnimation(.easeInOut(duration: 0.2)) { isAddingItem = true }
        // Once the keyboard is up, make sure the item isn't hidden behind it.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { revealItemID = item.id }
    }
    
    private func submitEdit() {
        guard let id = editingItemID else { return }
        if groceriesManager.updateItem(id: id, with: newItemText) {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            closeAddField()
        }
    }
    
    private func openRecipe(for item: GroceryItem) {
        guard let recipeID = item.recipeID,
              let recipe = RecipeSourceManager.shared.findRecipe(byID: recipeID) else {
            ToastVisibilityManager.show(for: "Recipe not found", with: .error)
            return
        }
        // Same rule as the rest of the app: Pro recipes stay locked for free users.
        if recipe.recipe.isProSubscription && User.shared.subscription == .free {
            PaywallVisibilityManager.show(triggeredBy: .attemptToSeeProRecipeDetails)
            return
        }
        openedRecipe = recipe
        openedRecipeIngredient = item.secondText
        isRecipeOpen = true
    }
    
    private func confirmRemoval(for item: GroceryItem) {
        guard let recipeID = item.recipeID else { return }
        pendingRecipeRemoval = RecipeRemoval(
            recipeID: recipeID,
            recipeName: item.recipeName ?? "this recipe",
            count: groceriesManager.itemCount(fromRecipe: recipeID)
        )
    }
    
    private var toolbarContent: some ToolbarContent {
        // One HStack, matching the Recipe Details toolbar.
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 10) {
                if hasCheckedItemsToToggle {
                    toolbarIconButton(
                        systemName: showCheckedItems ? "eye.slash" : "eye",
                        label: showCheckedItems ? "Hide checked items" : "Show checked items"
                    ) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            showCheckedItems.toggle()
                        }
                    }
                    .transition(.opacity)
                }
                
                toolbarIconButton(systemName: "doc.on.doc", label: "Copy list", action: copyUncheckedGroceries)
                
                // Eye and copy symbols draw larger than trash, so they use 14 pt to look the same size.
                toolbarIconButton(systemName: "trash", color: .red, size: 16, label: "Delete all") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showAlert = true
                    }
                }
            }
        }
    }
    
    /// Recipe Details toolbar style: regular weight, 10 pt apart, green (trash red).
    /// Eye and copy use 14 pt and trash 16 pt, so the three symbols look the same size.
    private func toolbarIconButton(systemName: String, color: Color = .green, size: CGFloat = 14, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .foregroundColor(color)
                .font(.system(size: size))
                .contentTransition(.symbolEffect(.replace))
        }
        .accessibilityLabel(label)
    }
    
    private func copyUncheckedGroceries() {
        let clipboardText = groceriesManager.uncheckedGroceriesText()
        UIPasteboard.general.string = clipboardText
        ToastVisibilityManager.show(for: "Your list copied!")
    }
}

struct GroceriesView_Previews: PreviewProvider {
    static var previews: some View {
        GroceriesView()
    }
}

struct GroceriesMenuButton: View {
    var systemImageName: String
    var systemImageColor: Color = .green
    var size: CGFloat = 30
    
    var body: some View {
        Menu {
            Button(role: .destructive) {
                print("Clear")
            } label: {
                Label("Clear", systemImage: "trash")
            }
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.5).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
    }
}

struct CheckableButton: View {
    var text: AttributedString
    @Binding var isChecked: Bool
    var deleteAction: () -> Void
    
    var body: some View {
        VStack {
            Button(action: {
                toggleCheck()
            }) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isChecked ? .green : .gray)
                
                // Attributed quantity and name
                Text(text)
                    .strikethrough(isChecked, color: .gray)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(10)
            .contextMenu {
                Button(role: .destructive, action: {
                    deleteAction()
                }) {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    /// Toggles the check state.
    private func toggleCheck() {
        isChecked.toggle()
    }
}

/// One grocery row: check circle, name on the left, quantity on the right.
/// Amounts to buy are green and semi-bold; words like "to taste" or "for serving" are grey.
struct GroceryRow: View {
    let name: String
    let quantity: String
    let isMeasured: Bool
    let isChecked: Bool
    /// Added while the add bar is open: a soft orange background until the bar closes.
    var isHighlighted = false
    let toggle: () -> Void
    let delete: () -> Void
    /// The recipe the item came from: shown under the item in the long-press preview ("From Lemon Chicken").
    var recipeName: String? = nil
    var onEdit: () -> Void = {}
    var onOpenRecipe: () -> Void = {}
    var onRemoveRecipeItems: () -> Void = {}

    var body: some View {
        Group {
            if let recipeName {
                // Recipe items get a preview card that names the recipe in a readable size;
                // the menu's own section header is a fixed, very small iOS style.
                rowButton
                    .contextMenu {
                        menuItems
                    } preview: {
                        recipePreview(recipeName)
                    }
            } else {
                rowButton
                    .contextMenu { menuItems }
            }
        }
        // Haptics, iOS 17 SwiftUI style: a firm tap when an item is checked, a lighter tick when unchecked.
        .sensoryFeedback(trigger: isChecked) { _, nowChecked in
            nowChecked ? .impact(weight: .medium) : .selection
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isChecked ? [.isSelected] : [])
    }

    private var rowButton: some View {
        Button(action: toggle) {
            rowContent
                .padding(.vertical, 11)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.orange.opacity(isHighlighted ? 0.08 : 0)) // soft orange: "new", without clashing with green (amounts, checked)
                        // The fade belongs to the background itself, so the keyboard closing can't cut it short.
                        .animation(.easeOut(duration: 0.8), value: isHighlighted)
                        .padding(.horizontal, -8) // a little wider than the row's content
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    /// Check circle, name and quantity: used by the row and by the long-press preview.
    private var rowContent: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22))
                .foregroundColor(isChecked ? .green : .gray)

            Text(name)
                .font(.system(size: 16))
                .foregroundColor(isChecked ? .gray : .primary)
                .strikethrough(isChecked, color: .gray)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            if !quantity.isEmpty {
                Text(quantity)
                    .font(.system(size: 16, weight: isMeasured ? .semibold : .regular))
                    .foregroundColor(isChecked || !isMeasured ? .gray : .green)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
            }
        }
    }

    @ViewBuilder
    private var menuItems: some View {
        Section {
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            if recipeName != nil {
                Button(action: onOpenRecipe) {
                    Label("Open recipe", systemImage: "book")
                }
            }
        }
        Section {
            if let recipeName {
                Button(role: .destructive, action: onRemoveRecipeItems) {
                    Label("Remove all from \(recipeName)", systemImage: "cart.badge.minus")
                }
            }
            Button(role: .destructive, action: delete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    /// Long-press preview for recipe items: the item, then "From <recipe>" at a readable size.
    private func recipePreview(_ recipeName: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            rowContent
            Divider()
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Image(systemName: "book")
                    .font(.system(size: 14))
                    .foregroundColor(.green)
                Text("From \(Text(recipeName).fontWeight(.semibold))")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .frame(width: 340)
        .background(Color(.systemBackground))
    }
}

/// Calls `action` when the user scrolls the list.
/// iOS 18+: the system scroll phase. iOS 17 has no scroll callback, so a drag of 10 pt counts as a scroll.
private struct OnUserScroll: ViewModifier {
    let action: () -> Void

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content.onScrollPhaseChange { _, newPhase in
                if newPhase == .interacting { action() }
            }
        } else {
            content.simultaneousGesture(
                DragGesture(minimumDistance: 10)
                    .onChanged { _ in action() }
            )
        }
    }
}

/// Tip above the add field. The first time it appears, it types itself in word by word like the
/// Water Challenge coach tips; the × fades in once the text is complete and hides the tip for good.
private struct AddItemTip: View {
    let onClose: () -> Void

    @AppStorage("groceryAddTipTyped") private var hasTyped = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealedCount = 0
    @State private var isFinished = false

    /// The tip, word by word, with the example in semi-bold.
    private static let tokens: [(text: String, bold: Bool)] = [
        ("Start ", false), ("with ", false), ("the ", false), ("amount, ", false), ("like ", false),
        ("500 ", true), ("g ", true), ("flour", true), (". ", false),
        ("Press ", false), ("return ", false), ("to ", false), ("add ", false), ("the ", false),
        ("next ", false), ("item.", false)
    ]

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 15))
                .foregroundColor(.green)
                .padding(.top, 1)

            // Full width from the start, so words always begin at the same left edge;
            // only the height grows, line by line, and the card grows with it.
            Text(text(upTo: revealedCount))
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel(String(text(upTo: Self.tokens.count).characters))

            Spacer(minLength: 0)

            // Always takes its space (so the text never re-wraps); it fades in when typing is done.
            Button(action: onClose) {
                // Native close style (as in iOS sheets and search fields): grey x on a light grey circle.
                Image(systemName: "xmark.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.gray)
                    .font(.system(size: 20))
                    .frame(width: 30, height: 30) // a bigger tap area than the circle itself
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.top, -5) // lines the circle up with the first line of text
            .opacity(isFinished ? 1 : 0)
            .disabled(!isFinished)
            .accessibilityHidden(!isFinished)
            .accessibilityLabel("Hide tip")
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.green.opacity(0.08)))
        .task { await play() }
    }

    /// The first `count` words. Before the first word, a space keeps the card one line tall.
    private func text(upTo count: Int) -> AttributedString {
        guard count > 0 else { return AttributedString(" ") }
        var result = AttributedString()
        for token in Self.tokens.prefix(count) {
            var piece = AttributedString(token.text)
            if token.bold {
                piece.font = .system(size: 15, weight: .semibold)
            }
            result += piece
        }
        return result
    }

    private func play() async {
        // Type only the first time, and never for Reduce Motion or VoiceOver users.
        let shouldType = !hasTyped && !reduceMotion && !UIAccessibility.isVoiceOverRunning
        guard shouldType else {
            revealedCount = Self.tokens.count
            isFinished = true
            return
        }

        let haptic = UIImpactFeedbackGenerator(style: .light)
        let start = Date()
        for index in Self.tokens.indices {
            try? await Task.sleep(nanoseconds: UInt64(Double.random(in: 0.1...0.2) * 1_000_000_000))
            if Task.isCancelled { return } // bar closed mid-typing: it types again next time
            // For the first half second the bar and keyboard are still sliding in. Animating a word
            // then makes the text fly in from a stale position, so those words just appear.
            if Date().timeIntervalSince(start) < 0.5 {
                revealedCount = index + 1
            } else {
                withAnimation(.easeInOut(duration: 0.15)) { revealedCount = index + 1 }
            }
            haptic.impactOccurred()
        }
        hasTyped = true
        withAnimation(.easeInOut(duration: 0.2)) { isFinished = true }
    }
}

/// "Remove all from <recipe>", waiting for the user to confirm.
private struct RecipeRemoval {
    let recipeID: String
    let recipeName: String
    let count: Int

    var title: String {
        let noun = count == 1 ? "item" : "items"
        return "Remove \(count) \(noun) from \(recipeName)?"
    }

    var buttonTitle: String {
        count == 1 ? "Remove Item" : "Remove \(count) Items"
    }
}
