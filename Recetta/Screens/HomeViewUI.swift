import SwiftUI


struct HomeViewUI: View {
    @State private var isSidebarVisible: Bool = false
    @State private var animateIcons: Bool = false // Control animation state
    @State private var navigateToGenerateRecipe: Bool = false // Trigger navigation
    @State private var selectedCategory: CategorieHome? = nil
    @State private var searchText: String = ""
    @State private var selectedCategories: Set<CategorieHome> = [] // Track selected categories

    @StateObject private var recipeViewModel = RecipeViewModel()

    let categoryList = [
        CategorieHome(image: "pizza", text: "Fast Food"),
        CategorieHome(image: "main_course", text: "Main Course"),
        CategorieHome(image: "drinks", text: "Drinks")
    ]
    var body: some View {
        NavigationStack { // Ensure we are inside a NavigationStack for navigation
            ZStack {
                // Main content - RecipeListView
                VStack {
                    // Top bar with drawer and fork icons
                    HStack {
                        // Drawer icon on the left
                        Text("Recetta").font(.title).fontWeight(.bold)
                            
                        Spacer() // Pushes the fork icon to the far right
                        
                        // Knife and fork icons with animation
                        ZStack {
                            Image(systemName: "knife")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(animateIcons ? -20 : 0), anchor: .bottomTrailing) // Knife swings
                                .offset(x: animateIcons ? -5 : 0) // Slight lateral movement
                            
                            Image(systemName: "fork.knife")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .rotationEffect(.degrees(animateIcons ? 20 : 0), anchor: .bottomLeading) // Fork swings
                                .offset(x: animateIcons ? 5 : 0) // Slight lateral movement
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true)) {
                                animateIcons.toggle()
                            }
                            // Trigger navigation after the animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { // Adjust for animation duration
                                navigateToGenerateRecipe = true
                            }
                        }
                        .padding()
                    }.padding()
                    
                    // Main content - Recipe list
                    SearchBar(searchText: $recipeViewModel.searchText).padding(8)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(categoryList, id: \.text) { category in
                                CategorieHomeTab(
                                    category: category,
                                    selectedCategories: $recipeViewModel.selectedCategories // Bind to view model's selected categories
                                )
                            }
                        }
                        .padding(.horizontal)
                    }

                    RecipeListView(viewModel: recipeViewModel)
                        .padding(20)
                    
                    Spacer()
                }
                
                // Use NavigationLink to navigate to GenerateRecipeViewUI
                NavigationLink(
                    destination: GenerateRecipeViewUI(
                        recipeViewModel: RecipeViewModel(),
                        ingredientViewModel: IngredientViewModel(),
                        listIngredientQte: IngredientUpdateDto(ingredients: [])
                    ).navigationBarBackButtonHidden(),
                  isActive: $navigateToGenerateRecipe
                )   {
                    EmptyView() // Empty view will be triggered by the navigation link
                }
            }
        }
    }
}

#Preview {
    HomeViewUI()
}


/* SidebarViewComponent(isSidebarVisible: $isSidebarVisible)
     .frame(width: isSidebarVisible ? 40 : 40) // Adjust sidebar width
     .background(Color(.systemGray6).opacity(isSidebarVisible ? 1 : 0)) // Background for sidebar
     .transition(.move(edge: .leading)) // Smooth transition
     .animation(.easeInOut(duration: 0.5), value: isSidebarVisible)
 */
struct CategorieHome: Identifiable ,Equatable , Hashable{
    let id = UUID()
    let image: String // Use the name of the image asset
    let text: String
    static func == (lhs: CategorieHome, rhs: CategorieHome) -> Bool {
            return lhs.text == rhs.text && lhs.image == rhs.image
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(text)
            hasher.combine(image)
        }
}
struct CategorieHomeTab: View {
    let category: CategorieHome
    @Binding var selectedCategories: Set<CategorieHome> // Use a set to track selected categories

    var body: some View {
        HStack(spacing: 8) {
            // Circular image
            Image(category.image)
                .resizable()
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.white))
                .clipShape(Circle())
                .padding(2)

            // Category text
            Text(category.text)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(8)
        .frame(width: 130, height: 40)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(selectedCategories.contains(category) ? Color.orange : Color.orange.opacity(0.3))
        )
        .onTapGesture {
            // Toggle the category selection state
            if selectedCategories.contains(category) {
                selectedCategories.remove(category) // Deselect if already selected
            } else {
                selectedCategories.insert(category) // Select the category
            }
        }
    }
}
struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            // Leading Icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.black)

            // Text Field
            TextField("Search", text: $searchText)
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity) // Make it span the width of the parent
        .frame(height: 48) // Height similar to Jetpack Compose example
        .background(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    searchText.isEmpty ? Color.black : Color.orange, // Border color changes when focused
                    lineWidth: 2
                )
        )
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.clear)
        )
        .padding(.horizontal, 20) // Add space on the sides of the screen
    }
}
