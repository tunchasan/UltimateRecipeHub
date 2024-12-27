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
                    ExampleFilledPlanDayView(day: "Today", date: "Dec 15")
                    PlanDayView(day: "Tomorrow", date: "Dec 16")
                    PlanDayView(day: "Monday", date: "Dec 17")
                    PlanDayView(day: "Tuesday", date: "Dec 18")
                    PlanDayView(day: "Wednesday", date: "Dec 19")
                    PlanDayView(day: "Thursday", date: "Dec 20")
                    PlanDayView(day: "Friday", date: "Dec 21")
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

struct PlanDayView: View {
    var day: String
    var date: String
    var cornerRadius: CGFloat = 12
    
    @State var isExpanded: Bool = false
    
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
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.green.opacity(0.2))
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                
                DailyPlanMenuButton(systemImageName: "ellipsis")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 15)
                    .onTapGesture {
                        withAnimation {
                            if !isExpanded {
                                isExpanded = true
                            }
                        }
                    }
                
            }
            
            if isExpanded {
                VStack(spacing: 20) {
                    HStack {
                        TextButton(
                            title: "0",
                            subTitle: "Calories",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        
                        TextButton(
                            title: "0gr",
                            subTitle: "Protein",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        TextButton(
                            title: "0gr",
                            subTitle: "Carb",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        TextButton(
                            title: "0gr",
                            subTitle: "Fat",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    .padding(.vertical, 10)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(cornerRadius)
                    .padding(.horizontal, 10)
                    
                    HStack(spacing: 20) {
                        EmptyRecipeSlot(title: "Breakfast") {
                            
                        }
                        
                        EmptyRecipeSlot(title: "Breakfast") {
                            
                        }
                    }
                    
                    HStack(spacing: 20) {
                        EmptyRecipeSlot(title: "Lunch") {
                            
                        }
                        
                        EmptyRecipeSlot(title: "Lunch") {
                            
                        }
                    }
                    
                    HStack(spacing: 20) {
                        EmptyRecipeSlot(title: "Dinner") {
                            
                        }
                        
                        EmptyRecipeSlot(title: "Dinner") {
                            
                        }
                    }
                }
                .padding(.vertical, 5)
                .padding(.bottom, 10)
                .animation(.easeInOut(duration: 0.5), value: isExpanded)
            }
        }
        .background(.white)
        .cornerRadius(cornerRadius)
        .shadow(radius: 3, x: 1, y: 2)
        .padding(.horizontal, 10)
    }
}

struct ExampleFilledPlanDayView: View {
    var day: String
    var date: String
    var cornerRadius: CGFloat = 12
    
    @State var isExpanded: Bool = false
    
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
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(.green.opacity(0.2))
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                
                DailyPlanMenuButton(systemImageName: "ellipsis")
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 15)
                    .onTapGesture {
                        withAnimation {
                            if !isExpanded {
                                isExpanded = true
                            }
                        }
                    }
            }

            if isExpanded {
                VStack(spacing: 45) {
                    HStack {
                        TextButton(
                            title: "2340",
                            subTitle: "Calories",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        
                        TextButton(
                            title: "50gr",
                            subTitle: "Protein",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        TextButton(
                            title: "200gr",
                            subTitle: "Carb",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        TextButton(
                            title: "120gr",
                            subTitle: "Fat",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    .padding(.vertical, 10)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(cornerRadius)
                    .padding(.horizontal, 10)
                    
                    VStack(spacing: 55) {
                        HStack(spacing: 20) {
                            RecipePlanCard(
                                title: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
                                recipeTypeTitle: "Breakfast",
                                imageUrl: "Squash & Brown Butter Tortelli With Brussels Sprouts & Balsamic",
                                difficulty: 2,
                                action: {
                                })
                            
                            RecipePlanCard(
                                title: "Not-Too-Virtuous Salad with Caramelized Apple Vinaigrette",
                                recipeTypeTitle: "Breakfast",
                                imageUrl: "Peach & Tomato Salad With Fish Sauce Vinaigrette",
                                difficulty: 2,
                                action: {
                                })
                        }
                        
                        HStack(spacing: 20) {
                            RecipePlanCard(
                                title: "Paneer and Cauliflower Makhani",
                                recipeTypeTitle: "Lunch",
                                imageUrl: "Paneer and Cauliflower Makhani",
                                difficulty: 2,
                                action: {
                                })
                            
                            RecipePlanCard(
                                title: "Beet-Chickpea Cakes With Tzatziki",
                                recipeTypeTitle: "Lunch",
                                imageUrl: "Beet-Chickpea Cakes With Tzatziki",
                                difficulty: 3,
                                action: {
                                })
                        }
                        
                        HStack(spacing: 20) {
                            RecipePlanCard(
                                title: "Haitian Legim",
                                recipeTypeTitle: "Dinner",
                                imageUrl: "Haitian Legim",
                                difficulty: 2,
                                action: {
                                })

                            RecipePlanCard(
                                title: "Peruvian Chicken & Basil Pasta (Sopa Seca)",
                                recipeTypeTitle: "Dinner",
                                imageUrl: "Peruvian Chicken & Basil Pasta (Sopa Seca)",
                                difficulty: 3,
                                action: {
                                })
                        }
                    }
                    
                    VStack (spacing: 10) {
                        Text("Water Challenge")
                            .font(.system(size: 18).bold())
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(.blue.opacity(0.1))
                            .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                            .padding(.horizontal, 5)
                        
                        Text("Goal 2L")
                            .font(.system(size: 16))
                        
                        Text("0.8L")
                            .font(.system(size: 24).bold())
                        
                        HStack (spacing: 20) {
                            Image(systemName: "waterbottle.fill")
                                .font(.system(size: 40))

                            Image(systemName: "waterbottle.fill")
                                .font(.system(size: 40))

                            Image(systemName: "waterbottle")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                            
                            Image(systemName: "waterbottle")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                            
                            Image(systemName: "waterbottle")
                                .font(.system(size: 40))
                                .foregroundStyle(.gray)
                        }
                        .padding(.top, 10)
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
    }
}

struct EmptyRecipeSlot: View {
    var title: String
    var action: () -> Void // Action to perform when the button is tapped
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.1))
                
                Image(systemName: "plus")
                    .font(.system(size: 40))
                    .foregroundColor(.green.opacity(0.7))
                
                Image("Test1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 170, height: 240) // Size of the button
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .opacity(0.1)
                
                Text(title)
                    .font(.system(size: 14).bold())
                    .foregroundColor(.gray)
                    .padding(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(width: 170, height: 240) // Size of the button
        }
        .buttonStyle(PlainButtonStyle()) // Ensures no extra padding or effects
    }
}

struct EmptyRecipeSlot_Previews: PreviewProvider {
    static var previews: some View {
        EmptyRecipeSlot(title: "Breakfast") {
            print("Empty slot tapped")
        }
        .previewLayout(.sizeThatFits)
        .padding()
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

struct DailyPlanMenuButton: View {
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
                print("Generate Plan for Day tapped")
            } label: {
                Label("Generate Plan for Day", systemImage: "calendar")
            }
            Button(role: .destructive) {
                print("Clear Current Day tapped")
            } label: {
                Label("Clear Current Day", systemImage: "trash")
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

// Rounded corners for specific sides
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}

/*Text("Today")
 .font(.title2.bold())
 .frame(maxWidth: .infinity, alignment: .leading)
 .padding(.horizontal, 15)
 .padding(.bottom, 10)
 
 HStack {
 TextButton(
 title: "2340",
 subTitle: "Calories",
 titleColor: .green,
 titleFontSize: 20,
 action: {
 print("Favorites tapped")
 }
 )
 
 TextButton(
 title: "50gr",
 subTitle: "Protein",
 titleColor: .green,
 titleFontSize: 20,
 action: {
 print("Favorites tapped")
 }
 )
 TextButton(
 title: "200gr",
 subTitle: "Carb",
 titleColor: .green,
 titleFontSize: 20,
 action: {
 print("Favorites tapped")
 }
 )
 TextButton(
 title: "120gr",
 subTitle: "Fat",
 titleColor: .green,
 titleFontSize: 20,
 action: {
 print("Favorites tapped")
 }
 )
 }
 .padding(.vertical, 10)
 .background(.white)
 .cornerRadius(15)
 .padding(.horizontal, 15)
 .shadow(radius: 3, x:1, y:2)
 
 VStack(spacing: 50) {
 
 HStack(spacing: 20) {
 
 }
 
 HStack(spacing: 20) {
 
 }
 
 HStack(spacing: 20) {
 
 }
 }
 .padding(.horizontal, 15)
 .padding(.top, 25)*/
