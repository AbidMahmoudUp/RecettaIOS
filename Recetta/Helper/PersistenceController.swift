//
//  PersistenceController.swift
//  Recetta
//
//  Created by wicked on 05.12.24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Recetta") // Ensure the name matches your `.xcdatamodeld` file
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
    }
}
