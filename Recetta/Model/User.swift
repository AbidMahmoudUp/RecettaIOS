struct User: Codable {
    
    var name: String
    var email: String
    var phone: String?
    var age: String?
    
    
    enum CodingKeys: String, CodingKey {
        case name, email, phone, age
    }
    
    // Custom initializer to handle decoding of the age field
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decodeIfPresent(String.self, forKey: .phone)
        
        // Handle age field decoding
        if let ageNumber = try? container.decode(Int.self, forKey: .age) {
            self.age = String(ageNumber) // Convert Int to String
        } else {
            self.age = try container.decode(String.self, forKey: .age) // If it's already a String, decode it directly
        }
    }
}
