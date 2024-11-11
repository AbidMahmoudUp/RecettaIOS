import SwiftUI

struct PlatCardUIViewComponent: View {
    var plat: Plat  // Assuming Plat is your data model
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) { // Increased spacing between elements
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/) // Push content down to center vertically
              
                
                // Title and description section
                Text(plat.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text(plat.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                // Cooking time and energy section
                HStack(spacing: 24) { // Increased spacing between time and energy
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
                
                // View Recipe button with increased padding
                Button(action: {
                    // Action for viewing the recipe
                }) {
                    Text("View Recipe")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14) // Increased padding for button
                        .background(Color.orange.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 20) // More padding on top of the button
                
                 // This will make the content fill the available space in the card
            }
            .padding(24) // Added extra padding for content
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.red).opacity(0.2))
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 7, y: -5)
            )
            .frame(width: 240, height: 400)  // Height remains at 400 for a more compact card
            
            // Image at the top-right corner with more padding for positioning
            Image(plat.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(radius: 5)
                .offset(x: 24, y: -40) // Increased offset to position the image better
                .padding([.top, .trailing], 16) // Extra padding to move the image away from the edge
        }
    }
}

struct PlatCardUIViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        let sampleIngredient = Ingredient(id:"",name: "Tomato", image: "tomato.png", category: "Vegetable")

        let ingredientQte = IngridientQte(id:"",ingredient: sampleIngredient, qte: 2)
        PlatCardUIViewComponent(plat: Plat(
            id:"",
            name: "Hot & Prawn Noodles",
            description: "A delicious blend of spicy noodles with fresh prawns and vegetables.",
            cookingTime: "20",
            energy: "150",
            image: "swift",
            rating: 4, ingredients: [ingredientQte] // Replace with your image asset name
        ))
        .previewLayout(.sizeThatFits)
    }
}
