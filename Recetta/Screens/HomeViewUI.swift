import SwiftUI


struct HomeViewUI: View {
    @State private var isSidebarVisible: Bool = false
    @State private var animateIcons: Bool = false // Control animation state
    @State private var navigateToGenerateRecipe: Bool = false // Trigger navigation
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content - RecipeListView
                VStack {
                    // Top bar with drawer and fork icons
                    HStack {
                        // Drawer icon on the left
                        Button(action: {
                            isSidebarVisible.toggle() // Action to toggle the sidebar
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .padding()
                                .font(.title)
                                .foregroundColor(.black)
                        }
                        
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
                    }
                    
                    // Main content - Recipe list
                    RecipeListView()
                        .padding(30)
                    
                    Spacer()
                }
                
               
            }
            // Navigation link to GenerateRecipeViewUI
            .navigationDestination(isPresented: $navigateToGenerateRecipe) {
                GenerateRecipeViewUI(
                    recipeViewModel: RecipeViewModel(),
                    ingredientViewModel: IngredientViewModel(),
                    listIngredientQte: IngredientUpdateDto(ingredients: [])
                ).navigationBarBackButtonHidden()
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
