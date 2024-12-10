import SwiftUI
class RecipeViewModel: ObservableObject {
    
    @Published var recipe: Recipe?
    @Published var recipesList: [Recipe] = []
    @Published var errorMessage: String?
    @Published var filteredRecipes: [Recipe] = []  // Filtered recipes

    @Published var generatedRecipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var progress: Float = 0.0

    private let repository: RecipeRepository
    @Published var searchText: String = "" {
         didSet {
             filterRecipes()
         }
     }

    @Published var selectedCategories: Set<CategorieHome> = [] {
        didSet {
            filterRecipes()
        }
    }
    private func filterRecipes() {
        filteredRecipes = recipesList.filter { recipe in
            // Check for matching search text
            let matchesSearchText = searchText.isEmpty || recipe.title.localizedCaseInsensitiveContains(searchText)
            
            // Check if the recipe's category is selected
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains { category in
                category.text == recipe.category
            }
            
            return matchesSearchText && matchesCategory
        }
    }


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
    
    
    
    
    func processPassedRecipe(_ recipe: Recipe) async {
        do {   if let id = recipe.id, !id.isEmpty {
            // If the recipe has an ID, fetch the complete recipe by ID
          await  fetchRecipeById(recipeId: id)
        } else {
            // If the recipe does not have an ID, just use the passed recipe
            self.recipe = recipe
        }
        }
        }
    
    // Fetch all recipes
    func fetchRecipes() async {
        do {
            let fetchedRecipes = try await repository.getRecipes()
            print("Fetched Recipes: \(fetchedRecipes)") // Debug log
            self.recipesList = fetchedRecipes
            filterRecipes() // Update the filtered recipes list

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
            
            // Fetch recipes asynchronously
            let fetchedRecipes = try await repository.generateRecipe(request: dto)
            
            // Handle the fetched recipes
            handleGeneratedRecipes(fetchedRecipes)
            
            // Insert the fetched recipes into the database
            do {
                try await repository.addRecipe(recipes: fetchedRecipes)
                print("Recipes successfully added to the database.")
            } catch {
                handleError(error) // Handle error from the addRecipe method
            }
            
        } catch {
            // Handle errors related to recipe generation
            handleError(error)
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
        
        DispatchQueue.main.async {
            print("Error: \(self.errorMessage ?? "Unknown error")")
            self.isLoading = false
        }
    }

    // Handle successfully generated recipes
    private func handleGeneratedRecipes(_ recipes: [Recipe]) {
        DispatchQueue.main.async {
            if recipes.isEmpty {
                self.generatedRecipes = [] // Empty list to show the "not found" message
                self.errorMessage = "No recipes found."
            } else {
                self.generatedRecipes = recipes
            }
            self.isLoading = false
        }
    }

    
    

  
   }

