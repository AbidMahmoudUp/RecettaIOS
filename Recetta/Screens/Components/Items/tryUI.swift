import SwiftUI

struct TryUI: View {
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
                        .frame(width: 10, height: 10)
                        .offset(x:0 , y: 50)
                }
                // Text label
                HStack(spacing: 8) {
                    Text(label)
                        .foregroundColor(Color.black)
                        .fontWeight(isSelected ? .bold : .regular)
                        .fixedSize()
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
        .rotationEffect(.degrees(270)) // Apply rotation to the entire Button view
    }
}

struct TryUIPreview: View {
    @State private var selectedTab = 1

    var body: some View {
        TryUI(selectedTab: $selectedTab, index: 1, label: "food in your inventory")
    }
}

#Preview {
    TryUIPreview()
}
