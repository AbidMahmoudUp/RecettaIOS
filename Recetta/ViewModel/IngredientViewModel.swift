//
//  IngredientViewModel.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation
class IngredientViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: IngredientRepository

    init(repository: IngredientRepository = IngredientRepository()) {
        self.repository = repository
    }
    func fetchAllIngredients() async {
        do {
            let ingredients: [Ingredient] = try await repository.getingredients()
            print("Decoded Ingredients: \(ingredients)") // Debug
            self.ingredients = ingredients
        } catch {
            print("Error fetching Ingredients: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}
