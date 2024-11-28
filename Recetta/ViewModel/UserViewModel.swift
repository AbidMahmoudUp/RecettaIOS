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
    @Published var OTPCode : String = ""
    @Published var VerifyOTPCode : String = ""
    @Published var newPassword: String = ""
    @Published var isOTPValid: Bool = false
    @Published var navigateToHome: Bool = false
    @Published var navigateToResetPassword: Bool = false
    @Published var navigateToChangePassword: Bool = false
    @Published var isEditingUser: Bool = false
    @Published var userIdByOTP: String = ""
    @Published var profile: User? = nil
    @Published var profileErrorMessage: String?
    @Published var profileIsLoading: Bool = false

    
    struct AuthDataModel: Codable {
        let accessToken: String
        let refreshToken: String
        let userId: String
    }

    struct OTPData: Codable {
        let userId: String
        let code: String
    }

    private let baseURL = "https://080d-102-156-55-70.ngrok-free.app/api"
    func areCredentialsValid() -> Bool {
           return !username.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    func updateUserProfile(updatedUser: User) {
        guard let userId = AuthManager.shared.getUserId() else { return }
        guard let url = URL(string: "\(baseURL)/auth/update-profile") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the body of the request with the updated user profile data
        let body: [String: Any] = [
            "userId": userId,
            "username": updatedUser.username,
            "email": updatedUser.email
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error encoding updated data."
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error updating user profile."
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self?.profile = updatedUser  // Update the local profile data
                    self?.errorMessage = nil
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error updating user profile."
                }
            }
        }.resume()
    }
    func getUserData() {
        guard let userId = AuthManager.shared.getUserId() else { return }
        guard let url = URL(string: "\(baseURL)/auth/GetUser") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Construct the body of the request with the userId
        let body: [String: Any] = [
            "userId": userId
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            DispatchQueue.main.async {
                self.profileErrorMessage = "Error encoding request data."
                self.profileIsLoading = false
            }
            return
        }

        // Start loading
        DispatchQueue.main.async {
            self.profileIsLoading = true
        }

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            // Handle network error
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.profileErrorMessage = "Error fetching user data."
                    self.profileIsLoading = false
                }
                return
            }

            // Log response data for debugging
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
    if let responseDataString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseDataString)")
                }
            }

            // Check for successful response with status code 200 or 201
            if let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 || httpResponse.statusCode == 201) {
                do {
                    // Decode the user data from the response
                    let userProfile = try JSONDecoder().decode(User.self, from: data)

                    // Ensure required fields (username, email) are set
                    let profile = User(
                        username: userProfile.username,
                        email: userProfile.email, password: userProfile.password ?? "",
                        age: userProfile.age ?? "", // Set empty string if age is missing
                        phoneNumber: userProfile.phoneNumber ?? "", // Set empty string if phone is missing
                        role: userProfile.role ?? "" // Set empty string if role is missing
                    )
                    
                    DispatchQueue.main.async {
                        self.profile = profile
                        self.profileIsLoading = false // Stop loading once data is fetched
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.profileErrorMessage = "Error decoding user data: \(error.localizedDescription)"
                        self.profileIsLoading = false // Stop loading even if there's an error
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.profileErrorMessage = "Error fetching user data. Status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                    self.profileIsLoading = false // Stop loading
                }
            }
        }.resume()
    }


    
    
    func deleteUser() {
        guard let userId = AuthManager.shared.getUserId() else { return }
        guard let url = URL(string: "\(baseURL)/auth/DeleteUser") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Construct the body with the userId to delete
        let body: [String: Any] = [
            "userId": userId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error encoding delete request."
            }
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error deleting user."
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self?.profile = nil  // Clear the local profile data after deletion
                    self?.errorMessage = nil
                }
            } else {
                DispatchQueue.main.async {
                    self?.errorMessage = "Error deleting user."
                }
            }
        }.resume()
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
            print(data, response)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 201 {
                    // User created, retrieve profile info
                    DispatchQueue.main.async {
                        self?.isSignedUp = true
                        // self?.fetchProfile() // Uncomment if you want to fetch the profile after signup
                    }
                } else if httpResponse.statusCode == 400 {
                    // Handle 400 Bad Request (likely email already in use)
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let message = responseData["message"] as? String {
                        // Show the error message from the server
                        DispatchQueue.main.async {
                            self?.errorMessage = message
                        }
                    } else {
                        // Fallback generic error message if no detailed message is available
                        DispatchQueue.main.async {
                            self?.errorMessage = "Invalid data. Please check your input."
                        }
                    }
                } else {
                    // Handle other status codes
                    DispatchQueue.main.async {
                        self?.errorMessage = "Failed to sign up. Please try again."
                    }
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
