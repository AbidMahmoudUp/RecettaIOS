import SwiftUI

struct EditProfileViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var emailValue = ""
    @State private var ageValue = ""
    @State private var phoneNumberValue = ""
    @State private var navigateToProfileView = false

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
                        .frame(height: 200)
                        .edgesIgnoringSafeArea(.top)

                        // Profile Image
                        VStack {
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
                        }
                    }

                    editableDetailsView()
                }
            }
            .onAppear {
                emailValue = userViewModel.profileData?.email ?? ""
                ageValue = userViewModel.profileData?.age ?? ""
                phoneNumberValue = userViewModel.profileData?.phone ?? ""
            }
            .navigationDestination(isPresented: $navigateToProfileView) {
                ProfileViewUI().navigationBarBackButtonHidden()
            }
        }
    }

    private func editableDetailsView() -> some View {
        VStack(spacing: 20) {
            // Editable rows for user details
            detailInput(icon: "envelope.fill", title: "Email", text: $emailValue)
            detailInput(icon: "iphone.fill", title: "Phone", text: $phoneNumberValue)
            detailInput(icon: "person.fill", title: "Age", text: $ageValue)

            // Save Changes Button
            Button(action: {
                var updatedProfile = userViewModel.profile
                if !emailValue.isEmpty { updatedProfile?.email = emailValue }
                if !phoneNumberValue.isEmpty { updatedProfile?.phone = phoneNumberValue }
                if !ageValue.isEmpty { updatedProfile?.age = ageValue }
                
                userViewModel.updateUserProfile(updatedUser: updatedProfile)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    navigateToProfileView = true
                }
            }) {
                Text("Save Changes")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding(30)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 7)
    }

    private func detailInput(icon: String, title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.gray)
            }
            TextField("Enter \(title)", text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
