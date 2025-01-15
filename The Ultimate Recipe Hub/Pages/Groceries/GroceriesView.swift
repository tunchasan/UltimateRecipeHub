//
//  GroceriesView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 15.01.2025.
//

import UIKit
import SwiftUI

struct GroceriesView: View {
    @ObservedObject var groceriesManager = GroceriesManager.shared
    @State private var showCopyConfirmation: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if groceriesManager.groceries.isEmpty {
                    emptyStateView
                } else {
                    groceriesListView
                }
            }
            .toolbar {
                if !groceriesManager.groceries.isEmpty {
                    toolbarContent
                }
            }
            .overlay(copyConfirmationOverlay, alignment: .top)
            .navigationTitle("Groceries")
        }
    }
    
    // MARK: - Subviews
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Text("Your grocery list is empty.")
                .font(.title3.bold())
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
            Spacer()
        }
    }
    
    private var groceriesListView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: -5) {
                ForEach(groceriesManager.groceries, id: \.id) { grocery in
                    HStack(spacing: 10) {
                        CheckableButton(
                            text: attributedIngredientString(quantity: grocery.firstText, name: grocery.secondText, isChecked: grocery.isChecked),
                            isChecked: Binding(
                                get: { grocery.isChecked },
                                set: { _ in groceriesManager.toggleCheckStatus(for: grocery.id) }
                            ),
                            deleteAction: {
                                groceriesManager.removeGrocery(by: grocery.id)
                            }
                        )
                    }
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .center)
                }
            }
            .padding(.top, 5)
            .padding(.bottom, 15)
            .padding(.horizontal, 10)
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Button(action: copyUncheckedGroceries) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(.gray.opacity(0.75))
                    .font(.system(size: 14).bold())
            }

            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    groceriesManager.clearAll()
                }
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.system(size: 16).bold())
            }
        }
    }
    
    private var copyConfirmationOverlay: some View {
        Group {
            if showCopyConfirmation {
                Text("Copied to clipboard!")
                    .font(.body.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showCopyConfirmation = false
                            }
                        }
                    }
                
            }
        }
    }
    
    /// Generates an attributed string for an ingredient with optional formatting.
    private func attributedIngredientString(quantity: String, name: String, isChecked: Bool) -> AttributedString {
        var attributedString = AttributedString()
        
        if !quantity.isEmpty {
            var quantityString = AttributedString(quantity)
            quantityString.font = .system(size: 15).bold()
            quantityString.foregroundColor = isChecked ? .gray : .green
            attributedString += quantityString + AttributedString(" ")
        }
        
        var nameString = AttributedString(name)
        nameString.font = .system(size: 15)
        nameString.foregroundColor = isChecked ? .gray : .black
        attributedString += nameString
        
        if isChecked {
            attributedString.inlinePresentationIntent = .strikethrough
        }
        
        return attributedString
    }
    
    private func copyUncheckedGroceries() {
        let clipboardText = groceriesManager.uncheckedGroceriesText()
        UIPasteboard.general.string = clipboardText
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Show confirmation
        showCopyConfirmation = true
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
