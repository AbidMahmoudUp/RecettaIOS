//
//  InventoryViewModel.swift
//  Recetta
//
//  Created by wicked on 12.11.24.
//
import Foundation

class InventoryViewModel: ObservableObject {
    @Published var inventory: Inventory?
    @Published var errorMessage: String?

    private let repository: InventoryRepository

    init(repository: InventoryRepository = InventoryRepository()) {
        self.repository = repository
    }

    func fetchInventory(userId: String) async {
        do {
            let inventory: Inventory = try await repository.getInventoryByUserId(userId: userId)
            print("Decoded Inventory: \(inventory)") // Debug
            self.inventory = inventory
        } catch {
            print("Error fetching inventory: \(error)")
            errorMessage = error.localizedDescription
        }
    }
   
    func updateInventory(userId :String,ingredients: IngredientUpdateDto) async {
        do{
            let inventory : Inventory = try await repository.updateInventoryByUserId(userId: userId,ingredients: ingredients)
            print("Decoded Inventory: \(inventory)")
            self.inventory = inventory
            
        }catch {
            print("Error fetching inventory: \(error)")
            errorMessage = error.localizedDescription
        }

    }
    
    func updateInventoryForRequiredRecipe(ingredients : IngredientUpdateDto) {
        //TODO
    }
}
