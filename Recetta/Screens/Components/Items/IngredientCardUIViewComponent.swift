import SwiftUI

struct IngredientCardUIViewComponent: View {
    var ingredient: IngredientQte
    @Binding var isSelectionMode: Bool
    @Binding var selectedIngredients: [String: Int]
    
    @State private var showMaxFeedback = false
    @State private var shakeCount: CGFloat = 0

    var body: some View {
        VStack {
            HStack(spacing: 12) {
                ingredientImage
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(ingredient.ingredient.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Available: \(Int(ingredient.qte))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                if isSelectionMode {
                    CounterControls(
                        ingredientId: ingredient.ingredient.id!,
                        currentQuantity: selectedIngredients[ingredient.ingredient.id!] ?? 0,
                        maxQuantity: Int(ingredient.qte),
                        incrementAction: incrementSelection,
                        decrementAction: decrementSelection
                    )
                }
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .onTapGesture {
            handleTap()
        }
        .onLongPressGesture {
            handleLongPress()
        }
    }

    // MARK: - Subviews and Computed Properties

    private var ingredientImage: some View {
        AsyncImage(url: URL(string: Constants.baseURLPicture + ingredient.ingredient.image)) { image in
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
    }

    // MARK: - Background Color

    private var backgroundColor: Color {
        if showMaxFeedback {
            return Color.red.opacity(0.2) // Flash red to indicate the limit
        }
        if isSelectionMode && selectedIngredients.keys.contains(ingredient.ingredient.id!) {
            return Color.orange.opacity(0.2)
        }
        return Color.white
    }

    // MARK: - Actions

    private func handleTap() {
        if isSelectionMode {
            toggleSelection()
        }
    }

    private func handleLongPress() {
        if !isSelectionMode {
            activateSelectionMode()
        }
    }

    private func activateSelectionMode() {
        isSelectionMode = true
        selectedIngredients[ingredient.ingredient.id!] = 0
    }

    private func toggleSelection() {
        if selectedIngredients.keys.contains(ingredient.ingredient.id!) {
            // Only deselect if the current quantity is 0
            if selectedIngredients[ingredient.ingredient.id!] == 0 {
                selectedIngredients.removeValue(forKey: ingredient.ingredient.id!)
            }
        } else {
            selectedIngredients[ingredient.ingredient.id!] = 0
        }
    }
    
    
    private func incrementSelection() {
        if let current = selectedIngredients[ingredient.ingredient.id!] {
            // Select the ingredient if not already selected
            if current == 0 {
                // This will add the ingredient to the selection and highlight the card
                selectedIngredients[ingredient.ingredient.id!] = 1
            } else if current < Int(ingredient.qte) {
                selectedIngredients[ingredient.ingredient.id!] = current + 1
            } else {
                showMaxQuantityFeedback()
            }
        } else {
            // If the ingredient is not in the selectedIngredients, add it and highlight the card
            selectedIngredients[ingredient.ingredient.id!] = 1
        }
    }


    private func decrementSelection() {
        if let current = selectedIngredients[ingredient.ingredient.id!], current > 0 {
            selectedIngredients[ingredient.ingredient.id!] = current - 1
        }
    }

    private func showMaxQuantityFeedback() {
        withAnimation {
            shakeCount += 1
            showMaxFeedback = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showMaxFeedback = false
        }
    }
}

// MARK: - CounterControls View

struct CounterControls: View {
    let ingredientId: String
    let currentQuantity: Int
    let maxQuantity: Int
    let incrementAction: () -> Void
    let decrementAction: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: decrementAction) {
                Image(systemName: "minus.circle")
            }
            .disabled(currentQuantity == 0)

            Text("\(currentQuantity)")
                .frame(width: 40)
                .font(.headline)

            Button(action: incrementAction) {
                Image(systemName: "plus.circle")
            }
            .disabled(currentQuantity >= maxQuantity) // Disable at max
        }
        .padding(.trailing, 16)
    }
}

// MARK: - Preview

struct IngredientCardUIViewComponent_Previews: PreviewProvider {
    static var previews: some View {
        IngredientCardUIViewComponent(
            ingredient: IngredientQte(
                ingredient: Ingredient(
                    name: "Tomato",
                    unit: "kg",
                    image: "tomato.png",
                    categorie: "Vegetable",
                    id: "1"
                ),
                qte: 5,
                date: "2024"
            ),
            isSelectionMode: .constant(false),
            selectedIngredients: .constant([:])
        )
        .previewLayout(.sizeThatFits)
    }
}

// MARK: - ShakeEffect

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit: Double = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}
