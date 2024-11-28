import SwiftUI
struct ProfileViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var navigateToLoginView = false
    @State private var navigateToEditProfileView = false
    @State private var usernameValue : String = "name"

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                // Header Section
                ZStack {
                    // Background gradient
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
                
                // Show loading or user data
                if userViewModel.profileIsLoading {
                    Text("Loading...")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                        .padding()
                } else if let userProfile = userViewModel.profile {
                    userNameView(userProfile: userProfile)
                    Text("Edit")
                       .font(.system(size: 20, weight: .bold))
                       .foregroundColor(.cyan)
                       .onTapGesture {
                           navigateToEditProfileView.toggle()
                       }
                       .padding(5)

                    userDetailsView(userProfile: userProfile)
                } else if let errorMessage = userViewModel.profileErrorMessage {
                    Text(errorMessage)
                        .font(.system(size: 18))
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginScreenViewUI().navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $navigateToEditProfileView) {
                EditProfileViewUI().navigationBarBackButtonHidden()
            }
            .onAppear {
                userViewModel.getUserData() // Fetch user data when the view appears
            }
            
        }
    }
    private func userNameView(userProfile: User) -> some View {
        HStack {
            Text(userProfile.username)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.black)
                .padding(5)
        }

        
    }

    private func userDetailsView(userProfile: User) -> some View {
        
        VStack(spacing: 30) {
            // Replace hardcoded values with actual user data
            detailRow(icon: "envelope", title: "Email", value: userProfile.email)
            detailRow(icon: "iphone.gen2", title: "Mobile number", value: userProfile.phoneNumber ?? "Not Provided")
            detailRow(icon: "person.badge.key", title: "Role", value: userProfile.role ?? "Not Assigned")

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

    private func editableRow(icon: String, title: String, value: Binding<String>, show: Binding<Bool>) -> some View {
        VStack {
            HStack {
                Image(systemName: icon).foregroundStyle(Color.cyan)
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .onTapGesture {
                        show.wrappedValue.toggle()
                    }
                    .foregroundColor(.black)
            }
            if show.wrappedValue {
                TextField(title, text: value)
                    .frame(width: 200, height: 40)
                    .textFieldStyle(.roundedBorder)
            }
        }
    }
}
