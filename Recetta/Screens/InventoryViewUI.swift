import SwiftUI

struct InventoryViewUI: View {
    @StateObject var viewModel = IngrediantViewModel() // ViewModel for managing ingredients
    @State private var isRefreshing = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top bar with navigation and title
            HStack {
                Button(action: {
                    // Navigate back action
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .foregroundColor(Color.blue)
                        .font(.title)
                }
                Text("Food Manager")
                    .font(.headline)
                    .padding(.leading, 8)
                Spacer()
                Image(systemName: "camera.viewfinder")
                    .font(.title)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        // Navigate to scan ingredient screen
                    }
            }
            .padding()
            .background(Color.white) // Ensure the background is white for the top bar

            // Ingredient count and Add button
            HStack {
                Text("Ingredients (\(viewModel.ingredients.count))")
                    .font(.subheadline)
                    .padding()
                Spacer()
                Text("+ Add item")
                    .foregroundColor(Color.orange)
                    .onTapGesture {
                        // Navigate to AddIngredient view
                    }
                    .padding(12)
            }
            .background(Color.white) // Ensure the background is white for this section

            // List or "No ingredients" message
            if viewModel.ingredients.isEmpty {
                Text("No ingredients available")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 16)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                // Pull to refresh feature
                List {
                    ForEach(viewModel.ingredients) { ingredient in
                        IngredientCardUIViewComponent(ingredient: ingredient)
                            .frame(maxWidth: .infinity) // Ensure card takes full width
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden) 
                    }
                }.padding(0)
                .refreshable {
                    // Call function to refresh ingredients
                    await viewModel.fetchAllIngredients()
                }
                .listStyle(PlainListStyle()) // Remove any extra styling from the List
            }

            Spacer()
        }
        .background(Color.white).padding(0) // Ensure the entire background is white
        .onAppear {
            Task {
                await viewModel.fetchAllIngredients() // Load ingredients initially
            }
        }
    }
}

#Preview {
    InventoryViewUI()
}
