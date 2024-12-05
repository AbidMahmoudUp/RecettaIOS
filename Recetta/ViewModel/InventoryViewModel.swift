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
    
    func updateInventoryForRequiredRecipe(userId: String, ingredients: IngredientUpdateDto) {
           Task {
               do {
                   // Create the request body from the passed ingredients
                   let requestBody = ingredients
                   
                   // Call the repository's async startCooking method
                   let inventory = try await repository.startCooking(userId: userId, ingredients: requestBody)
                   
                   // Handle the response (inventory is the result)
                   print("Update Response: \(inventory)")
                   self.errorMessage = nil
               } catch {
                   // Handle errors (network errors, HTTP errors, etc.)
                   let errorMessage: String
                   if let httpError = error as? ApiError {
                       errorMessage = httpError.localizedDescription
                   } else {
                       errorMessage = "Unknown error occurred"
                   }
                   print("Update Error: \(errorMessage)")
                   self.errorMessage = errorMessage
               }
           }
       }
       
       func clearErrorMessage() {
           errorMessage = nil
       }
}
