import SwiftUI

struct InventoryViewUI: View {
    @StateObject var inventoryViewModel = InventoryViewModel()
    @State private var isRefreshing = false
    @State private var navigateToAddIngredient = false
    @State private var initialIngredientUpdateDto = IngredientUpdateDto(ingredients: [])
    @State private var isSelectionMode = false
    @State private var selectedIngredients: [String: Int] = [:]
    @State private var navigateToRecipeList = false
    @State private var isLoading = false
    @State private var progress: Float = 0.0
    @State private var showError = false
    @State private var generatedRecipes: [Recipe] = []


    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top bar with navigation and title
                HStack {
                    Text("Food Manager")
                        .font(.headline)
                        .padding(.leading, 8)
                    Spacer()
                    Image(systemName: "camera.viewfinder")
                        .font(.title)
                        .padding(.trailing, 16)
                        .onTapGesture {
                            // Navigate to scan ingredient screen
                        }
                }
                .padding()
                .background(Color.white)
                
                HStack {
                    if isSelectionMode {
                        Button(action: {
                            // Exit selection mode
                            isSelectionMode = false
                            selectedIngredients.removeAll()
                        }) {
                            Text("Done")
                                .font(.headline)
                                .padding(.leading, 16)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                        Button(action: {
                            // Prepare IngredientRecipe list
                            let ingredientRecipes = selectedIngredients.map { key, value in
                                IngredientRecipe(ingredient: inventoryViewModel.inventory?.ingredients.first(where: { $0.ingredient.id == key })?.ingredient, qte: value)
                            }
                            // Pass the ingredient list to the next view
                            initialIngredientUpdateDto.ingredients = Set(ingredientRecipes)
                            Task{await generateRecipeOnBackground()}
                        }) {
                            Text("Generate")
                                .font(.headline)
                                .padding(.trailing, 16)
                        }
                    } else {
                        Text("Ingredients")
                            .font(.headline)
                            .padding(.leading, 16)
                        Spacer()
                        Text("Add ingredient")
                            .font(.headline)
                            .padding(.trailing, 16)
                            .foregroundColor(Color.orange)
                            .onTapGesture {
                                // Set the state to navigate
                                navigateToAddIngredient = true
                            }
                    }
                }

                // NavigationLink to AddIngredientViewUI when Add Ingredient is tapped
                NavigationLink(destination: AddIngredientViewUI(
                    inventoryViewModel: inventoryViewModel,
                    ingredientViewModel: IngredientViewModel(), listIngredientQte: initialIngredientUpdateDto // pass the appropriate ViewModel
                ).navigationBarBackButtonHidden(), isActive: $navigateToAddIngredient) {
                }

                // Display inventory or empty state
                if let inventory = inventoryViewModel.inventory {
                    if inventory.ingredients.isEmpty {
                                            NoIngredientSection(
                                                image: "crying_tomato",
                                                title: "No Ingredients Found",
                                                description: "We couldn't find any ingredients in your inventory. Add some to get started!"
                                            )
                    } else {
                        
                        VStack {
                            // Pull-to-refresh feature
                            ScrollView {
                                VStack {
                                    ForEach(inventory.ingredients, id: \.ingredient.id) { ingredientQte in
                                        IngredientCardUIViewComponent(
                                            ingredient: ingredientQte,
                                            isSelectionMode: $isSelectionMode,
                                            selectedIngredients: $selectedIngredients
                                        )
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                    }
                                }
                                .refreshable {
                                    // Trigger the refresh action
                                    await refreshInventory()
                                }
                            }
                        }
                    } } else if let errorMessage = inventoryViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Loading inventory...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .background(Color.white)
            .onAppear {
                Task {
                    if let userId = AuthManager.shared.getUserId() {
                        await inventoryViewModel.fetchInventory(userId: userId)
                    }
                }
            }
            .overlay(
                            RecipeGenerationLoadingView(progress: $progress, isLoading: $isLoading)
                                .edgesIgnoringSafeArea(.all)
                        )
            NavigationLink(
                       destination: GeneratedRecipeListViewUI(recipes: generatedRecipes),
                       isActive: $navigateToRecipeList
                   ) {
                       EmptyView()
                   }

        }
    }

    // Refresh action
    private func refreshInventory() async {
        Task{
            if let userId = AuthManager.shared.getUserId() {
                // Update the inventory
                await inventoryViewModel.fetchInventory(userId: userId)
            }
        }
    }

    // Generate recipes in background
      private func generateRecipeOnBackground() async {
          isLoading = true
          progress = 0.0
          let recipeViewModel = RecipeViewModel()
          let maxLoadingTime: TimeInterval = 30.0
          let startTime = Date()

          do {
              try await recipeViewModel.generateRecipe(ingredients: initialIngredientUpdateDto.ingredients)

              while isLoading {
                  let elapsed = Date().timeIntervalSince(startTime)
                  if elapsed >= maxLoadingTime {
                      isLoading = false
                      showError = recipeViewModel.generatedRecipes.isEmpty
                      break
                  }

                  if !recipeViewModel.generatedRecipes.isEmpty {
                      DispatchQueue.main.async {
                          self.generatedRecipes = recipeViewModel.generatedRecipes
                          self.isLoading = false
                          self.navigateToRecipeList = true
                      }
                      break
                  }

                  progress = Float(elapsed / maxLoadingTime)
                  try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
              }
          } catch {
              isLoading = false
              print("Error generating recipes: \(error.localizedDescription)")
          }
      }
}

struct NoIngredientSection: View {
    let image: String // Image name from assets
    let title: String
    let description: String

    var body: some View {
        VStack {
            Spacer() // Push content to the center
                .frame(height: 175) // Equivalent spacing at the top
            
            Image(image) // Replace with your asset name
                .resizable()
                .frame(width: 89, height: 94)
                .padding(.bottom, 12) // Space below the image
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 12) // Space below the title
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 112 / 255, green: 108 / 255, blue: 108 / 255))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity) // Make the column take the full width
        .padding() // Add padding around the content
    }
}
#Preview {
    InventoryViewUI()
}
