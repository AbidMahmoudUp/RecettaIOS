import SwiftUI
import CoreData

struct FavoriteViewUI: View {
    @State private var userId: String = "" // Declare userId as state
    @State private var showDeleteConfirmation: Bool = false // State for the confirmation alert
    @State private var recipeToDelete: RecipeEntity? // State to track the recipe to delete
    
    // FetchRequest to get data from Core Data based on userId
    @FetchRequest(
        entity: RecipeEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.title, ascending: true)],
        predicate: nil
    ) var favoriteRecipes: FetchedResults<RecipeEntity>
    
    var body: some View {
        VStack {
            // Title and Back Button
            HStack {
                Spacer()
                Text("Favorite List")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            if favoriteRecipes.filter({ $0.userId == userId }).isEmpty {
                // Display the "No Favorites" section
                NoFavoriteSection(
                    image: "dish",
                    title: "No Favorites Yet",
                    description: "Your favorite recipes will appear here. Start adding some delicious recipes!"
                )
            } else {
                // Display Favorite Recipes in LazyVGrid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(favoriteRecipes.filter { $0.userId == userId }, id: \.self) { recipe in
                        FavoriteCard(recipe: recipe, userId: userId, showDeleteConfirmation: $showDeleteConfirmation, recipeToDelete: $recipeToDelete)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Fetch the userId when the view appears
            self.userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete this recipe from your favorites?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let recipe = recipeToDelete {
                        deleteRecipe(recipe: recipe)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func deleteRecipe(recipe: RecipeEntity) {
        let context = recipe.managedObjectContext
        context?.delete(recipe)
        
        do {
            try context?.save()
            print("Recipe removed from favorites")
        } catch {
            print("Failed to remove recipe: \(error.localizedDescription)")
        }
    }
}

struct NoFavoriteSection: View {
    let image: String // Image name from assets
    let title: String
    let description: String

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 175) // Equivalent spacing at the top
            
            Image(image) // Replace with your asset name
                .resizable()
                .frame(width: 89, height: 94)
                .padding(.bottom, 12) // Space below the image
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(.bottom, 12) // Space below the title
            
            Text(description)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 112 / 255, green: 108 / 255, blue: 108 / 255))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct FavoriteCard: View {
    var recipe: RecipeEntity
    var userId: String
    @Binding var showDeleteConfirmation: Bool
    @Binding var recipeToDelete: RecipeEntity?
    
    var body: some View {
        NavigationLink(destination: RecipeViewUI(recipe: convertToRecipe(recipe))) {
            ElevatedCard(recipe: recipe, userId: userId, showDeleteConfirmation: $showDeleteConfirmation, recipeToDelete: $recipeToDelete)
        }
        
        
    }
    private func convertToRecipe(_ recipeEntity: RecipeEntity) -> Recipe {
        return Recipe(
            id: recipeEntity.id ?? "",
            title: recipeEntity.title ?? "",
            description: recipeEntity.descriptionRecipe ?? "",
            category: recipeEntity.category ?? "",
            cookingTime: recipeEntity.cookingtime ?? "", // Add this if the field exists in RecipeEntity
            energy: recipeEntity.energy ?? "", // Add this if the field exists in RecipeEntity
            rating: recipeEntity.rating ?? "0.0",
            image: recipeEntity.image ?? "",
            ingredients: [] ,// Populate as needed based on your data model
            instructions: [""] // Add instructions if required and available
        )
    }

}
struct ElevatedCard: View {
    var recipe: RecipeEntity
    var userId: String
    @Binding var showDeleteConfirmation: Bool
    @Binding var recipeToDelete: RecipeEntity?
    
    var body: some View {
        VStack {
            if let imageUrl = recipe.image, let url = URL(string: Constants.baseURLPicture + imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(height: 150)
                .clipped()
            } else {
                Color.gray
                    .frame(height: 150)
                    .clipped()
            }
            
            Text(recipe.title ?? "Unknown Recipe")
                .fontWeight(.bold)
                .padding(.top, 8)
                .foregroundColor(.black)
            
            Text(recipe.descriptionRecipe ?? "No description available")
                .font(.subheadline)
                .lineLimit(2)
                .padding(.horizontal, 8)
                .foregroundColor(.gray)
            
            HStack {
                Text(String(format: "Rating: %.1f", recipe.rating ?? 0.0))
                    .font(.caption)
                    .foregroundColor(.orange)
                Spacer()
                Button(action: {
                    recipeToDelete = recipe
                    showDeleteConfirmation = true
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(radius: 8)
    }
}

#Preview {
    FavoriteViewUI()
}
