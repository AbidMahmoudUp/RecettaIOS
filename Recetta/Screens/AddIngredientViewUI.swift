import SwiftUI


struct AddIngredientViewUI: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var inventoryViewModel: InventoryViewModel
    @ObservedObject var ingredientViewModel: IngredientViewModel

    @State private var searchText: String = ""
    @State private var selectedCategory: String = "All"
    @State private var listIngredientQte: IngredientUpdateDto

    private let categories = ["All", "Fruit", "Vegetables", "Meat","Spices"]
    
    init(inventoryViewModel: InventoryViewModel, ingredientViewModel: IngredientViewModel, listIngredientQte: IngredientUpdateDto) {
        self.inventoryViewModel = inventoryViewModel
        self.ingredientViewModel = ingredientViewModel
        self._listIngredientQte = State(initialValue: listIngredientQte)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Navigation Bar with custom back button
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.blue)
                    }
                    Text("Add Ingredient")
                        .font(.headline)
                        .padding(.leading, 8)
                    Spacer()
                    // Dynamically show Save button
                    if !listIngredientQte.ingredients.isEmpty {
                        Button(action: {
                            Task {
                                await inventoryViewModel.updateInventory(
                                    userId: AuthManager.shared.getUserId() ?? "",
                                    ingredients: listIngredientQte
                                )
                                // Optionally dismiss the view after saving
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
                .navigationBarBackButtonHidden(true) // Hide default back button

                // Search Bar
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Categories
                Text("Categories")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 24) {
                        Spacer()
                        ForEach(categories, id: \.self) { category in
                            CategoryTab(text: category, isSelected: selectedCategory == category) {
                                selectedCategory = category
                            }
                        }
                        Spacer()

                    }
                    .padding(.horizontal)
                }

                // Filtered Ingredients (Display all by default)
                let filteredIngredients = ingredientViewModel.ingredients.filter { ingredient in
                            (searchText.isEmpty || ingredient.name.localizedCaseInsensitiveContains(searchText)) &&
                            (selectedCategory == "All" || ingredient.categorie == selectedCategory)
                        }
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(filteredIngredients, id: \.id) { ingredient in
                            FoodCard(
                                ingredient: ingredient,
                                listOfIngredients: $listIngredientQte.ingredients
                            )
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .onAppear {
                // Fetch ingredients when the view appears
                Task {
                    await ingredientViewModel.fetchAllIngredients()
                }
            }
        }
    }
}




struct FoodCard: View {
    let ingredient: Ingredient
    @Binding var listOfIngredients: Set<IngredientRecipe>
    
    @State private var count: Int = 0

    init(
        ingredient: Ingredient,
        listOfIngredients: Binding<Set<IngredientRecipe>>
    ) {
        self.ingredient = ingredient
        _listOfIngredients = listOfIngredients

        if let currentIngredientRecipe = listOfIngredients.wrappedValue.first(where: { $0.ingredient == ingredient }) {
            _count = State(initialValue: currentIngredientRecipe.qte)
        }
    }

   
        
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white) // White background
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4) // Elevation effect
                .padding(8) // Padding around the background

            VStack {
                AsyncImage(url: URL(string: Constants.baseURLPicture + ingredient.image)) { image in
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                } placeholder: {
                    ProgressView()
                }

                Spacer().frame(height: 8)

                // Ingredient Name
                Text(ingredient.name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)

                Spacer().frame(height: 8)

                // Ingredient Category
                Text(ingredient.categorie)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "06402B"))
            }
            .padding(8)
            .frame(width: 180, height: 200) // Adjust width if needed
            .foregroundColor(.black) // Content text color

            // VStack for Quantity Adjustment Controls
            VStack(spacing: 8) {
                if count > 0 {
                    Button(action: decreaseCount) {
                        Image(systemName: "minus")
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                            .background(
                                Color.orange
                                    .clipShape(
                                        RoundedCorner(radius: 8, corners: [.topLeft])
                                    )
                            )
                    }

                    Text("\(count)")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }

                Button(action: increaseCount) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .frame(width: 24, height: 24)
                        .background(
                            Color.orange
                                .clipShape(
                                    RoundedCorner(radius: 8, corners: [.bottomRight])
                                )
                        )
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.orange)
            )
            .animation(.spring(), value: count)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Position at bottom-right
            .padding(8)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding() // Outer padding for ZStack
    }

    

    // MARK: - Action Handlers
    private func decreaseCount() {
        if count > 0 {
            count -= 1
            updateList()
        }
    }

    private func increaseCount() {
        count += 1
        updateList()
    }

    private func updateList() {
            var updatedList = listOfIngredients
            if count > 0 {
                // Update or insert the IngredientRecipe
                if let existingRecipe = updatedList.first(where: { $0.ingredient == ingredient }) {
                    updatedList.remove(existingRecipe) // Remove the old version
                }
                updatedList.insert(IngredientRecipe(ingredient: ingredient, qte: count)) // Add the updated version
            } else {
                // Remove the IngredientRecipe when count is zero
                if let existingRecipe = updatedList.first(where: { $0.ingredient == ingredient }) {
                    updatedList.remove(existingRecipe)
                }
            }
            listOfIngredients = updatedList // Ensure the updated list is reflected
        }
    
}


struct CategoryTab: View {
    let text: String
    let isSelected: Bool
    let onClick: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.orange : Color.clear)
                    .frame(width: 45, height: 45)
                
                Image(systemName: categoryIcon(for: text))
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? .white : Color.orange)
            }
            Text(text)
                .font(.subheadline)
                .foregroundColor(isSelected ? .black : .gray)
        }
        .onTapGesture {
            onClick()
        }
    }
    struct CardView<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            ZStack {
                Color.white
                content
            }
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
    }
    
}
#Preview {
    let mockInventoryViewModel = InventoryViewModel() // Replace with actual mock setup if needed
    let mockIngredientViewModel = IngredientViewModel() // Replace with actual mock setup if needed

    // Add some sample ingredients
    mockIngredientViewModel.ingredients = [
        Ingredient(name: "1", unit: "Apple", image: "Fruit", categorie: "apple.png", id: ""),
        Ingredient(name: "2", unit: "Carrot", image: "Vegetables", categorie: "carrot.png",id: ""),
        Ingredient(name: "3", unit: "Chicken", image: "Meat", categorie: "chicken.png",id: "")
    ]
    let initialIngredientUpdateDto = IngredientUpdateDto(ingredients: [])

    return AddIngredientViewUI(
        inventoryViewModel: mockInventoryViewModel,
        ingredientViewModel: mockIngredientViewModel,
        listIngredientQte: initialIngredientUpdateDto
    )
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)
        let r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let b = Double(hexNumber & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
private func categoryIcon(for category: String) -> String {
       switch category {
       case "All": return "globe"
       case "Fruit": return "applelogo"
       case "Vegetables": return "carrot.fill" // Requires iOS 16+
       case "Meat": return "fork.knife"
       case "Spices": return "leaf"
       default: return "questionmark.circle"
       }
   }
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
