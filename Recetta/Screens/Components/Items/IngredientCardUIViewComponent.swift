import SwiftUI

struct IngredientCardUIViewComponent: View {

    var ingredient: Ingredient // Assuming Ingredient is your model
     
    private var directImageUrl: String {
        ingredient.image
            .replacingOccurrences(of: "https://drive.google.com/file/d/", with: "https://drive.google.com/uc?export=download&id=")
            .replacingOccurrences(of: "/view?usp=drive_link", with: "")
    }
     

    var body: some View {
        HStack(spacing: 12) {
            // AsyncImage for loading image
            AsyncImage(url: URL(string: directImageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
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
                // Ingredient Name and Quantity
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
        .frame(maxWidth: .infinity , maxHeight: 120) // Ensure the card takes up the full width
        .padding(.vertical, 8)
        
        .shadow(radius: 5)
    }
     
    // Helper function to get current date in "MM-dd-yyyy" format
    private func getCurrentDateFormatted() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: Date())
    }
}

struct IngredientCardUIViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCardUIViewComponent(ingredient: Ingredient(
            id: "1",
            name: "Tomato",
            image: "https://drive.google.com/file/d/1oGH6uL9-pkF4Yt0IJKLNRlFdKoErxe4S/view?usp=drive_link",
            category: "Vegetable"
        ))
        .previewLayout(.sizeThatFits)
    }
}
