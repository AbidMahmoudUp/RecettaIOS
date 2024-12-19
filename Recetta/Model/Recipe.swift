struct Recipe: Codable, Identifiable {
    let id: String?
    let title: String
    let description: String
    let category: String
    let cookingTime: String
    let energy: String
    let rating: String
    let image: String?
    let ingredients: [IngredientRecipe]
    let instructions: [String]?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title = "title"
        case description = "description"
        case category = "category"
        case cookingTime = "cookingTime"
        case energy = "energy"
        case rating = "rating"
        case image = "image"
        case ingredients = "ingredients"
        case instructions = "instructions"
    }

    init(id: String?, title: String, description: String, category: String, cookingTime: String, energy: String, rating: String, image: String?, ingredients: [IngredientRecipe], instructions: [String]?) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.cookingTime = cookingTime
        self.energy = energy
        self.rating = rating
        self.image = image
        self.ingredients = ingredients
        self.instructions = instructions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode id as String
        id = try container.decodeIfPresent(String.self, forKey: .id)
        
        // Decode title, description, category, and rating as String
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        category = try container.decode(String.self, forKey: .category)
        
        // Handle cookingTime as either a String or an Int
        if let cookingTimeInt = try? container.decode(Int.self, forKey: .cookingTime) {
            cookingTime = String(cookingTimeInt)  // Convert Int to String
        } else {
            cookingTime = try container.decode(String.self, forKey: .cookingTime)  // Fallback to decoding as String
        }
        
        // Handle energy as either a String or an Int
        if let energyInt = try? container.decode(Int.self, forKey: .energy) {
            energy = String(energyInt)  // Convert Int to String
        } else {
            energy = try container.decode(String.self, forKey: .energy)  // Fallback to decoding as String
        }
        
        // Handle rating as either a String or an Int
        if let ratingInt = try? container.decode(Int.self, forKey: .rating) {
            rating = String(ratingInt)  // Convert Int to String
        } else {
            rating = try container.decode(String.self, forKey: .rating)  // Fallback to decoding as String
        }
        
        // Decode image as String if present
        image = try container.decodeIfPresent(String.self, forKey: .image)
        
        // Decode ingredients as an array of IngredientRecipe
        ingredients = try container.decode([IngredientRecipe].self, forKey: .ingredients)
        
        // Decode instructions as an array of String if present
        instructions = try container.decodeIfPresent([String].self, forKey: .instructions)
    }
}
