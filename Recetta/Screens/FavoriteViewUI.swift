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
            
            // Display Favorite Recipes in LazyVGrid
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                ForEach(favoriteRecipes.filter { $0.userId == userId }, id: \.self) { recipe in
                    FavoriteCard(recipe: recipe, userId: userId, showDeleteConfirmation: $showDeleteConfirmation, recipeToDelete: $recipeToDelete)
                }
            }
            .padding()
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

struct FavoriteCard: View {
    var recipe: RecipeEntity
    var userId: String
    @Binding var showDeleteConfirmation: Bool
    @Binding var recipeToDelete: RecipeEntity?
    
    var body: some View {
        ElevatedCard(recipe: recipe, userId: userId, showDeleteConfirmation: $showDeleteConfirmation, recipeToDelete: $recipeToDelete)
    }
}

struct ElevatedCard: View {
    var recipe: RecipeEntity
    var userId: String
    private let baseURL = "https://fdd2-197-22-195-235.ngrok-free.app/uploads"
    @Binding var showDeleteConfirmation: Bool
    @Binding var recipeToDelete: RecipeEntity?
    
    var body: some View {
        VStack {
            // Safely unwrap recipe.image
            if let imageUrl = recipe.image, let url = URL(string: baseURL + imageUrl) {
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
            
            // Recipe title
            Text(recipe.title ?? "Unknown Recipe")
                .fontWeight(.bold)
                .padding(.top, 8)
                .foregroundColor(.black)
            
            // Recipe description (shortened)
            Text(recipe.descriptionRecipe ?? "No description available")
                .font(.subheadline)
                .lineLimit(2)
                .padding(.horizontal, 8)
                .foregroundColor(.gray)
            
            // Recipe rating
            HStack {
                Text(String(format: "Rating: %.1f", recipe.rating ?? 0.0))
                    .font(.caption)
                    .foregroundColor(.orange)
                Spacer()
                Button(action: {
                    // Set the recipe to delete and show the confirmation alert
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
