import SwiftUI

struct SidebarViewComponent: View {
    @Binding var isSidebarVisible: Bool
    @State private var isSelected = 1

    var body: some View {
        HStack(spacing:0){
            ZStack {
                // Background color for the entire sidebar
                Color(.systemGray6)
                    .opacity(isSidebarVisible ? 1 : 0) // Adjust opacity based on visibility
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 0.2), value: isSidebarVisible)
                
                VStack(spacing: 0) {
                    // Menu Icon (always visible at the top)
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isSidebarVisible.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle()) // Remove default button click animation
                    
                    Spacer().frame(height: 40)       // Spacer to separate menu icon from items
                    
                    // Sidebar items (only visible when isSidebarVisible is true)
                    VStack(alignment: .center, spacing: 16) {
                        if isSidebarVisible {
                            SideBarItemComponent(selectedTab: $isSelected, index: 1, label: "Home")
                                .transition(.move(edge: .leading).combined(with: .opacity))
                            SideBarItemComponent(selectedTab: $isSelected, index: 0, label: "Profile")
                                .transition(.move(edge: .leading).combined(with: .opacity))
                            SideBarItemComponent(selectedTab: $isSelected, index: 2, label: "Settings")
                                .transition(.move(edge: .leading).combined(with: .opacity))
                        }
                    }
                    .frame(width: isSidebarVisible ? 40 : 40) // Adjust width when visible
                    .animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
                    
                    Spacer() // Pushes sidebar items to the top when isSidebarVisible is false
                }
            }
            .frame(width: isSidebarVisible ? 40 : 40, alignment: .leading) // Adjusted frame width for sidebar
            .animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
        }
    }
}


struct SidebarViewComponent_Previews: PreviewProvider {
    @State static private var isSidebarVisible = true

    static var previews: some View {
        SidebarViewComponent(isSidebarVisible: $isSidebarVisible)
            .previewLayout(.sizeThatFits)
            .padding()
            .previewDisplayName("Sidebar Preview")
    }
}
