//
//  Plat.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: String
    let title: String  // Map from "title" in JSON to "name" in your model
    let description: String
    let category: String
    let cookingTime: String
    let energy: String
    let rating: String  // Rating is a string in the JSON, you can convert it to Double if needed
    let image: String? // Handle image in case it's not always present
    let ingredients: [IngredientRecipe]
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "title"
        case description = "description"
        case category = "category"
        case cookingTime = "cookingTime"
        case energy = "energy"
        case rating = "rating"
        case image = "image"
        case ingredients = "ingredients"
    }
}

struct IngredientRecipe: Codable {
    var id: String { ingredient?.id ?? "" }  // To use as the id for ForEach
    var ingredient: Ingredient?
    var qte: Int
    
    enum CodingKeys: String, CodingKey {
        case ingredient = "ingredient"
        case qte = "qte"
    }
}

