//
//  Plat.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: String?
    let title: String
    let description: String
    let category: String
    let cookingTime: String
    let energy: String
    let rating: String
    let image: String?
    let ingredients: [IngredientRecipe]
    let instructions: [String]?

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
        case instructions = "instructions"
    }
}



