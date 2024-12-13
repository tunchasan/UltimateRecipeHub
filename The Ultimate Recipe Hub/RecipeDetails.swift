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
    
    @State private var addToPlan: Bool = false
    
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
            
            ServingOptionsView(addToPlanAction: {
                addToPlan = true
            })
        }
        .sheet(isPresented: $addToPlan, onDismiss: {
            addToPlan = false
        }) {
            AddRecipePlan(
                imageName: "No-Noodle Eggplant Lasagna with Mushroom Ragú",
                title: "Baked Salmon With Brown-Buttered Tomatoes & Basil"
            )
        }
    }
}

struct ReplaceRecipe: View{
   
    var body: some View {
        VStack{
            
            ScrollView{
                VStack (spacing: 25){
                    VStack (spacing: 20){
                        
                        Image("No-Noodle Eggplant Lasagna with Mushroom Ragú")
                            .resizable()
                            .scaledToFill() // Ensures the image fills the available space
                            .frame(height: UIScreen.main.bounds.height * 0.3) // Take 40% of screen height
                            .clipped() // Ensures no overflow
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.75), radius: 3)

                        Text("Baked Salmon With Brown-Buttered Tomatoes & Basil")
                            .font(.system(size: 18).bold())
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                        
                        HStack {
                            TextButton(
                                title: "2100",
                                subTitle: "Calories",
                                titleColor: .orange,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            
                            TextButton(
                                title: "40gr",
                                subTitle: "Protein",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            TextButton(
                                title: "140gr",
                                subTitle: "Carb",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            TextButton(
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
                        .font(.system(size: 22).bold())
                        .foregroundColor(.black.opacity(0.7))
                        .padding() // Add padding to make the circle larger than the icon
                        .background(Color.white) // Set the background color
                        .clipShape(Circle()) // Make the background circular
                        .shadow(color: .black.opacity(0.75), radius: 1)

                    VStack (spacing: 20){
                        Image("Peruvian Chicken & Basil Pasta (Sopa Seca)")
                            .resizable()
                            .scaledToFill() // Ensures the image fills the available space
                            .frame(height: UIScreen.main.bounds.height * 0.3) // Take 40% of screen height
                            .clipped() // Ensures no overflow
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.75), radius: 3)

                        Text("Peruvian Chicken & Basil Pasta (Sopa Seca)")
                            .font(.system(size: 16).bold())
                            .frame(maxWidth: .infinity)
                            .lineLimit(1)
                        
                        HStack {
                            TextButton(
                                title: "1830",
                                subTitle: "Calories",
                                titleColor: .green,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            
                            TextButton(
                                title: "40gr",
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
                                titleColor: .orange,
                                titleFontSize: 20,
                                action: {
                                    print("Favorites tapped")
                                }
                            )
                            TextButton(
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

struct ReplaceRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        ReplaceRecipe()
    }
}

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

import SwiftUI

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


struct ServingOptionsView: View {
    @State private var selectedServing: String = "2 Serving" // Default selected value
    
    var addToPlanAction: () -> Void // Action to perform on button tap
    
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
                       action: { addToPlanAction() })
        }
        .padding([.top, .horizontal]) // Removed bottom padding
        .background(Color.gray.opacity(0.075))
    }
}

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
        AddRecipePlan(
            imageName: "Baked Salmon With Brown-Buttered Tomatoes & Basil", // Replace with your image name in Assets
            title: "Baked Salmon With Brown-Buttered Tomatoes & Basil"
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
