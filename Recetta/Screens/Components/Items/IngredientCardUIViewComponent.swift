import SwiftUI


struct IngredientCardUIViewComponent: View {
    var ingredient: Ingredient
    
    private var directImageUrl: String {
        ingredient.image
            .replacingOccurrences(of: "file-", with: "https://example.com/images/") // Assuming a base URL for images
    }
    private let baseURL = "https://a346-102-157-75-86.ngrok-free.app/uploads/"

    
    var body: some View {
        HStack(spacing: 12) {
            // AsyncImage for loading image
            AsyncImage(url: URL(string: baseURL + ingredient.image)) { image in
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
                    Text(ingredient.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
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
        IngredientCardUIViewComponent(ingredient: Ingredient(
            _id: "1",
            name: "Tomato",
            image: "https://drive.google.com/file/d/1oGH6uL9-pkF4Yt0IJKLNRlFdKoErxe4S/view?usp=drive_link",
            categorie: "Vegetable"
        ))
        .previewLayout(.sizeThatFits)
    }
}
