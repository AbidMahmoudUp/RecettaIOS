import SwiftUI
class RecipeViewModel: ObservableObject {
    
    @Published var recipe: Recipe?
    @Published var recipesList: [Recipe] = []
    @Published var errorMessage: String?
    @Published var generatedRecipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var progress: Float = 0.0

    private let repository: RecipeRepository
    
    init(repository: RecipeRepository = RecipeRepository()) {
        self.repository = repository
    }
    
    // Fetch a specific recipe by ID
    func fetchRecipeById(recipeId: String) async {
        do {
            let fetchedRecipe = try await repository.getRecipeByRecipeId(recipeId: recipeId)
            print("Fetched Recipe: \(fetchedRecipe)")
            self.recipe = fetchedRecipe
        } catch {
            print("Error fetching recipe: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch recipe: \(error.localizedDescription)"
        }
    }
    
    // Fetch all recipes
    func fetchRecipes() async {
        do {
            let fetchedRecipes = try await repository.getRecipes()
            print("Fetched Recipes: \(fetchedRecipes)") // Debug log
            self.recipesList = fetchedRecipes
        } catch {
            print("Error fetching recipes: \(error.localizedDescription)")
            self.errorMessage = "Failed to fetch recipes: \(error.localizedDescription)"
        }
    }

    func generateRecipe(ingredients: Set<IngredientRecipe>) async {
        print("generateRecipe called with ingredients: \(ingredients)")
        DispatchQueue.main.async {
            self.isLoading = true
            print("Set isLoading to true")
        }
        
        let dto = IngredientUpdateDto(ingredients: ingredients)
        do {
            print("About to call repository.generateRecipe...")
            let fetchedRecipes = try await repository.generateRecipe(request: dto)
            DispatchQueue.main.async {
                print("Fetched recipes: \(fetchedRecipes)")
                self.generatedRecipes = fetchedRecipes
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("Error generating recipes: \(error.localizedDescription)")
                self.generatedRecipes = []
                self.isLoading = false
                self.errorMessage = "Error generating recipes: \(error.localizedDescription)"
            }
        }
    }


    // Handle errors with appropriate feedback
    private func handleError(_ error: Error) {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                self.errorMessage = "Type mismatch: \(type), context: \(context)"
            case .valueNotFound(let value, let context):
                self.errorMessage = "Value not found: \(value), context: \(context)"
            case .keyNotFound(let key, let context):
                self.errorMessage = "Key not found: \(key), context: \(context)"
            case .dataCorrupted(let context):
                self.errorMessage = "Data corrupted: \(context)"
            @unknown default:
                self.errorMessage = "Unknown decoding error: \(decodingError)"
            }
        } else if let recipeError = error as? RecipeError {
            switch recipeError {
            case .noRecipesFound:
                self.errorMessage = "No recipes found."
            case .backendError(let message):
                self.errorMessage = "Backend error: \(message)"
            }
        } else {
            self.errorMessage = "Error: \(error.localizedDescription)"
        }
    }

    // Handle successfully generated recipes
    private func handleGeneratedRecipes(_ recipes: [Recipe]) {
        DispatchQueue.main.async {
            if recipes.isEmpty {
                self.generatedRecipes = [] // Empty list to show the "not found" message
            } else {
                self.generatedRecipes = recipes
            }
        }
    }

  
   }

enum RecipeError: Error {
    case noRecipesFound
    case backendError(String)  // Optional to handle more specific errors from the backend
}
