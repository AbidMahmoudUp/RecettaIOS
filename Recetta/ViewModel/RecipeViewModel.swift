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
    
    func generateRecipe(ingredients : Set<IngredientRecipe> )
    {
        //TODO
    }
    
}
    
    
    
    
  
