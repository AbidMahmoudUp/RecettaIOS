//
//  RecipeViewUI.swift
//  Recetta
//
//  Created by wicked on 21.11.24.
//

import SwiftUI

struct RecipeViewUI: View {
    @ObservedObject var viewModel: RecipeViewModel
     var recipeId: String

     init(recipeId: String, viewModel: RecipeViewModel = RecipeViewModel()) {
         self.recipeId = recipeId
         self.viewModel = viewModel
     }

     var body: some View {
         VStack {
             if let recipe = viewModel.recipe {
                 ScrollView {
                     VStack {
                         ParallaxToolbar(recipe: recipe)
                         ContentRecipeView(recipe: recipe)
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
         .padding(.bottom, 80)
     }
 }

 // ParallaxToolbar Subview
 struct ParallaxToolbar: View {
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
                     // Action for favorite
                 }) {
                     Image(systemName: "heart")
                         .foregroundColor(.white)
                         .padding()
                         .background(Color.black.opacity(0.7))
                         .clipShape(Circle())
                 }
             }
             .padding()
         }
     }
 }

   struct ContentRecipeView: View {
       var recipe: Recipe

       var body: some View {
           VStack(alignment: .leading) {
               BasicInfo(recipe: recipe)
               Description(recipe: recipe)
               ServingCalculator()
               IngredientsHeader()
               IngredientsList(ingredients: recipe.ingredients)
               ShoppingListButton()
               Reviews(recipe: recipe)
               Images()
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
               TabButton(text: "Tools", active: false)
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
       var body: some View {
           Button(action: {}) {
               Text("Add to shopping list")
                   .padding()
                   .frame(maxWidth: .infinity)
                   .background(Color.gray.opacity(0.2))
                   .cornerRadius(8)
           }
           .padding()
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

   struct Images: View {
       var body: some View {
           HStack(spacing: 16) {
               Image("strawberry_pie_2")
                   .resizable()
                   .frame(width: 100, height: 100)
                   .clipShape(RoundedRectangle(cornerRadius: 10))
               Image("strawberry_pie_3")
                   .resizable()
                   .frame(width: 100, height: 100)
                   .clipShape(RoundedRectangle(cornerRadius: 10))
           }
           .padding()
       }
}

#Preview {
    RecipeViewUI(recipeId: "1")
}
