import SwiftUI

struct ProfileViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var navigateToLoginView = false
    @State private var navigateToEditProfileView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Section
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.yellow, Color.orange]),
                            startPoint: .topTrailing,
                            endPoint: .bottomLeading
                        )
                      

                        .frame(height: 250)
                        .edgesIgnoringSafeArea(.top)
                        
                        VStack(spacing: 8) {
                            Image(ImageResource.profilePicExample)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(radius: 10)
                                .padding(.top, 50)
                            
                            if let userProfile = userViewModel.profile {
                                Text(userProfile.name)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    // Profile Details Section
                    if let userProfile = userViewModel.profile {
                        VStack(spacing: 16) {
                            // Edit Profile Button
                            NavigationLink(destination: EditProfileViewUI(), isActive: $navigateToEditProfileView) {
                                Text("Edit Profile")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            
                            // Delete Account
                            Button(action: {
                                userViewModel.deleteUser()
                                UserDefaults.standard.set(false, forKey: "remember")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.navigateToLoginView = true
                                }
                            }) {
                                Text("Delete Account")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            
                            // User Details
                            userDetailsCard(userProfile: userProfile)
                        }
                        .padding(.horizontal, 16)
                    } else if let errorMessage = userViewModel.profileErrorMessage {
                        Text(errorMessage)
                            .font(.system(size: 18))
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        if userViewModel.profileIsLoading {
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginScreenViewUI().navigationBarBackButtonHidden()
            }
            .onAppear {
                userViewModel.getUserData()
            }
        }
    }

    private func userDetailsCard(userProfile: User) -> some View {
        VStack(spacing: 12) {
            detailRow(icon: "envelope.fill", title: "Email", value: userProfile.email)
            detailRow(icon: "phone.fill", title: "Phone                                 ", value: userProfile.phone ?? "Not Provided")
            detailRow(icon: "person.crop.circle", title: "Age                                      ", value: userProfile.age ?? "Not Assigned")
            
            Button(action: {
                UserDefaults.standard.set(false, forKey: "remember")
                navigateToLoginView = true
            }) {
                Text("Sign Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
            }
        }
    }
}
