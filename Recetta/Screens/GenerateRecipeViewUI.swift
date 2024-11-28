import SwiftUI

struct GenerateRecipeViewUI: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var ingredientViewModel: IngredientViewModel

    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    @State private var listIngredientQte: IngredientUpdateDto
    @State private var isSaveButtonActive: Bool = false // For toggling animation
    @State private var isRecipeGenerated: Bool = false // New state for recipe generation status

    private let categories = ["All", "Fruit", "Vegetables", "Meat", "Nuts"]

    init(recipeViewModel: RecipeViewModel, ingredientViewModel: IngredientViewModel, listIngredientQte: IngredientUpdateDto) {
        self.recipeViewModel = recipeViewModel
        self.ingredientViewModel = ingredientViewModel
        self._listIngredientQte = State(initialValue: listIngredientQte)
    }

    var body: some View {
        VStack {
            // Navigation Bar
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color.blue)
                }
                Text("Generate Recipe")
                    .font(.headline)
                    .padding(.leading, 8)
                Spacer()

                // Save button with animated color
                if !listIngredientQte.ingredients.isEmpty {
                    Button(action: {
                        // Generate the recipe
                        Task {
                            await generateRecipe()
                        }
                    }) {
                        Text("Generate")
                            .foregroundColor(isSaveButtonActive ? .blue : .purple)
                            .fontWeight(.bold)
                            .animation(.easeInOut(duration: 1.0), value: isSaveButtonActive)
                    }
                    
                }
            }
            .padding()

            // Search Bar
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Categories
            Text("Categories")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(categories, id: \.self) { category in
                        CategoryTab(text: category, isSelected: selectedCategory == category) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Filtered Ingredients (Display all by default)
            let filteredIngredients = ingredientViewModel.ingredients.filter {
                searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(filteredIngredients, id: \.id) { ingredient in
                        FoodCard(
                            ingredient: ingredient,
                            listOfIngredients: $listIngredientQte.ingredients
                        )
                    }
                }
                .padding()
            }

            Spacer()
        }
        .onAppear {
            // Fetch ingredients when the view appears
            Task {
                await ingredientViewModel.fetchAllIngredients()
            }
            // Start the animation for the Save button
            startSaveButtonAnimation()
        }
    }

    private func generateRecipe() async {
        // Set loading state for UI
        DispatchQueue.main.async {
            isRecipeGenerated = true
        }
        
        await recipeViewModel.generateRecipe(ingredients: listIngredientQte.ingredients)
        
        // Once the recipe is generated, dismiss the view
       // DispatchQueue.main.async {
       //     presentationMode.wrappedValue.dismiss()
       // }
    }

    private func startSaveButtonAnimation() {
        // Toggle the `isSaveButtonActive` state to create an animation loop
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            isSaveButtonActive.toggle()
        }
    }
}

#Preview {
    let mockRecipeViewModel = RecipeViewModel() // Replace with actual mock setup if needed
    let mockIngredientViewModel = IngredientViewModel() // Replace with actual mock setup if needed

    // Add some sample ingredients
    mockIngredientViewModel.ingredients = [
        Ingredient(_id: "1", name: "Apple", image: "Fruit", categorie: "apple.png", unit: ""),
        Ingredient(_id: "2", name: "Carrot", image: "Vegetables", categorie: "carrot.png",unit: ""),
        Ingredient(_id: "3", name: "Chicken", image: "Meat", categorie: "chicken.png",unit: "")
    ]
    let initialIngredientUpdateDto = IngredientUpdateDto(ingredients: [])

    return GenerateRecipeViewUI(
        recipeViewModel: mockRecipeViewModel,
        ingredientViewModel: mockIngredientViewModel,
        listIngredientQte: initialIngredientUpdateDto
    )
}
