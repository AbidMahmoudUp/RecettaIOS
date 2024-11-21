//
//  AuthManager.swift
//  Recetta
//
//  Created by wicked on 19.11.24.
//

import Foundation


class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published var isAuthenticated = false
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let userId = "userId"
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    func saveTokens(accessToken: String, refreshToken: String, userId: String) {
        defaults.set(accessToken, forKey: Keys.accessToken)
        defaults.set(refreshToken, forKey: Keys.refreshToken)
        defaults.set(userId, forKey: Keys.userId)
        isAuthenticated = true
    }
    
    func getAccessToken() -> String? {
        return defaults.string(forKey: Keys.accessToken)
    }
    
    func getUserId() -> String? {
        return defaults.string(forKey: Keys.userId)
    }
    
    func clearTokens() {
        defaults.removeObject(forKey: Keys.accessToken)
        defaults.removeObject(forKey: Keys.refreshToken)
        defaults.removeObject(forKey: Keys.userId)
        isAuthenticated = false
    }
}
