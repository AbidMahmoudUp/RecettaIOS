import SwiftUI
import LocalAuthentication

struct LoginScreenViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State var showToast = false
    @State var user = ""
    @State var pass = ""
    @State var show = false
    @State private var navigateToContentView = false
    @State private var navigateToForgetPasswordView = false
    @State private var isUnlocked = false
    @State private var isOn = false

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
                        Text("Sign Into Your Account").fontWeight(.bold)

                        // Custom TextFields for Email and Password
                        CustomTFComponent(value: $userViewModel.email, isemail: true)
                        CustomTFComponent(value: $userViewModel.password, isemail: false)

                        HStack {
                            Spacer()
                            Button(action: {
                                self.navigateToForgetPasswordView = true
                            }) {
                                Text("Forget Password?")
                                    .foregroundColor(Color.black.opacity(0.3))
                            }
                        }

                        HStack {
                            Toggle(isOn: $isOn) {
                                Text("Remember me")
                            }
                            .toggleStyle(.automatic)
                            Spacer()
                        }

                        Button(action: {
                            userViewModel.signin { success in
                                if success {
                                    if isOn {
                                        UserDefaults.standard.set(true, forKey: "remember")
                                    }
                                    self.navigateToContentView = true
                                } else if let error = userViewModel.errorMessage {
                                    showToastMessage(error: error)
                                }
                            }
                        }) {
                            Text("Login")
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .background(Color("Color1"))
                        .clipShape(Capsule())


                        // Face ID Button
                       /*
                        Button(action: {
                            authenticate()
                        }) {
                            Image(systemName: "faceid")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(.top)
                        }*/

                        Text("Or Login Using Social Media").fontWeight(.bold)
                        SocialMediaComponent()
                    }
                    .padding([.leading, .trailing, .top], 16) // Adjust padding to make space for bottom elements
                    .background(Color.white)
                    .cornerRadius(5)

                    // Adjust bottom HStack for "Register Now"
                    HStack {
                        Text("Don't Have an Account?")
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Text("Register Now")
                                .foregroundColor(Color("Color1"))
                        }
                    }
                    .padding(.top, 10)  // Added top padding for "Register Now"

                    Spacer(minLength: 20)  // Add controlled space below to prevent elements from going too low
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color("Color").edgesIgnoringSafeArea(.all))

                // Show Toast for Error Messages
                if showToast, let errorMessage = userViewModel.errorMessage {
                    VStack {
                        Spacer()
                        ToastViewUI(message: errorMessage)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut)
                        Spacer()
                    }
                }
            }
            .onAppear {
                // Check if "remember" is true and navigate to ContentView
                if let remember = UserDefaults.standard.value(forKey: "remember") as? Bool, remember {
                    self.navigateToContentView = true
                }
            }
            .navigationDestination(isPresented: $show) {
                RegisterViewUI(show: self.$show).navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView().navigationBarBackButtonHidden()
            }
            .navigationDestination(isPresented: $navigateToForgetPasswordView) {
                ForgetPasswordViewUi(show: self.$navigateToForgetPasswordView)
            }
        }
    }

    /*   func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        userViewModel.email = "mahmoudabid@gmail.com"
                        userViewModel.password = "mahmoud123456"
                        userViewModel.signin()

                        if userViewModel.isLoggedIn {
                            self.navigateToContentView = true
                        } else {
                            showToastMessage(error: "Authentication Failed")
                        }
                    } else {
                        showToastMessage(error: "Biometric Authentication Failed")
                    }
                }
            }
        } else {
            showToastMessage(error: "Biometric Authentication Not Available")
        }
    }*/

    private func showToastMessage(error: String) {
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                showToast = false
                userViewModel.errorMessage = nil
            }
        }
    }
}

#Preview {
    LoginScreenViewUI()
}
