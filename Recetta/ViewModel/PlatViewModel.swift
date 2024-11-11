//
//  PlatViewModel.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation
class PlatViewModel: ObservableObject {
    @Published var plats: [Plat] = []
    
    init() {
        loadPlats()
    }
    
    func loadPlats() {
        // Sample data for now; replace with data loading logic
        let sampleIngredient = Ingredient(id:"",name: "Tomato", image: "tomato.png", category: "Vegetable")
        let ingredientQte = IngridientQte(id:"",ingredient: sampleIngredient, qte: 2)
        
        let samplePlat = Plat(
            id:"",
            name: "Sample Dish",
            description: "A delicious sample dish.",
            cookingTime: "30",
            energy: "250",
            image: "swift",
            rating: 4.5,
            ingredients: [ingredientQte]
        )
        
        plats = [samplePlat,samplePlat]
    }
    
}
