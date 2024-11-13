//
//  Plat.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

struct Plat: Identifiable {
    let id: String
    let name: String
    let description: String
    let cookingTime: String
    let energy: String
    let image: String
    let rating: Double
    let ingredients: [IngridientQte]
}
