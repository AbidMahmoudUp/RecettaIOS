import SwiftUI


struct IngredientCardUIViewComponent: View {
    var ingredient: IngredientQte
    
    private var directImageUrl: String {
        ingredient.ingredient.image
            .replacingOccurrences(of: "file-", with: "https://example.com/images/") // Assuming a base URL for images
    }
    private let baseURL = "https://fdd2-197-22-195-235.ngrok-free.app/uploads/"

    
    var body: some View {
        HStack(spacing: 12) {
            // AsyncImage for loading image
            AsyncImage(url: URL(string: baseURL + ingredient.ingredient.image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .accessibilityLabel("Ingredient Image")
            } placeholder: {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                    .accessibilityLabel("Placeholder Image")
            }
            .padding(.leading, 12)

            VStack(alignment: .leading, spacing: 8) {
                // Ingredient Name
                HStack {
                    Text(ingredient.ingredient.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(String(ingredient.qte))
                }

                // Date formatted as "MM-dd-yyyy"
                Text(getCurrentDateFormatted())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 16)
        }
        .frame(maxWidth: .infinity , maxHeight: 120)
        .padding(.vertical, 8)
        .shadow(radius: 5)
    }

    private func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: Date())
    }
}

struct IngredientCardUIViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCardUIViewComponent(ingredient: IngredientQte(
            ingredient: Ingredient(
                name: "1",
                unit: "Tomato",
                image: "tomato.png",
                categorie: "Vegetable",
                id: "kg"
            ),
            qte: 5,  // Now passing qte as a string
            date: getCurrentDateFormatted()  // Calling getCurrentDateFormatted() directly here
        ))
        .previewLayout(.sizeThatFits)
    }

    // Move the getCurrentDateFormatted method outside of the main struct to make it accessible in preview
    static func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: Date())
    }
}
