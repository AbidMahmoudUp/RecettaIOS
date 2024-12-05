//
//  RecettaApp.swift
//  Recetta
//
//  Created by wicked on 03.11.24.
//

import SwiftUI

@main
struct RecettaApp: App {
    @StateObject private var appState = AppState()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SplashScreenViewUI()
                .environmentObject(appState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
