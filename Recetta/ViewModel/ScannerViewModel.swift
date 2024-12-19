//
//  ScannerViewModel.swift
//  Recetta
//
//  Created by wicked on 18.12.24.
//

import Foundation
import Combine
import SwiftUI

class ScannerViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var updateSuccess: Bool? = nil
    @Published var progressTrigger: Bool = false

    @Published var isLoadingRecipe: Bool = false
    @Published var updateSuccessRecipe: Bool? = nil
    @Published var progressTriggerRecipe: Bool = false
    @Published var recipes: [Recipe] = []

    // MARK: - Dependencies
    private let inventoryRepository: InventoryRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer
    init(inventoryRepository: InventoryRepository = InventoryRepository()) {
        self.inventoryRepository = inventoryRepository
    }

    // MARK: - Methods

    func updateInventory(id: String, img: MultipartFile	) {
        isLoading = true
        progressTrigger = true

        inventoryRepository.updateInventoryWithImage(id: id, img: img)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                self.progressTrigger = false

                switch completion {
                case .finished:
                    self.updateSuccess = true
                case .failure(let error):
                    print("Error updating inventory: \(error)")
                    self.updateSuccess = false
                }
            }, receiveValue: { _ in
                // Handle successful update
            })
            .store(in: &cancellables)
    }

    func scanRecipe(img: MultipartFile) {
        isLoadingRecipe = true
        progressTriggerRecipe = true

        inventoryRepository.scanRecipe(img: img)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoadingRecipe = false
                self.progressTriggerRecipe = false

                switch completion {
                case .finished:
                    self.updateSuccessRecipe = true
                case .failure(let error):
                    print("Error scanning recipe: \(error)")
                    self.updateSuccessRecipe = false
                }
            }, receiveValue: { [weak self] recipe in
                guard let self = self else { return }
                self.recipes = [recipe]
            })
            .store(in: &cancellables)
    }

    func resetProgressTrigger() {
        progressTrigger = false
    }

    func resetProgressTriggerRecipe() {
        progressTriggerRecipe = false
    }

    func resetRecipes() {
        recipes = []
    }
}
	
struct MultipartFile {
    let data: Data
    let filename: String
    let mimeType: String
}
