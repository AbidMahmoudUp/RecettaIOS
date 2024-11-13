//
//  ContentView.swift
//  Recetta
//
//  Created by wicked on 03.11.24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isSidebarVisible = true // State to control sidebar visibility

    var body: some View {
        ZStack {
            // Main Content Area
           
              
            BottomNavigationBarComponent()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
