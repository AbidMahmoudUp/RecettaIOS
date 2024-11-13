import SwiftUI

struct HomeViewUI: View {
    @State private var isSidebarVisible: Bool = false

    var body: some View {
        ZStack(alignment: .leading) {
            // Main content - List of plats
            PlatListView().padding(30)

            // Sidebar overlay
            SidebarViewComponent(isSidebarVisible: $isSidebarVisible)
                .frame(width: isSidebarVisible ? 40 : 40) // Adjust sidebar width
                .background(Color(.systemGray6).opacity(isSidebarVisible ? 1 : 0)) // Background for sidebar
                .transition(.move(edge: .leading)) // Smooth transition
                .animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
        }
    }
}

#Preview {
    HomeViewUI()
}
