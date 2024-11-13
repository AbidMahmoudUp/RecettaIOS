//
//  BottomNavigationTabComponent.swift
//  Recetta
//
//  Created by wicked on 03.11.24.
//

import SwiftUI

struct BottomNavigationTabItemComponent: View{
    @Binding var selectedTab: Int
    let index: Int
    let label: String
    let icon: String
    
    var isSelected: Bool {
        selectedTab == index
    }
    
    var body: some View {
        Button(action: {
            // Update the selected tab when tapped
            selectedTab = index
        }) {
            
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .orange : .gray)
                if(isSelected)
                {
                    Text( label )
                        .foregroundColor( .orange )
                        .fontWeight( .bold )
                        .fixedSize()
                }
                
            }
            .padding()
                
            .background(
                            // Set background color with opacity only if selected
                            RoundedRectangle(cornerRadius: 2)
                                .fill(isSelected ? Color.orange.opacity(0.1) : Color.clear)
                        )
                        .overlay(
                            // Optional: Add a border if needed
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
                        )
            
        }
    }
}

#Preview {
    struct BottomNavigationTabComponent_Preview: View {
            @State private var selectedTab = 1

            var body: some View {
                BottomNavigationTabItemComponent(selectedTab: $selectedTab, index: 1, label: "Test", icon: "house.fill")
            }
        }
    return BottomNavigationTabComponent_Preview()
}
