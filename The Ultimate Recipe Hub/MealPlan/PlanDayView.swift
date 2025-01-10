//
//  PlanDayView.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 30.12.2024.
//

import SwiftUI

struct PlanDayView: View {
    var day: String
    var date: String
    var isToday: Bool = false
    var isPast: Bool = false
    
    var isBreakfastSlot1Filled: Bool = false
    var isBreakfastSlot2Filled: Bool = false
    
    var isLunchSlot1Filled: Bool = false
    var isLunchSlot2Filled: Bool = false
    
    var isDinnerSlot1Filled: Bool = false
    var isDinnerSlot2Filled: Bool = false
    
    var cornerRadius: CGFloat = 12
    
    @State var isExpanded: Bool = true
    
    var body: some View {
        VStack {
            ZStack{
                HStack {
                    Text(day)
                        .font(.system(size: 18).bold())
                    
                    Text(date)
                        .font(.system(size: 16).bold())
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    if !isPast {
                        HStack (spacing: 10) {
                            
                            if !(isBreakfastSlot1Filled && isBreakfastSlot2Filled &&
                                isLunchSlot1Filled && isLunchSlot2Filled &&
                                isDinnerSlot1Filled && isDinnerSlot2Filled)
                                
                            {
                                IconButton(
                                    systemImageName: "calendar.badge.plus",
                                    systemImageColor: .green,
                                    action: {
                                        
                                    })
                            }
                            
                            IconButton(
                                systemImageName: "cart.fill",
                                systemImageColor: .green,
                                action: {
                                    
                                })
                            
                            IconButton(
                                systemImageName: "trash",
                                systemImageColor: .red,
                                action: {
                                    
                                })
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(isPast ? .gray.opacity(0.2) : .green.opacity(0.15))
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
            }
            
            if isExpanded {
                VStack(spacing: 10) {
                    
                    NutritionalInfoView()
                    
                    VStack(spacing: 5) {
                        HStack(spacing: 20) {
                            
                            if isBreakfastSlot1Filled {
                                RecipePlanCard(
                                    title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
                                    recipeTypeTitle: "Breakfast",
                                    imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
                                    isActionButtonVisible: !isPast,
                                    action: {
                                    })
                            }
                            
                            else {
                                EmptyRecipeSlot(title: "Breakfast") {
                                    
                                }
                            }
                            
                            if isBreakfastSlot2Filled {
                                RecipePlanCard(
                                    title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                    recipeTypeTitle: "Breakfast",
                                    imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette",
                                    isActionButtonVisible: !isPast,
                                    action: {
                                    })
                            }
                            
                            else {
                                EmptyRecipeSlot(title: "Breakfast") {
                                    
                                }
                            }
                        }
                        .scaleEffect(0.95)
                        
                        HStack(spacing: 20) {

                            if isLunchSlot1Filled {
                                RecipePlanCard(
                                    title: "Paneer and Cauliflower Makhani",
                                    recipeTypeTitle: "Lunch",
                                    imageUrl: "Paneer and Cauliflower Makhani",
                                    isActionButtonVisible: !isPast,
                                    action: {
                                    })
                            }
                            
                            else {
                                EmptyRecipeSlot(title: "Lunch") {
                                    
                                }
                            }
                            
                            if isLunchSlot2Filled {
                                RecipePlanCard(
                                    title: "Beet-Chickpea Cakes With Tzatziki",
                                    recipeTypeTitle: "Lunch",
                                    imageUrl: "Beet-Chickpea Cakes With Tzatziki",
                                    isActionButtonVisible: !isPast,
                                    action: {
                                    })
                            }
                            
                            else {
                                EmptyRecipeSlot(title: "Lunch") {
                                    
                                }
                            }
                        }
                        .scaleEffect(0.95)

                        HStack(spacing: 20) {

                            if isDinnerSlot1Filled {
                                RecipePlanCard(
                                    title: "Peruvian Chicken & Basil Pasta (Sopa Seca)",
                                    recipeTypeTitle: "Dinner",
                                    imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)",
                                    isActionButtonVisible: !isPast,
                                    action: {
                                    })
                            }
                            
                            else {
                                EmptyRecipeSlot(title: "Dinner") {
                                    
                                }
                            }
                            
                            if isDinnerSlot2Filled {
                                RecipePlanCard(
                                    title: "Haitian Legim",
                                    recipeTypeTitle: "Dinner",
                                    imageUrl: "Haitian Legim",
                                    isActionButtonVisible: !isPast,
                                    action: {
                                    })
                            }
                            
                            else {
                                EmptyRecipeSlot(title: "Dinner") {
                                    
                                }
                            }
                        }
                        .scaleEffect(0.95)
                    }
                    
                    if isToday {
                        WaterChallengeView()
                            .padding(.top, 5)
                    }
                }
                .padding(.bottom, 20)
                .animation(.easeInOut(duration: 0.5), value: isExpanded)
            }
        }
        .background(.white)
        .cornerRadius(cornerRadius)
        .shadow(radius: 3, x: 1, y: 2)
        .padding(.horizontal, 10)
        .onAppear{
            isExpanded = isToday
        }
    }
}

struct PlanDayView_Previews: PreviewProvider {
    static var previews: some View {
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
    }
}
