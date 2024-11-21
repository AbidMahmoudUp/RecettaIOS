//
//  UserViewModel.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import SwiftUI
import Combine

class UserViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var isSignedUp: Bool = false
    @Published var profile: User?
    @Published var OTPCode : String = ""
    @Published var VerifyOTPCode : String = ""
    @Published var newPassword: String = ""
    @Published var isOTPValid: Bool = false
    @Published var navigateToHome: Bool = false
    @Published var navigateToResetPassword: Bool = false
    @Published var navigateToChangePassword: Bool = false
    @Published var isEditingUser: Bool = false
    @Published var userIdByOTP: String = ""
    
    
    struct AuthDataModel: Codable {
        let accessToken: String
        let refreshToken: String
        let userId: String
    }

    struct OTPData: Codable {
        let userId: String
        let code: String
    }

    private let baseURL = "https://a346-102-157-75-86.ngrok-free.app/api"
    func areCredentialsValid() -> Bool {
           return !username.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    func signUp() {
        guard let url = URL(string: "\(baseURL)/auth/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "name": username,
            "email": email,
            "password": password
        ]
        
        print(body)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            print(data,response)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                DispatchQueue.main.async {
                    self?.isSignedUp = true
                   // self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    func verifyOTP (){
        if OTPCode == "" {
            
        } else {
            
            guard let url = URL(string: "\(baseURL)/auth/verify-email") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "email": email,
                "otp": OTPCode,
              //  "password": password
            ]
            print(body)
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    // Utilisateur créé, récupérer les infos de profil
                    DispatchQueue.main.async {
                        self?.isOTPValid = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.errorMessage = "Error signing up"
                    }
                }
            }.resume()
        }
    }
    
    func verifyEmail() {
        guard let url = URL(string: "\(baseURL)/auth/forget-password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
          //  "password": password
        ]
        print(body)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//                let userModel = User(id: profile!["_id"] as! String, username: profile!["username"] as! String, email: profile!["email"] as! String)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                var dict = try? JSONSerialization.jsonObject(with: data!) as? NSDictionary
                print(dict)
                DispatchQueue.main.sync {
                    self?.VerifyOTPCode = dict!["code"] as! String
                    self?.userIdByOTP = dict!["userId"] as! String
                    //  self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    
    func resetPassword() {
        guard let url = URL(string: "\(baseURL)/auth/reset-password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "userId": userIdByOTP,
            "newPassword": newPassword
          //  "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                // Utilisateur créé, récupérer les infos de profil
                DispatchQueue.main.async {
                  //  self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error signing up"
                }
            }
        }.resume()
    }
    
    
    
    func signin() {
        guard let url = URL(string: "\(baseURL)/auth/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                do {
                    let data = try JSONDecoder().decode(AuthDataModel.self, from: data!)
//                    let data = try JSONSerialization.jsonObject(with:  data!)
                    DispatchQueue.main.async {
                        AuthManager.shared.saveTokens(accessToken: data.accessToken, refreshToken: data.refreshToken, userId: data.userId)
                    }
                    print("\(data)")
                } catch  {
                    
                }
              
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                  //  self?.fetchProfile()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error signing in"
                }
            }
        }.resume()
    }
    // Méthode pour récupérer le profil
    func fetchProfile() {
        let userId = AuthManager.shared.getUserId()
        let url = URL(string: "\(baseURL)/user/userId/\(userId!)")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        do {
            URLSession.shared.dataTask(with: request) {data,response,error in
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse?.statusCode)
                let profile = try? JSONSerialization.jsonObject(with: data!) as? NSDictionary
//                let userModel = User(id: profile!["_id"] as! String, username: profile!["username"] as! String, email: profile!["email"] as! String)
//                print(userModel)
                DispatchQueue.main.sync {
//                    self.profile = userModel
                    self.isEditingUser = true
                }
            }.resume()
        } catch  {
            
        }
    }
}
