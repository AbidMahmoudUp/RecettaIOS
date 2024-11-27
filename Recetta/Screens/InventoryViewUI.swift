import SwiftUI

struct InventoryViewUI: View {
    @StateObject var inventoryViewModel = InventoryViewModel()
    @State private var isRefreshing = false

    // State variable to manage navigation
    @State private var navigateToAddIngredient = false
    @State private var initialIngredientUpdateDto = IngredientUpdateDto(ingredients: [])
    var body: some View {
        NavigationStack {  // Wrap the entire view with a NavigationStack
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
                .background(Color.white)
                
                HStack {
                    Text("Ingredients")
                        .font(.headline)
                        .padding(.leading, 16)
                    Spacer()
                    // NavigationLink to AddIngredientViewUI when Add Ingredient is tapped
                    NavigationLink(destination: AddIngredientViewUI(
                        inventoryViewModel: inventoryViewModel,
                        ingredientViewModel: IngredientViewModel(), listIngredientQte: initialIngredientUpdateDto // pass the appropriate ViewModel
                    ).navigationBarBackButtonHidden(), isActive: $navigateToAddIngredient) {
                        Text("Add ingredient")
                            .font(.headline)
                            .padding(.trailing, 16)
                            .foregroundColor(Color.orange)
                            .onTapGesture {
                                // Set the state to navigate
                                navigateToAddIngredient = true
                            }
                    }
                }

                // Display inventory or empty state
                if let inventory = inventoryViewModel.inventory {
                    VStack {
                        // Iterate over the array of ingredients
                        ScrollView {
                            ForEach(inventory.ingredients, id: \.ingredient.id) { ingredientQte in
                                IngredientCardUIViewComponent(ingredient: ingredientQte)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            }
                        }
                    }
                } else if let errorMessage = inventoryViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    Text("Loading inventory...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
            }
            .background(Color.white)
            .onAppear {
                Task {
                    if let userId = AuthManager.shared.getUserId() {
                        await inventoryViewModel.fetchInventory(userId: userId)
                    }
                }
            }
        }
    }
}

#Preview {
    InventoryViewUI()
}
