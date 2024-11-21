//
//  Ingredient.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation
struct Ingredient: Identifiable,Codable {
    var id: String { return _id }
    let _id: String
    let name: String
    let image: String
    let categorie: String
}
