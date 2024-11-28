//
//  PlatViewModel.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

class RecipeViewModel: ObservableObject {
    
    @Published var recipe: Recipe?
    @Published var recipesList: [Recipe] = []
    @Published var errorMessage: String?
    @Published var generatedRecipes: [Recipe] = []
    @Published var isLoading: Bool = false

    private let repository: RecipeRepository
    
    init(repository: RecipeRepository = RecipeRepository()) {
        self.repository = repository
    }
    
    
    
    
    func fetchRecipeById(recipeId: String) async {
        do {
            let fetchedRecipe = try await repository.getRecipeByRecipeId(recipeId: recipeId)
            print("Fetched Recipe: \(fetchedRecipe)")
            self.recipe = fetchedRecipe
        } catch {
            print("Error fetching recipe: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch recipe: \(error.localizedDescription)"
        }
    }
    
   
    
    func fetchRecipes() async {
        do {
            let fetchedRecipes = try await repository.getRecipes()
            print("Fetched Recipes: \(fetchedRecipes)") // Debug log
            self.recipesList = fetchedRecipes
        } catch {
            print("Error fetching recipes: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch recipes: \(error.localizedDescription)"
        }
    }
    func generateRecipe(ingredients: Set<IngredientRecipe>) async {
        // Update UI state on main thread
        DispatchQueue.main.async {
            self.isLoading = true
        }
        defer {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }

        // Prepare the request data
        let dto = IngredientUpdateDto(ingredients: ingredients)
        do {
            // Make the API call
            let recipes = try await repository.generateRecipe(request: dto)

            // Make sure UI updates happen on the main thread
            DispatchQueue.main.async {
                self.generatedRecipes = recipes
            }
        } catch {
            // Handle errors and ensure UI is updated on main thread
            DispatchQueue.main.async {
                self.generatedRecipes = []
            }
            print("Error generating recipes: \(error.localizedDescription)")
        }
    }
    
}
    
    
    
    
  
