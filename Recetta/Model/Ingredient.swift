//
//  Ingredient.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation
struct Ingredient: Identifiable,Codable,Hashable{
    let name: String
       let unit: String
       let image: String
       let categorie: String
       let id: String?
       
       enum CodingKeys: String, CodingKey {
           case name
           case unit
           case image
           case categorie
           case id = "_id"  // Map _id to id
       }
}

struct IngredientUpdateDto:Codable , Hashable{
    
    var ingredients: Set<IngredientRecipe>
    
}
