//
//  RecipeViewUI.swift
//  Recetta
//
//  Created by wicked on 21.11.24.
//

import SwiftUI
import CoreData
struct RecipeViewUI: View {
    
    @ObservedObject var viewModel: RecipeViewModel
    @ObservedObject var inventoryViewModel : InventoryViewModel
     var recipeId: String

    init(recipeId: String, viewModel: RecipeViewModel = RecipeViewModel(), inventoryViewModel: InventoryViewModel = InventoryViewModel()) {
        self.recipeId = recipeId
        self.viewModel = viewModel
        self.inventoryViewModel = inventoryViewModel
    }

     var body: some View {
         VStack {
             if let recipe = viewModel.recipe {
                 ScrollView {
                     VStack {
                         ParallaxToolbar(recipe: recipe)
                         ContentRecipeView(recipe: recipe, viewModel: inventoryViewModel)
                     }
                 }
             } else if let errorMessage = viewModel.errorMessage {
                 // Display error message
                 Text(errorMessage)
                     .foregroundColor(.red)
                     .padding()
             } else {
                 // Display loading state
                 ProgressView("Loading...")
                     .padding()
             }
         }
         .onAppear {
             Task {
                 await viewModel.fetchRecipeById(recipeId: recipeId)
             }
         }
     }
 }


 // ParallaxToolbar Subview
struct ParallaxToolbar: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var userId: String =  (AuthManager.shared.getUserId() ?? "")
    @State private var isLiked: Bool = false

    var recipe: Recipe

    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: recipe.image ?? "defaultImage")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray
            }
            .frame(height: 300)
            .clipped()

            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.5), Color.clear]),
                           startPoint: .bottom,
                           endPoint: .top)
                .frame(height: 300)

            HStack {
                Button(action: {
                    // Action for back button
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }
                Spacer()
                Text(recipe.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    toggleLikeStatus()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .onAppear {
            checkIfLiked()
        }
    }

    /// Check if the recipe is already in Core Data
    private func checkIfLiked() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id ?? "")

        do {
            let count = try viewContext.count(for: fetchRequest)
            isLiked = count > 0
        } catch {
            print("Failed to check recipe: \(error.localizedDescription)")
            isLiked = false
        }
    }

    /// Toggle the like status
    private func toggleLikeStatus() {
        if isLiked {
            removeFromFavorites()
        } else {
            addToFavorites()
        }
    }

    /// Add the recipe to Core Data
    private func addToFavorites() {
        let newRecipe = RecipeEntity(context: viewContext)
        newRecipe.id = recipe.id
        newRecipe.title = recipe.title
        newRecipe.descriptionRecipe = recipe.description
        newRecipe.category = recipe.category
        newRecipe.cookingtime = recipe.cookingTime
        newRecipe.energy = recipe.energy
        newRecipe.rating = recipe.rating
        newRecipe.image = recipe.image
        newRecipe.userId = userId

        do {
            try viewContext.save()
            isLiked = true
            print("Recipe saved to Core Data")
        } catch {
            print("Failed to save recipe: \(error.localizedDescription)")
        }
    }

    /// Remove the recipe from Core Data
    private func removeFromFavorites() {
        let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", recipe.id ?? "")

        do {
            let recipes = try viewContext.fetch(fetchRequest)
            for recipeEntity in recipes {
                viewContext.delete(recipeEntity)
            }
            try viewContext.save()
            isLiked = false
            print("Recipe removed from Core Data")
        } catch {
            print("Failed to remove recipe: \(error.localizedDescription)")
        }
    }
}



struct ContentRecipeView: View {
    var recipe: Recipe
    @ObservedObject var viewModel: InventoryViewModel // Bind to your ViewModel
    @State private var userId: String = (AuthManager.shared.getUserId() ?? "")

    var body: some View {
        // Create the ingredientSet here
        let ingredientSet: Set<IngredientRecipe> = Set(recipe.ingredients.map { ingredientRecipe in
            IngredientRecipe(ingredient: ingredientRecipe.ingredient, qte: ingredientRecipe.qte)
        })

        VStack(alignment: .leading) {
            BasicInfo(recipe: recipe)
            Description(recipe: recipe)
            ServingCalculator()
            IngredientsHeader()
            IngredientsList(ingredients: recipe.ingredients)
            ShoppingListButton(viewModel: viewModel,
                               userId: userId,
                               ingredients: IngredientUpdateDto(ingredients: ingredientSet))
            Reviews(recipe: recipe)
           // Images()
        }
    }
}


   struct BasicInfo: View {
       var recipe: Recipe

       var body: some View {
           HStack {
               InfoColumn(icon: "clock", text: recipe.cookingTime)
               InfoColumn(icon: "flame", text: recipe.energy)
               InfoColumn(icon: "star", text: String(recipe.rating))
           }
           .padding()
       }
   }

   struct InfoColumn: View {
       var icon: String
       var text: String

       var body: some View {
           VStack {
               Image(systemName: icon)
                   .resizable()
                   .frame(width: 24, height: 24)
                   .foregroundColor(.pink)
               Text(text)
                   .font(.subheadline)
                   .bold()
           }
       }
   }

   struct Description: View {
       var recipe: Recipe

       var body: some View {
           Text(recipe.description)
               .padding()
       }
   }

   struct ServingCalculator: View {
       @State private var value: Int = 6

       var body: some View {
           HStack {
               Text("Serving")
               Spacer()
               Button(action: {
                   if value > 1 {
                       value -= 1
                   }
               }) {
                   Image(systemName: "minus.circle")
                       .foregroundColor(.pink)
               }
               Text("\(value)")
                   .padding(.horizontal)
               Button(action: {
                   value += 1
               }) {
                   Image(systemName: "plus.circle")
                       .foregroundColor(.pink)
               }
           }
           .padding()
           .background(Color.gray.opacity(0.2))
           .cornerRadius(8)
       }
   }

   struct IngredientsHeader: View {
       var body: some View {
           HStack {
               TabButton(text: "Ingredients", active: true)
               TabButton(text: "Steps", active: false)
           }
           .padding()
           .background(Color.gray.opacity(0.2))
           .cornerRadius(8)
       }
   }

   struct TabButton: View {
       var text: String
       var active: Bool

       var body: some View {
           Button(action: {}) {
               Text(text)
                   .foregroundColor(active ? .white : .black)
                   .padding()
                   .background(active ? Color.pink : Color.gray.opacity(0.2))
                   .cornerRadius(8)
           }
       }
   }

struct IngredientsList: View {
    var ingredients: [IngredientRecipe]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
            ForEach(ingredients, id: \.ingredient?.id) { ingredientRecipe in
                if let ingredient = ingredientRecipe.ingredient {
                    IngredientCard(ingredient: ingredient)
                }
            }
        }
    }
}

   struct IngredientCard: View {
       var ingredient: Ingredient

       var body: some View {
           VStack {
               AsyncImage(url: URL(string: ingredient.image)) { image in
                   image.resizable()
                       .aspectRatio(contentMode: .fill)
               } placeholder: {
                   Color.gray
               }
               .frame(width: 100, height: 100)
               .clipShape(RoundedRectangle(cornerRadius: 10))
               Text(ingredient.name)
                   .font(.subheadline)
           }
       }
   }

struct ShoppingListButton: View {
    @ObservedObject var viewModel: InventoryViewModel
    var userId: String
    var ingredients: IngredientUpdateDto
    @State private var showDialog: Bool = false
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Button(action: {
                // Call the updateInventoryForRequiredRecipe function when the button is clicked
                viewModel.updateInventoryForRequiredRecipe(userId: userId, ingredients: ingredients)
            }) {
                Text("Start Cooking")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding()
        }
        // Use onChange to reactively handle changes in errorMessage
        .onChange(of: viewModel.errorMessage) { newErrorMessage in
            if let newErrorMessage = newErrorMessage {
                // Update local state when the error message changes
                self.errorMessage = newErrorMessage
                self.showDialog = true
            }
        }
        // Display the Alert when errorMessage is not empty
        .alert(isPresented: $showDialog) {
            Alert(
                title: Text("Oops"),
                message: Text(errorMessage ?? "An unknown error occurred"),
                dismissButton: .default(Text("OK")) {
                    // Clear the error message when the dialog is dismissed
                    viewModel.clearErrorMessage()
                }
            )
        }
    }
}





   struct Reviews: View {
       var recipe: Recipe

       var body: some View {
           HStack {
               Text("Reviews")
                   .font(.headline)
               Spacer()
               Button(action: {}) {
                   HStack {
                       Text("See all")
                       Image(systemName: "arrow.right")
                   }
               }
           }
           .padding()
       }
   }









 //  struct Images: View {
 //      var body: some View {
 //          HStack(spacing: 16) {
 //              Image("strawberry_pie_2")
 //                  .resizable()
 //                  .frame(width: 100, height: 100)
 //                  .clipShape(RoundedRectangle(cornerRadius: 10))
 //              Image("strawberry_pie_3")
 //                  .resizable()
 //                  .frame(width: 100, height: 100)
 //                  .clipShape(RoundedRectangle(cornerRadius: 10))
 //          }
 //          .padding()
 //      }
    //}

#Preview {
    RecipeViewUI(recipeId: "1")
}
