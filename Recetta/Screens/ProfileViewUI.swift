import SwiftUI

struct ProfileViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var navigateToLoginView = false
    @State private var navigateToEditProfileView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                // Header Section
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                        startPoint: .topTrailing,
                        endPoint: .bottomLeading
                    )
                    .frame(height: 200)
                    .edgesIgnoringSafeArea(.top)

                    // Profile Image
                    VStack {
                        Image(ImageResource.profilePicExample)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                            )
                            .shadow(radius: 10)
                            .padding(.top, 50)
                    }
                }
                
                // User Name and Edit Button
                if let userProfile = userViewModel.profile {
                    userNameView(username: userProfile.name)
                    Text("Edit")
                       .font(.system(size: 20, weight: .bold))
                       .foregroundColor(.cyan)
                       .onTapGesture {
                           navigateToEditProfileView.toggle()
                       }
                       .padding(5)
                    
                    Text("Delete Account")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.red)
                        .onTapGesture {
                            userViewModel.deleteUser()
                            UserDefaults.standard.set(false, forKey: "remember")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.navigateToLoginView = true
                                
                            }
                            
                        }.padding(5)

                    userDetailsView(userProfile: userProfile)
                } else if let errorMessage = userViewModel.profileErrorMessage {
                    Text(errorMessage)
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Loading state
                    if userViewModel.profileIsLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginScreenViewUI().navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $navigateToEditProfileView) {
                EditProfileViewUI().navigationBarBackButtonHidden()
            }
            .onAppear {
                userViewModel.getUserData()
            }
        }
    }

    private func userNameView(username: String) -> some View {
        HStack {
            Text(username)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(5)
        }
    }

    private func userDetailsView(userProfile: User) -> some View {
        VStack(spacing: 30) {
            detailRow(icon: "envelope", title: "Email", value: userProfile.email)
            detailRow(icon: "iphone.gen2", title: "Mobile number", value: userProfile.phone ?? "Not Provided")
            detailRow(icon: "person.badge.key", title: "Age", value: userProfile.age ?? "Not Assigned")

            Button(action: {
                // Sign-out logic
                UserDefaults.standard.set(false, forKey: "remember")
                navigateToLoginView = true
            }) {
                Text("Sign out")
                    .frame(width: UIScreen.main.bounds.width - 200)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
            }
            .background(Color("Color1"))
            .clipShape(Capsule())
            .padding(.top, 20)
        }
        .padding(50)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 7)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        VStack {
            HStack {
                Image(systemName: icon).foregroundStyle(Color.cyan)
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
            Text(value)
                .font(.system(size: 18))
                .foregroundColor(.black)
        }
    }
}
