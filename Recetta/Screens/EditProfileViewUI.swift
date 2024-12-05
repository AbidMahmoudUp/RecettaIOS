import SwiftUI

struct EditProfileViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var emailTfShow = false
    @State private var editState = false
    @State private var emailValue = ""
    @State private var ageValue = ""
    @State private var phoneNumberValue = ""
    @State private var navigateToProfileView = false
    @State private var navigateToLoginView = false

    var body: some View {
        NavigationStack {
            ScrollView {
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
                    

                    editableDetailsView()
                }
            }
            .onAppear {
                userViewModel.getUserData()
            }
            .navigationDestination(isPresented: $navigateToProfileView) {
                ProfileViewUI().navigationBarBackButtonHidden()
            }
        }
    }

    private func editableDetailsView() -> some View {
        VStack(spacing: 30) {
            // Editable rows for user details
           VStack
            {
                detailRow(icon: "envelope", title: "Email")
                TextField(userViewModel.profileData?.email ?? "",text: $emailValue)
                .font(.system(size: 18))
                .foregroundColor(.black)
            }
            VStack{
                detailRow(icon: "iphone.gen2", title: "Mobile number")
                TextField( userViewModel.profileData?.phone ?? "Not Provided",text: $phoneNumberValue)
                .font(.system(size: 18))
                .foregroundColor(.black)
               
            }
            VStack{
                detailRow(icon: "person.badge.key", title: "Age")
                TextField( userViewModel.profileData?.age ?? "Not Assigned",text: $ageValue)
                .font(.system(size: 18))
                .foregroundColor(.black)
            }

            // Save Changes Button
            Button(action: {
                
                
                
                let currentProfile = userViewModel.profile

                var updatedProfile = currentProfile
                
                if !emailValue.isEmpty && !(emailValue == userViewModel.profileData?.email) {
                    updatedProfile?.email = emailValue
                }
                
                if !phoneNumberValue.isEmpty {
                    updatedProfile?.phone = phoneNumberValue
                }
                
                if !ageValue.isEmpty {
                    updatedProfile?.age = ageValue
                }

                // Update profile via the ViewModel
                userViewModel.updateUserProfile(updatedUser: updatedProfile )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigateToProfileView = true
                }
                
            
                
            }) {
                Text("Save Changes")
                    .frame(width: UIScreen.main.bounds.width - 200)
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 20)
            
            
            
        }
        .padding(35)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 7)
        
        

        
    }

    private func detailRow(icon: String, title: String) -> some View {
        
            HStack {
                Image(systemName: icon).foregroundStyle(Color.cyan)
                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)
            }
            
        
    }
    
}

