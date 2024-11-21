//
//  IngredientViewModel.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation
class IngrediantViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []
    @Published var isLoading: Bool = false

    func fetchAllIngredients() async {
        // Example function to simulate fetching ingredients from a backend or database
        self.isLoading = true
        // Simulate a network call
        await Task.sleep(2 * 1_000_000_000) // Simulate a 2-second delay
        self.ingredients = [
            Ingredient(_id: "1", name: "Tomato",image:"swift", categorie: "Vegetable"),
            Ingredient(_id: "2", name: "Carrot",image:"swift", categorie: "Vegetable")
        ]
        self.isLoading = false
    }
}
