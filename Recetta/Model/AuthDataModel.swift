//
//  AuthDataModel.swift
//  Recetta
//
//  Created by wicked on 19.11.24.
//

import Foundation
struct AuthDataModel: Codable {
    let accessToken: String
    let refreshToken: String
    let userId: String
}
