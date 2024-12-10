import SwiftUI
import Combine

struct GenerateRecipeViewUI: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var recipeViewModel: RecipeViewModel
    @ObservedObject var ingredientViewModel: IngredientViewModel
    
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    @State private var listIngredientQte: IngredientUpdateDto
    @State private var isSaveButtonActive: Bool = false // For toggling animation
    @State private var progress: Float = 0.0
    @State private var isLoading: Bool = false
    @State private var isNavigatingToRecipes: Bool = false
    @State private var showError: Bool = false

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
                
                if !listIngredientQte.ingredients.isEmpty {
                    Button(action: {
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
            
            // Search Bar and Categories
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
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
            
            // Filtered Ingredients
            let filteredIngredients = ingredientViewModel.ingredients.filter {
                (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)) &&
                (selectedCategory == "All" || $0.categorie == selectedCategory)
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
        .overlay {
            if isLoading {
                RecipeGenerationLoadingView(progress: $progress, isLoading: $isLoading)
            } else if showError {
                Text("No recipes found.")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            }
        }

        .onAppear {
            Task {
                await ingredientViewModel.fetchAllIngredients()
            }
        }
        .onReceive(Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()) { _ in
            isSaveButtonActive.toggle()
        }
        .background(
            NavigationLink(
                destination: GeneratedRecipeListViewUI(recipes: recipeViewModel.generatedRecipes),
                isActive: $isNavigatingToRecipes
            ) { EmptyView() }
        )

    }
    
    private func generateRecipe() async {
        isLoading = true  // Show loading animation
        progress = 0.0    // Reset progress
        recipeViewModel.generatedRecipes = []  // Clear previous data

        // Start a timer for 30 seconds
        let maxLoadingTime: TimeInterval = 30.0
        let startTime = Date()

        do {
            // Start recipe generation asynchronously
            try await recipeViewModel.generateRecipe(ingredients: listIngredientQte.ingredients)

            // Periodically update progress
            while isLoading {
                let elapsed = Date().timeIntervalSince(startTime)
                if elapsed >= maxLoadingTime {
                    // Stop after 30 seconds if no recipes are found
                    DispatchQueue.main.async {
                        isLoading = false
                        showError = recipeViewModel.generatedRecipes.isEmpty
                    }
                    break
                }

                // If recipes are ready, stop loading and navigate
                if !recipeViewModel.generatedRecipes.isEmpty {
                    DispatchQueue.main.async {
                        isLoading = false
                        isNavigatingToRecipes = true
                    }
                    break
                }

                // Update progress
                DispatchQueue.main.async {
                    progress = Float(elapsed / maxLoadingTime)
                }
                try await Task.sleep(nanoseconds: 499_999_999)  // 0.5 seconds
            }
        } catch {
            // Handle API errors
            DispatchQueue.main.async {
                isLoading = false
                print("Error generating recipes: \(error.localizedDescription)")
            }
        }
    }


    
    private func generateRecipeOnBackground() async {
        do {
            // Make the actual API call or perform background work to generate the recipe
            await recipeViewModel.generateRecipe(ingredients: listIngredientQte.ingredients)
            
            
            
            } catch {
            // Handle error in generating the recipe
            print("Error in recipe generation: \(error)")
        }
    }
}

struct GeneratedRecipeListViewUI: View {
    let recipes: [Recipe]
    
    var body: some View {
        if recipes.isEmpty {
            VStack {
                Text("No recipes found.")
                    .font(.title)
                    .padding()
                Image("not_found_asset")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }
        } else {
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(recipes, id: \.id) { recipe in
                        NavigationLink(destination: RecipeViewUI(recipe: recipe)) {
                            
                            RecipeCard(recipe: recipe)
                        }}
                }
                .padding()
            }
        }
    }
}

struct RecipeCard: View {
    let recipe: Recipe
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: Constants.baseURLPicture + (recipe.image ?? ""))) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
            } placeholder: {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)            }
           
            Text(recipe.title)
                .font(.headline)
                .multilineTextAlignment(.center)
            HStack {
                Text("\(recipe.cookingTime) min")
                    .font(.subheadline)
                Spacer()
                Text("\(recipe.energy) kcal")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
