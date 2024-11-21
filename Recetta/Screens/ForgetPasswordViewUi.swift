//
//  ForgetPasswordViewUi.swift
//  Recetta
//
//  Created by wicked on 14.11.24.
//

import SwiftUI

struct ForgetPasswordViewUi: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var userViewModel = UserViewModel()
    @State var agree = false
    @State var isValidationCodeSent = false
    @State private var navigateToResetPasswordView = false
    @Binding var show: Bool
    
    var body: some View {
        NavigationStack {  // Wrap the entire view in a NavigationStack
            ZStack(alignment: .topLeading) {
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
                        Text("Forget Password").font(.title).fontWeight(.bold)
                        Text("").fontWeight(.bold)
                        
                        if isValidationCodeSent {
                            // Validation code field (shown after email is validated)
                            CustomTFComponent(value: $userViewModel.OTPCode, isemail: false, isValidationCode: true)
                                .onChange(of: userViewModel.OTPCode) {
                                    newValue in
                                    print(userViewModel.VerifyOTPCode,newValue)
                                    if newValue == userViewModel.VerifyOTPCode {
                                        navigateToResetPasswordView = true
                                    }
                                }
                        } else {
                            // Email input field (shown initially)
                            CustomTFComponent(value: $userViewModel.email, isemail: true)
                        }
                        
                        HStack {
                            Button(action: {
                                agree.toggle()
                            }) { }
                           
                            Spacer()
                        }
                        
                        Button(action: {
                            if !isValidationCodeSent && isValidEmail(userViewModel.email) {
                                // Only switch to validation code field if email is valid
                                isValidationCodeSent = true
                                userViewModel.verifyEmail()
                            }
                        }) {
                            Text(isValidationCodeSent ? "Verify Code" : "Send Email")
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding()
                    
                    Spacer(minLength: 0)
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color("Color").edgesIgnoringSafeArea(.all))
                
                // Back Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismisses the view
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 18, height: 15)
                        .foregroundColor(.black)
                }
                .padding()
                .offset(x:0, y:20)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $navigateToResetPasswordView) {
                ResetPasswordViewUI(userIdByOTP: userViewModel.userIdByOTP).navigationBarBackButtonHidden()
            }
        }
    }
}

private func isValidEmail(_ email: String) -> Bool {
    // Basic email validation
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: email)
}

#Preview {
    ForgetPasswordViewUi(show: .constant(true))
}

