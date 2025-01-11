//
//  AddRecipePlan.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct AddRecipePlan: View {
    var imageName: String // Name of the image in Assets Catalog
    var title: String     // Title text to display below the image
    
    @State private var selectedServing: String = "Breakfast" // Default selected value
    
    @State private var selectedDate: String? = "Today" // Tracks the active toggle
    
    @State private var isSheetOpen: Bool = false
    
    var body: some View {
        
        VStack{
            
            ScrollView{
                
                Image(imageName)
                    .resizable()
                    .scaledToFill() // Ensures the image fills the available space
                    .frame(height: UIScreen.main.bounds.height * 0.3) // Take 40% of screen height
                    .clipped() // Ensures no overflow
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                
                VStack(spacing: 25) {
                    Text(title)
                        .font(.title3.bold())
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    
                    VStack(spacing: 10) {
                        
                        HStack{
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 21).bold())
                                .foregroundColor(.orange)
                            
                            Text("Select your meal to replace")
                                .font(.system(size: 16))
                            
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        LabeledToggle(label: "Breakfast", isOn: Binding(
                            get: { selectedServing == "Breakfast" },
                            set: { if $0 { selectedServing = "Breakfast" } }
                        )) {
                            print("Breakfast toggled")
                        }
                        
                        LabeledToggle(label: "Lunch", isOn: Binding(
                            get: { selectedServing == "Lunch" },
                            set: { if $0 { selectedServing = "Lunch" } }
                        )) {
                            print("Lunch toggled")
                        }
                        
                        LabeledToggle(label: "Dinner", isOn: Binding(
                            get: { selectedServing == "Dinner" },
                            set: { if $0 { selectedServing = "Dinner" } }
                        )) {
                            print("Dinner toggled")
                        }
                        
                        
                    }
                    
                    VStack(spacing: 10) {
                        
                        HStack{
                            
                            Image(systemName: "info.circle.fill")
                                .font(.system(size: 21).bold())
                                .foregroundColor(.orange)
                            
                            Text("Select the suitable date for you")
                                .font(.system(size: 16))
                            
                            Spacer()
                        }
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                        
                        LabeledToggle(label: "Today", isOn: Binding(
                            get: { selectedDate == "Today" },
                            set: { if $0 { selectedDate = "Today" } }
                        )) {
                            print("Today toggled")
                        }
                        
                        LabeledToggle(label: "Tomorrow", isOn: Binding(
                            get: { selectedDate == "Tomorrow" },
                            set: { if $0 { selectedDate = "Tomorrow" } }
                        )) {
                            print("Tomorrow toggled")
                        }
                        
                        LabeledToggle(label: "13 December", isOn: Binding(
                            get: { selectedDate == "13 December" },
                            set: { if $0 { selectedDate = "13 December" } }
                        )) {
                            print("13 December toggled")
                        }
                        
                        LabeledToggle(label: "14 December", isOn: Binding(
                            get: { selectedDate == "14 December" },
                            set: { if $0 { selectedDate = "14 December" } }
                        )) {
                            print("14 December toggled")
                        }
                        
                        LabeledToggle(label: "15 December", isOn: Binding(
                            get: { selectedDate == "15 December" },
                            set: { if $0 { selectedDate = "15 December" } }
                        )) {
                            print("15 December toggled")
                        }
                        
                        LabeledToggle(label: "16 December", isOn: Binding(
                            get: { selectedDate == "16 December" },
                            set: { if $0 { selectedDate = "16 December" } }
                        )) {
                            print("16 December toggled")
                        }
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
            
            // Second Rich Button
            RichButton(title: "DONE",
                       emoji: "",
                       backgroundColor: .green,
                       minHeight: 43,
                       emojiFontSize: 30,
                       titleFontSize: 18,
                       emojiColor: .white,
                       titleColor: .white,
                       useSystemImage: false,
                       action: { isSheetOpen = true })
            .padding([.top, .horizontal])
            .background(Color.gray.opacity(0.1))
        }
        .sheet(isPresented: $isSheetOpen, onDismiss: {
            isSheetOpen = false
        }) {
            ReplaceRecipe()
        }
    }
}

struct AddRecipePlanView_Previews: PreviewProvider {
    static var previews: some View {
        AddRecipePlan(
            imageName: "Baked Salmon With Brown-Buttered Tomatoes & Basil", // Replace with your image name in Assets
            title: "Baked Salmon With Brown-Buttered Tomatoes & Basil"
        )
    }
}
