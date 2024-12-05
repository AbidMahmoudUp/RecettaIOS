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

struct IngredientRecipe: Codable, Hashable {
    var ingredient: Ingredient?
    var qte: Int

    enum CodingKeys: String, CodingKey {
        case ingredient
        case qte
    }

    // Custom decoding initializer with additional error handling
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode the ingredient object - this is the key part!
        let ingredientContainer = try container.decodeIfPresent(Ingredient.self, forKey: .ingredient)
        self.ingredient = ingredientContainer

        // Decode qte (handle both String and Int cases)
        if let qteString = try? container.decode(String.self, forKey: .qte) {
            if let intQte = Int(qteString) {
                self.qte = intQte
            } else {
                throw DecodingError.dataCorruptedError(forKey: .qte, in: container, debugDescription: "Unable to convert qte string to integer")
            }
        } else {
            self.qte = try container.decode(Int.self, forKey: .qte)
        }
    }

    // Convenience initializer for manually passing values
    init(ingredient: Ingredient?, qte: Int) {
        self.ingredient = ingredient
        self.qte = qte
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        // Hash ingredient's id (or any unique identifier) and qte
        hasher.combine(ingredient?.id)  // Assuming Ingredient has an `id` property
        hasher.combine(qte)
    }

    // Equatable conformance (Hashable automatically uses this)
    static func ==(lhs: IngredientRecipe, rhs: IngredientRecipe) -> Bool {
        return lhs.ingredient?.id == rhs.ingredient?.id && lhs.qte == rhs.qte
    }
}

