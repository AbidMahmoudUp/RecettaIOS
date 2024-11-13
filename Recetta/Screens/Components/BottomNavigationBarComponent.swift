//
//  BottomNavigationBarComponent.swift
//  Recetta
//
//  Created by wicked on 03.11.24.
//

import SwiftUI

struct BottomNavigationBarComponent: View {
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            // Display the content based on the selected tab
            ZStack {
                switch selectedTab {
                case 0:
                    HomeViewUI()
                case 1:
                    ProfileViewUI()
                case 2:
                    FavoriteViewUI()
                case 3:
                    InventoryViewUI()
                default:
                    HomeViewUI()
                }
            }
            Spacer()
            // Custom Tab Bar
            HStack {
                BottomNavigationTabItemComponent(selectedTab: $selectedTab, index: 0, label: "Calls", icon: "phone.fill").frame(maxWidth: .infinity)
                BottomNavigationTabItemComponent(selectedTab: $selectedTab, index: 1, label: "Profile", icon: "person.fill").frame(maxWidth: .infinity)
                BottomNavigationTabItemComponent(selectedTab: $selectedTab, index: 2, label: "Saved", icon: "star.fill").frame(maxWidth: .infinity)
                BottomNavigationTabItemComponent(selectedTab: $selectedTab, index: 3, label: "Saved", icon: "archivebox").frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .frame(maxWidth: .infinity)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
#Preview {
    BottomNavigationBarComponent()
}
