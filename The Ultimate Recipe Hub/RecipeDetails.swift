//
//  RecipeDetails.swift
//  The Ultimate Recipe Hub
//
//  Created by Personal on 7.12.2024.
//
import SwiftUI

struct RecipeDetails: View {
    
    var model: RecipeModel
    @State private var startCooking: Bool = false
    @State private var addToPlan: Bool = false
    
    var body: some View {
        VStack (spacing:0){
            ScrollView{
                ZStack{
                    Image("Baked Salmon With Brown-Buttered Tomatoes & Basil")
                        .resizable()
                        .scaledToFill() // Ensures the image fills the available space
                        .frame(height: UIScreen.main.bounds.height * 0.3) // Take 40% of screen height
                        .clipped() // Ensures no overflow
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                    
                    RichButton(title: "Start Cooking",
                               emoji: "",
                               backgroundColor: .green,
                               minHeight: 50,
                               maxWidth: 200,
                               titleFontSize: 18,
                               emojiColor: .white,
                               titleColor: .white,
                               useSystemImage: false,
                               action: { startCooking = true })
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: 25)
                }
                
                VStack(alignment: .leading, spacing: 20) { // Align content to leading
                    Text(model.name)
                        .font(.title2.bold())
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                    
                    HStack{
                        Text("\(String(model.difficultyType.rawValue)) • \(String(model.cookTime.duration)) minutes • \(String(model.serves)) servings")
                            .font(.subheadline.bold())
                            .foregroundColor(.gray)
                            .padding(.horizontal, 20)
                    }
                    
                    HStack {
                        RichTextButton(
                            title: String(model.calories),
                            subTitle: "Calories",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        
                        RichTextButton(
                            title: String(model.macros.protein),
                            subTitle: "Protein",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        RichTextButton(
                            title: String(model.macros.carbs),
                            subTitle: "Carb",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                        RichTextButton(
                            title: String(model.macros.fat),
                            subTitle: "Fat",
                            titleColor: .green,
                            titleFontSize: 20,
                            action: {
                                print("Favorites tapped")
                            }
                        )
                    }
                    
                    Text(model.description)
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
                .padding(.top, 25)
                
                RecipeIngredientsGridView(ingredients: model.formattedIngredients)
                    .padding(.top, 30)
                
                DirectionsView(directions: model.steps)
                    .padding(.top, 20)
                
                RecipeTagGridView(tags: model.combinedTags)
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
        .sheet(isPresented: $startCooking, onDismiss: {
            startCooking = false
        }) {
            DirectionView(
                directions: model.steps,
                imageName: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                title: model.name
            ) {
                startCooking = false
            }
        }
        .toolbar{
            HStack (spacing:10) {
                Button(action: { }) {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                Button(action: { }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
                
                Button(action: { }) {
                    Image(systemName: "heart")
                        .foregroundColor(.green)
                        .font(.system(size: 16))
                }
            }
        }
    }
}

struct RecipeDetails_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetails(
            model: RecipeModel(
                name: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                description: "A rich and flavorful salmon recipe featuring brown-buttered tomatoes and basil for a delightful dinner experience.",
                tag1: ["Dinner", "Seafood", "Healthy"],
                tag2: ["Salmon", "Tomato", "Basil", "Gluten-Free"],
                sourceURL: "https://example.com",
                imageURL: "Baked Salmon With Brown-Buttered Tomatoes & Basil",
                ratingCount: 105,
                reviewCount: 45,
                rating: 4.7,
                serves: 2,
                subscription: "Pro",
                prepTime: TimeInfo(duration: 10, timeUnit: "minutes"),
                cookTime: TimeInfo(duration: 25, timeUnit: "minutes"),
                mealType: ["Dinner"],
                dishType: "Seafood",
                specialConsideration: ["Gluten-Free"],
                preparationType: ["Baked"],
                ingredientsFilter: ["Fish", "Butter"],
                cuisine: "American",
                difficulty: "Beginner",
                macros: Macros(carbs: 8, protein: 32, fat: 14),
                ingredients: [
                    Ingredient(ingredientName: "Salmon Fillet", ingredientAmount: 2, ingredientUnit: "pieces"),
                    Ingredient(ingredientName: "Cherry Tomatoes", ingredientAmount: 200, ingredientUnit: "g"),
                    Ingredient(ingredientName: "Unsalted Butter", ingredientAmount: 3, ingredientUnit: "tbsp"),
                    Ingredient(ingredientName: "Fresh Basil Leaves", ingredientAmount: 10, ingredientUnit: "pieces")
                ],
                steps: [
                    "Preheat oven to 400°F (200°C).",
                    "Place salmon fillets on a baking sheet.",
                    "In a skillet, melt butter until golden brown. Add tomatoes and sauté until softened.",
                    "Pour the brown-buttered tomatoes over the salmon and bake for 15-20 minutes.",
                    "Garnish with fresh basil leaves and serve warm."
                ],
                calories: 300
            )
        )
        .previewLayout(.device)
    }
}

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
                Button(action: { selectedServing = "5 Servings" }) {
                    Text("5 Servings")
                }
                Button(action: { selectedServing = "6 Servings" }) {
                    Text("6 Servings")
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
        .padding([.top, .horizontal, .bottom])
        .background(Color.gray.opacity(0.075))
    }
}

struct RecipeIngredientsGridView: View {
    var ingredients: [(String, String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Section Title
            Text("Ingredients")
                .font(.title3.bold())
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Ingredients List
            ForEach(ingredients, id: \.1) { (quantity, name) in
                HStack(spacing: 5) {
                    // Bullet Point
                    Text("•")
                        .font(.subheadline.bold())
                    
                    // Attributed Ingredient String
                    Text(attributedIngredientString(quantity: quantity, name: name))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .padding(.leading)
                .padding(.vertical, 5)
            }
        }
    }
    
    // Function to generate attributed ingredient strings
    private func attributedIngredientString(quantity: String, name: String) -> AttributedString {
        var attributedString = AttributedString()
        
        if !quantity.isEmpty {
            var quantityString = AttributedString(quantity)
            quantityString.font = .system(size: 14).weight(.bold) // Bold font for quantity
            quantityString.foregroundColor = .black
            attributedString += quantityString + AttributedString(" ")
        }
        
        var nameString = AttributedString(name)
        nameString.font = .system(size: 14) // Regular font for name
        nameString.foregroundColor = .black
        attributedString += nameString
        
        return attributedString
    }
}

struct DirectionsView: View {
    
    @State var directions: [String]
    
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

struct DirectionView: View {
    var directions: [String]
    var imageName: String
    var title: String
    var action: () -> Void
    
    @State private var currentStep: Int = 0
    @State private var progress: CGFloat = 0
    @State private var imageHeight: CGFloat = 0.3
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * imageHeight)
                    .clipped()
                    .opacity(0.2)
                
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: UIScreen.main.bounds.height * imageHeight)
                    .clipped()
                    .mask(
                        GeometryReader { geometry in
                            Rectangle()
                                .frame(width: geometry.size.width * progress) // Mask width based on progress
                        }
                    )
            }
            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
            
            HStack(spacing: 20) {
                Text(title)
                    .font(.title2.bold())
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.green)
                
                if currentStep < directions.count - 1 {
                    Text("\(currentStep + 1)/\(directions.count)")
                        .font(.system(size: 20).bold())
                        .foregroundStyle(.green)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 10)
            
            Spacer()
            
            TabView(selection: $currentStep) {
                ForEach(directions.indices, id: \.self) { index in
                    Text(directions[index])
                        .font(.system(size: 20))
                        .lineSpacing(5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.horizontal, 30)
                        .tag(index) // Bind tab selection to `currentStep`
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Disable default dots
            .onChange(of: currentStep) { // Update progress
                withAnimation{
                    progress = CGFloat(currentStep) / CGFloat(directions.count - 1)
                    
                    if currentStep == directions.count - 1 {
                        imageHeight = 0.5
                    }
                    
                    else {
                        imageHeight = 0.3
                    }
                }
            }
            .padding(.bottom, 20)
            
            Spacer()
            
            HStack {
                TextButton(
                    title: "Back",
                    titleColor: .black,
                    titleFontSize: 20
                ) {
                    if currentStep > 0 {
                        withAnimation {
                            progress -= 0.2
                            currentStep -= 1
                            imageHeight = 0.3
                        }
                    }
                    
                    else {
                        action()
                    }
                }
                
                TextButton(
                    title: currentStep == directions.count - 1 ? "Done" : "Next",
                    titleColor: .white,
                    titleFontSize: 20
                ) {
                    if currentStep < directions.count - 1 {
                        withAnimation {
                            progress += 0.2
                            currentStep += 1
                            imageHeight = 0.3
                        }
                        
                        if currentStep == directions.count - 1 {
                            withAnimation {
                                imageHeight = 0.5
                            }
                        }
                    }
                    
                    else {
                        action()
                    }
                }
                .background(.green)
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
    var tags: [String]
    
    // Adaptive grid layout
    let columns = [GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10)]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("TAGS")
                .font(.system(size: 14).bold())
                .frame(maxWidth: .infinity, alignment: .center)
            
            // Ingredients Grid
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
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
