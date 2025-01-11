//
//  ReplaceRecipe.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 11.01.2025.
//

import SwiftUI

struct ReplaceRecipe: View{
    
    var body: some View {
        VStack{
            
            ScrollView{
                VStack (spacing: 20){
                    VStack (spacing: 15){
                        
                        Image("No-Noodle Eggplant Lasagna with Mushroom Ragú")
                            .resizable()
                            .scaledToFill() // Ensures the image fills the available space
                            .frame(height: UIScreen.main.bounds.height * 0.15) // Take 40% of screen height
                            .clipped() // Ensures no overflow
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.75), radius: 3)
                        
                        Text("Baked Salmon With Brown-Buttered Tomatoes & Basil")
                            .font(.system(size: 16).bold())
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                        
                        HStack {
                            RichTextButton(
                                title: "2100",
                                subTitle: "Calories",
                                titleColor: .orange,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            
                            RichTextButton(
                                title: "40gr",
                                subTitle: "Protein",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            RichTextButton(
                                title: "140gr",
                                subTitle: "Carb",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            RichTextButton(
                                title: "90gr",
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
                        .shadow(radius: 3, x:1, y:2)
                    }
                    
                    Image(systemName: "repeat")
                        .font(.system(size: 18).bold())
                        .foregroundColor(.black.opacity(0.7))
                        .padding(10) // Add padding to make the circle larger than the icon
                        .background(Color.white) // Set the background color
                        .clipShape(Circle()) // Make the background circular
                        .shadow(color: .black.opacity(0.75), radius: 1)
                    
                    VStack (spacing: 15){
                        Image("Peruvian Chicken & Basil Pasta (Sopa Seca)")
                            .resizable()
                            .scaledToFill() // Ensures the image fills the available space
                            .frame(height: UIScreen.main.bounds.height * 0.15) // Take 40% of screen height
                            .clipped() // Ensures no overflow
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.75), radius: 3)
                        
                        Text("Peruvian Chicken & Basil Pasta (Sopa Seca)")
                            .font(.system(size: 16).bold())
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                        
                        HStack {
                            RichTextButton(
                                title: "1830",
                                subTitle: "Calories",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            
                            RichTextButton(
                                title: "40gr",
                                subTitle: "Protein",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            RichTextButton(
                                title: "200gr",
                                subTitle: "Carb",
                                titleColor: .orange,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            RichTextButton(
                                title: "90gr",
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
                        .shadow(radius: 3, x:1, y:2)
                    }
                    
                    HStack (spacing: 20){
                        
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 32).bold())
                            .foregroundColor(.orange)
                        
                        Text("Replacing ") +
                        Text("Baked Salmon").bold() +
                        Text(" with ") +
                        Text("Peruvian Chicken").bold() +
                        Text(" for ") +
                        Text("Lunch").bold() +
                        Text(" on ") +
                        Text("13 December").bold()
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    Spacer()
                }
                .padding()
                .scrollIndicators(.hidden)
            }
            
            // Second Rich Button
            RichButton(title: "REPLACE",
                       emoji: "",
                       backgroundColor: .green,
                       minHeight: 43,
                       emojiFontSize: 30,
                       titleFontSize: 18,
                       emojiColor: .white,
                       titleColor: .white,
                       useSystemImage: false,
                       action: {  })
            .padding([.top, .horizontal])
            .background(Color.gray.opacity(0.1))
        }
    }
}

struct LabeledToggle: View {
    var label: String
    @Binding var isOn: Bool // Manages the toggle state
    var toggleAction: () -> Void
    
    var body: some View {
        HStack {
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .scaleEffect(0.85)
                .onChange(of: isOn) {
                    if isOn { toggleAction() }
                }
            
            Text(label)
                .font(.body)
                .fontWeight(isOn ? .bold : .regular)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
