//
//  PlanView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 26.12.2024.
//

import SwiftUI

struct PlanView: View {
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    PlanDayView(
                        day: "Today",
                        date: "Dec 16",
                        isToday: true,
                        isBreakfastSlot1Filled: true,
                        isBreakfastSlot2Filled: true,
                        isLunchSlot1Filled: true,
                        isLunchSlot2Filled: true,
                        isDinnerSlot1Filled: true,
                        isDinnerSlot2Filled: true
                    )
                    
                    PlanDayView(
                        day: "Monday",
                        date: "Dec 17"
                    )
                    
                    PlanDayView(
                        day: "Tuesday",
                        date: "Dec 18"
                    )
                    
                    PlanDayView(
                        day: "Wednesday",
                        date: "Dec 19"
                    )
                    
                    PlanDayView(
                        day: "Thursday",
                        date: "Dec 20"
                    )
                    
                    PlanDayView(
                        day: "Friday",
                        date: "Dec 21"
                    )
                    
                    PlanDayView(
                        day: "",
                        date: "Dec 15",
                        isPast: true,
                        isBreakfastSlot1Filled: true,
                        isBreakfastSlot2Filled: true,
                        isLunchSlot1Filled: true,
                        isLunchSlot2Filled: true,
                        isDinnerSlot1Filled: true,
                        isDinnerSlot2Filled: true
                    )
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("Meal Plan")
            .toolbar {
                PlanPageMenuButton(systemImageName: "ellipsis")
            }
        }
    }
}

struct PlanPageMenuButton: View {
    var systemImageName: String
    var systemImageColor: Color = .green
    var size: CGFloat = 30
    
    var body: some View {
        Menu {
            Button {
                print("Add to Groceries tapped")
            } label: {
                Label("Add to Groceries", systemImage: "cart.fill")
            }
            Button {
                print("Generate Plan for Week tapped")
            } label: {
                Label("Generate Plan for Week", systemImage: "calendar")
            }
            Button(role: .destructive) {
                print("Clear Current Week tapped")
            } label: {
                Label("Clear Current Week", systemImage: "trash")
            }
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.5).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
    }
}

struct RecipePlanCardMenuButton: View {
    var systemImageName: String
    var systemImageColor: Color = .green
    var size: CGFloat = 30
    
    var body: some View {
        Menu {
            Button {
                print("Swap")
            } label: {
                Label("Swap", systemImage: "repeat")
            }
            Button {
                print("Eaten")
            } label: {
                Label("Eaten", systemImage: "checkmark")
            }
        } label: {
            Image(systemName: systemImageName)
                .foregroundColor(systemImageColor)
                .font(.system(size: size * 0.6).bold())
                .frame(width: size, height: size)
                .background(Circle().fill(Color.white))
        }
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        .buttonStyle(PlainButtonStyle())
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
