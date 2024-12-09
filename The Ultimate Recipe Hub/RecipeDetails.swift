//
//  RecipeDetails.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 7.12.2024.
//
import SwiftUI

struct RecipeDetails: View {
    var imageName: String // Name of the image in Assets Catalog
    var title: String     // Title text to display below the image
    
    var body: some View {
        VStack {
            
            ScrollView{
                
                Image(imageName)
                    .resizable()
                    .scaledToFill() // Ensures the image fills the available space
                    .frame(height: UIScreen.main.bounds.height * 0.3) // Take 40% of screen height
                    .clipped() // Ensures no overflow
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                
                VStack(alignment: .leading, spacing: 20) { // Align content to leading
                    HStack {
                        Text(title)
                            .font(.title2.bold())
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                                                
                        IconTextButton(
                            systemImageName: "heart",
                            systemImageColor: .black,
                            title: "",
                            imageSize: 30,
                            maxWidth: 30,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    
                    Text("35 minutes • 2 servings")
                        .font(.subheadline.bold())
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                    
                    HStack {
                        TextButton(
                            title: "650",
                            subTitle: "Calories",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        
                        TextButton(
                            title: "12gr",
                            subTitle: "Protein",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        TextButton(
                            title: "20gr",
                            subTitle: "Carb",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        TextButton(
                            title: "30gr",
                            subTitle: "Fat",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    
                    Text("A simple and classic tomato sauce recipe that features just four ingredients: canned tomatoes, onion, butter, and salt. This Italian staple is rich in flavor, easy to prepare, and perfect for pairing with pasta or any dish that needs a comforting sauce.")
                        .font(.system(size: 14))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black)
                        .padding(10)
                        .background(.green.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal, 12)
                    
                }
                
                RecipeIngredientsGridView()
                    .padding(.top, 30)
                
                DirectionsView()
                    .padding(.top, 20)
                
                RecipeTagGridView()
                    .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
            
            ServingOptionsView()
        }
    }
}

struct ServingOptionsView: View {
    @State private var selectedServing: String = "2 Serving" // Default selected value

    var body: some View {
        HStack(spacing: 20) {
            // Dropdown Button
            Menu {
                Button(action: { selectedServing = "1 Serving" }) {
                    Text("1 Serving")
                }
                Button(action: { selectedServing = "2 Servings" }) {
                    Text("2 Servings")
                }
                Button(action: { selectedServing = "3 Servings" }) {
                    Text("3 Servings")
                }
                Button(action: { selectedServing = "4 Servings" }) {
                    Text("4 Servings")
                }
            } label: {
                HStack {
                    Text(selectedServing) // Display the selected serving
                        .font(.system(size: 14).bold())
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .frame(maxWidth: 140, minHeight: 45)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.7), radius: 2)
            }

            // Second Rich Button
            RichButton(title: "Add to meal plan",
                       emoji: "",
                       backgroundColor: .green,
                       minHeight: 43,
                       emojiFontSize: 30,
                       titleFontSize: 14,
                       emojiColor: .white,
                       titleColor: .white,
                       useSystemImage: false,
                       action: {})
        }
        .padding([.top, .horizontal]) // Removed bottom padding
        .background(Color.gray.opacity(0.075))
    }
}


import SwiftUI

struct RecipeIngredientsGridView: View {
    let ingredients = [
        ("1 large", "Butternut squash"),
        ("4 tablespoons", "Extra-virgin olive oil"),
        ("", "Kosher salt and pepper"),
        ("1 pinch", "Cayenne pepper"),
        ("1/4 teaspoon", "Ground nutmeg"),
        ("1", "Red onion"),
        ("1/2 pound", "Orecchiette"),
        ("1 or 2", "Garlic cloves"),
        ("2 cups", "Chicken broth"),
        ("1 bunch", "Kale"),
        ("1/2 cup", "White wine"),
        ("1/2 cup", "Heavy cream"),
        ("1 ounce", "Goat cheese (optional)"),
        ("1 tablespoon", "Fresh sage"),
        ("", "Parmesan cheese, to serve")
    ]
    
    // Adaptive grid layout
    let columns = [GridItem(.adaptive(minimum: 150, maximum: 200), spacing: 10)]
    
    var body: some View {
        VStack(alignment: .leading) {
            // Section Title
            Text("Ingredients")
                .font(.title3.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Ingredients Grid
            VStack(spacing: -5) {
                ForEach(ingredients, id: \.1) { (quantity, name) in
                    HStack(spacing: 5) {
                        Text("•")
                            .font(.subheadline.bold())
                        
                        if !quantity.isEmpty {
                            Text(quantity)
                                .font(.system(size: 14).bold())
                                .foregroundColor(.black)
                        }
                        
                        Text(name)
                            .font(.system(size: 14))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .padding(10)
                    .frame(maxWidth: .infinity, minHeight: 30, alignment: .center)
                }
            }
            .padding(.horizontal)
            
            RichButton(title: "Add Ingredients to shopping list",
                       emoji: "cart.fill",
                       backgroundColor: .green,
                       minHeight: 50,
                       emojiFontSize: 30,
                       emojiColor: .white,
                       titleColor: .white,
                       useSystemImage: true,
                       action: {})
            .padding()
        }
    }
}

struct DirectionsView: View {
    let directions = [
        "Heat the olive oil in a large pot over medium heat. Add the sausage, breaking it up with a spoon, and cook until browned, about 5-7 minutes.",
        "Add the chopped onion, carrots, celery, and minced garlic to the pot. Sauté until the vegetables are softened, about 5 minutes.",
        "Stir in the lentils, diced tomatoes, chicken broth, and bay leaf. Bring the mixture to a boil, then reduce the heat to low and simmer for about 45 minutes, or until the lentils are tender.",
        "Season the soup with salt and black pepper to taste. Remove the bay leaf before serving.",
        "Garnish with chopped fresh parsley, if desired, and serve warm."
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title for Directions Section
            Text("Directions")
                .font(.title3.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Steps List
            ForEach(directions.indices, id: \.self) { index in
                HStack(alignment: .firstTextBaseline) {
                    // Step Number
                    Text("\(index + 1)")
                        .font(.subheadline.bold())
                        .foregroundColor(.black)
                        .frame(width: 25, height: 25) // Circle size
                        .background(
                            Circle()
                                .fill(Color.green.opacity(0.2)) // White background
                        )
                    
                    // Step Description
                    Text(directions[index])
                        .font(.system(size: 16))
                        .lineSpacing(5)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                        .padding(10)
                }
                .padding(.horizontal)
            }
        }
    }
}


struct TopImageWithTitleView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(
            imageName: "Duck Breast With Blueberry-Port Sauce", // Replace with your image name in Assets
            title: "Duck Breast With Blueberry-Port Sauce"
        )
    }
}

struct RecipeTagGridView: View {
    let ingredients = [
        "PASTA",
        "ITALIAN",
        "ONION",
        "ONE POT",
        "GOAT CHEESE",
        "BUTTERNUT SQUASH",
        "VEGETARIAN",
        "MILK/CREAM",
        "NUTMEG",
        "FALL",
        "ENTREE",
        "APPETIZER"
    ]
    
    // Adaptive grid layout
    let columns = [GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10)]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("TAGS")
                .font(.system(size: 14).bold())
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Ingredients Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                        .font(.system(size: 12).italic())
                        .foregroundColor(.black)
                        .padding(.horizontal, 5)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background(.yellow.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
        }
        .padding(.vertical)
    }
}
