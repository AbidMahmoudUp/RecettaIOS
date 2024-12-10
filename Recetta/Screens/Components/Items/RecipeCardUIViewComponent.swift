import SwiftUI

struct RecipeCardUIViewComponent: View {
    var plat: Recipe  // Assuming Recipe is your data model
    
    var body: some View {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 16) {
                    Spacer(minLength: 0) // Push content down to center vertically

                    // Title and description section
                    Text(plat.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text(plat.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)

                    // Cooking time and energy section
                    HStack(spacing: 24) {
                        HStack(spacing: 6) {
                            Image(systemName: "clock")
                            Text("\(plat.cookingTime) mins")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)

                        Spacer()

                        HStack(spacing: 6) {
                            Image(systemName: "flame")
                            Text("\(plat.energy) kcal")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }


                    // View Recipe button
                    NavigationLink(destination: RecipeViewUI(recipe: plat)) {
                        Text("View Recipe")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.orange.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }.navigationBarBackButtonHidden()
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.red).opacity(0.2)) // Card background color
                )
                .frame(width: 240, height: 370)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 5, y: 5) // Add shadow here

                // Image at the top-right corner
                AsyncImage(url: URL(string: Constants.baseURLPicture + (plat.image ?? "defaultImage"))) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                            )
                            .shadow(radius: 5)
                            .offset(x: 24, y: -40)
                            .padding([.top, .trailing], 16)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                            )
                            .shadow(radius: 5)
                            .offset(x: 24, y: -40)
                            .padding([.top, .trailing], 16)
                    case .failure:
                        Image("defaultImage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                            )
                            .shadow(radius: 5)
                            .offset(x: 24, y: -40)
                            .padding([.top, .trailing], 16)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            .padding(.horizontal)
        }
}

/*
// Sample Data for Preview
struct RecipeCardUIViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIngredient = Ingredient(name: "", unit: "Tomato", image: "tomato.png", categorie: "Vegetable",id: "")

        let ingredientQte = IngredientRecipe(ingredient: sampleIngredient, qte: 2)
        RecipeCardUIViewComponent(plat: Recipe(
            id: "123",
            title: "Hot & Prawn Noodles",
            description: "A delicious blend of spicy noodles with fresh prawns and vegetables.", category: "eeeee",
            cookingTime: "20",
            energy: "150",
            rating: "4",
            image: "swift",
            
            ingredients: [ingredientQte],
            instructions: [""]
        ))
        .previewLayout(.sizeThatFits)
    }
 */

