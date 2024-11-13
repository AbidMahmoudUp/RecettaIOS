import SwiftUI

struct SideBarItemComponent: View {
    @Binding var selectedTab: Int
    let index: Int
    let label: String
    
    var isSelected: Bool {
        selectedTab == index
    }
    
    var body: some View {
        Button(action: {
            // Update the selected tab when tapped
            selectedTab = index
        }) {
            ZStack {
                // Circle centered, partially outside the button
                if isSelected {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 70, height: 70)
                        .offset(x:0, y: 31)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 9, height: 10)
                        .offset(x:0 , y: 45)
                }
                // Text label
                HStack(spacing: 8) {
                    Text(label)
                        .foregroundColor(Color.black)
                        .fontWeight(isSelected ? .bold : .regular)
                        .fixedSize()
                        .font(.system(size: 14))
                        
                }
                .padding()
                .background(
                    // Set background color with opacity only if selected
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    // Optional: Add a border if needed
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray6), lineWidth: 2)
                )
            }
        }
        .rotationEffect(.degrees(270))
        
    }


}

struct SideBarItemComponentPreview: View {
    @State private var selectedTab = 1

    var body: some View {
        SideBarItemComponent(selectedTab: $selectedTab, index: 1, label: "food in your inventory")
        
    }
}

#Preview {
    SideBarItemComponentPreview()
}
