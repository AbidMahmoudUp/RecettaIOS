//
//  User.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import Foundation

struct User: Codable {
    let username: String
    let email: String
    let password : String?
    let age: String?
    let phoneNumber: String?
    let role: String?

    enum CodingKeys: String, CodingKey {
        case username
        case email
        case age
        case phoneNumber = "phone"
        case role
        case password
    }
}
