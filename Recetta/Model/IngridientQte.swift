//
//  IngridientQte.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation
struct IngredientQte: Codable ,Hashable {
    let ingredient: Ingredient
    let qte: Double
    let date : String
}

struct IngredientRecipe: Codable ,Hashable {
    var id: String { ingredient?.id ?? "" }
    var ingredient: Ingredient?
    var qte: Int
    
    enum CodingKeys: String, CodingKey {
        case ingredient = "ingredient"
        case qte = "qte"
    }
}
