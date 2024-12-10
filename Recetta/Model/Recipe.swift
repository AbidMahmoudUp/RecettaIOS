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
    init(id: String?, title: String, description: String, category: String, cookingTime: String, energy: String, rating: String, image: String?, ingredients: [IngredientRecipe], instructions: [String]?) {
          self.id = id
          self.title = title
          self.description = description
          self.category = category
          self.cookingTime = cookingTime
          self.energy = energy
          self.rating = rating
          self.image = image
          self.ingredients = ingredients
          self.instructions = instructions
      }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        cookingTime = try container.decode(String.self, forKey: .cookingTime) // Directly decode as String
        energy = try container.decode(String.self, forKey: .energy)           // Directly decode as String
        rating = try container.decode(String.self, forKey: .rating)           // Directly decode as String
        image = try container.decodeIfPresent(String.self, forKey: .image)
        ingredients = try container.decode([IngredientRecipe].self, forKey: .ingredients)
        instructions = try container.decodeIfPresent([String].self, forKey: .instructions)
    }
}



