//
//  RecipeViewModel.swift
//  Recetta
//
//  Created by wicked on 21.11.24.
//

import Foundation

class RecipeServiceApi {
    func fetchRecipeById(recipeId: String) async throws -> Recipe {
        try await ApiClient.shared.request(endpoint: "plat/\(recipeId)", method: .GET)
        
    }
    
    func fetchRecipes() async throws -> [Recipe] {
        try await ApiClient.shared.request(endpoint: "plat", method: .GET)
        
    }
    
    
    func generateRecipe(request: IngredientUpdateDto) async throws -> [Recipe] {
 
        let response: [Recipe] = try await ApiClient.shared.request(
              endpoint: "generative-ia",
              method: .POST,
              body: request 
          )
            return response
    }
    
    func addRecipe(recipe : [Recipe]) async throws -> [Recipe]{
        let response : [Recipe] = try await ApiClient.shared.request(endpoint: "plat", method: .POST , body: recipe)
        return response
        
    }
    
    

}
