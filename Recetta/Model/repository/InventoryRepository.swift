//
//  InventoryRepository.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import Foundation
import Combine

class InventoryRepository {
    private let service: InventoryServiceApi

    init(service: InventoryServiceApi = InventoryServiceApi()) {
        self.service = service
    }

    
    
    func getInventoryByUserId(userId: String) async throws -> Inventory {
        try await service.fetchInventoryByUserId(userId: userId)
    }
    
    
    
    func updateInventoryByUserId(userId : String,ingredients: IngredientUpdateDto) async throws ->Inventory
    {
        try await service.updateInventoryByUserId(userId: userId, ingredients: ingredients)
    }
    
    
    
    func startCooking(userId: String , ingredients : IngredientUpdateDto) async throws ->Inventory
    {
        try await service.startCooking(userId: userId, ingredients: ingredients)
    }
    
    func updateInventoryWithImage(id: String, img: MultipartFile) -> AnyPublisher<Void, Error> {
          Future { promise in
              Task {
                  do {
                      try await self.service.updateInventoryWithImage(userId: id, file: img)
                      promise(.success(()))
                  } catch {
                      promise(.failure(error))
                  }
              }
          }
          .eraseToAnyPublisher()
      }

      func scanRecipe(img: MultipartFile) -> AnyPublisher<Recipe, Error> {
          Future { promise in
              Task {
                  do {
                      if let recipe = try await self.service.scanRecipe(file: img) {
                          promise(.success(recipe))
                      } else {
                          promise(.failure(ApiError.decodingError))
                      }
                  } catch {
                      promise(.failure(error))
                  }
              }
          }
          .eraseToAnyPublisher()
      }

}
