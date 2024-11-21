//
//  PlatRepository.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import Foundation

class RecipeRepository {
    private let service: RecipeServiceApi

    init(service: RecipeServiceApi = RecipeServiceApi()) {
        self.service = service
    }

    func getRecipeByRecipeId(recipeId: String) async throws -> Recipe {
        try await service.fetchRecipeById(recipeId: recipeId)
    }
    func getRecipes() async throws -> [Recipe] {
        try await service.fetchRecipes()
    }
}
