//
//  Inventory.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import Foundation

struct Inventory : Codable{
    
    let _id: String
    
    let user : String
    
    let ingredients : [IngredientQte]
}
