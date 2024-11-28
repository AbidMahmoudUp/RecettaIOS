import SwiftUI

struct RegisterViewUI: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userViewModel = UserViewModel()
    @State private var navigateToLoginView = false
    @State var agree = false
    @Binding var show: Bool
    @State private var showToast = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Image("shape")
                    }

                    VStack {
                        Image("logo")
                        Image("name").padding(.top, 10)
                    }
                    .offset(y: -122)
                    .padding(.bottom, -132)

                    VStack(spacing: 20) {
                        Text("Create Your Account").fontWeight(.bold)

                        // Custom TextFields for Username, Email, and Password
                        CustomTFComponent(value: $userViewModel.username, isUserName: true)
                        CustomTFComponent(value: $userViewModel.email, isemail: true)
                        CustomTFComponent(value: $userViewModel.password, isemail: false, reenter: true)

                        // Error Toast
                        if showToast, let errorMessage = userViewModel.errorMessage {
                            ToastViewUI(message: errorMessage)
                        }

                        // Agreement Checkbox
                        HStack {
                            Button(action: {
                                agree.toggle()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.05))
                                        .frame(width: 20, height: 20)
                                    if agree {
                                        Image("check")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color("Color1"))
                                    }
                                }
                            }
                            Text("I agree to the Terms and Conditions")
                                .font(.caption)
                                .foregroundColor(Color.black.opacity(0.3))
                            Spacer()
                        }

                        // Register Button
                        Button(action: {
                            if validateForm() {
                                userViewModel.signUp()
                                if userViewModel.isSignedUp {
                                    navigateToLoginView = true
                                } else {
                                    showToastMessage(error: "This email is already in use.")
                                }
                            }
                        }) {
                            Text("Register Now")
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .background(Color("Color1"))
                        .clipShape(Capsule())

                        // Social Media Section
                        Text("Or Register Using Social Media").fontWeight(.bold)
                        SocialMediaComponent()
                    }
                    .padding([.leading, .trailing, .top], 16)
                    .background(Color.white)
                    .cornerRadius(5)

                    // Already Have an Account Section
                    HStack {
                        Text("Already have an account?")
                        Button(action: {
                            show.toggle()
                        }) {
                            Text("Sign In")
                                .foregroundColor(Color("Color1"))
                        }
                    }
                    .padding(.top, 10)

                    Spacer(minLength: 20)
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color("Color").edgesIgnoringSafeArea(.all))
            }
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginScreenViewUI().navigationBarBackButtonHidden()
            }
        }
    }

    private func validateForm() -> Bool {
        userViewModel.errorMessage = nil

        if userViewModel.username.isEmpty {
            showToastMessage(error: "Please enter a username.")
            return false
        }

        if !isValidEmail(userViewModel.email) {
            showToastMessage(error: "Please enter a valid email.")
            return false
        }

        if userViewModel.password.isEmpty {
            showToastMessage(error: "Please enter a password.")
            return false
        } else if userViewModel.password.count < 8 {
            showToastMessage(error: "Password must be at least 8 characters.")
            return false
        } else if !containsNumber(userViewModel.password) {
            showToastMessage(error: "Password must include at least one number.")
            return false
        }

        if !agree {
            showToastMessage(error: "You must agree to the terms and conditions.")
            return false
        }

        return true
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.)+[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    private func containsNumber(_ password: String) -> Bool {
        let numberRegex = ".*[0-9]+.*"
        return NSPredicate(format: "SELF MATCHES %@", numberRegex).evaluate(with: password)
    }

    private func showToastMessage(error: String) {
        withAnimation {
            userViewModel.errorMessage = error
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showToast = false
                userViewModel.errorMessage = nil
            }
        }
    }
}

#Preview {
    RegisterViewUI(show: .constant(true))
}
