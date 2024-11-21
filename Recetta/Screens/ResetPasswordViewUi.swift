//
//  ResetPasswordViewUi.swift
//  Recetta
//
//  Created by wicked on 14.11.24.
//

import SwiftUI

struct ResetPasswordViewUI: View {
    @State var userIdByOTP: String
    @State var confirmePass = ""
    @State var pass = ""
    @State var show = false
    @State private var navigateToLoginView = false
    @StateObject var userViewModel = UserViewModel()

    
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
                        Text("Reset Password").font(.title).fontWeight(.bold)
                        Text("").fontWeight(.bold)
                        
                        CustomTFComponent(value: self.$pass, isemail: false)
                        CustomTFComponent(value: self.$confirmePass, isConfirmPassword: true)
                        
                       
                        Button(action: {
                            userViewModel.userIdByOTP = userIdByOTP
                            userViewModel.newPassword = pass
                            userViewModel.resetPassword()
                            self.navigateToLoginView = true // Trigger navigation to ContentView
                        }) {
                            Text("Reset Password")
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
            }
            // Navigation destination to RegisterViewUI
           
            // Navigation destination to ContentView when
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginScreenViewUI().navigationBarBackButtonHidden()
            }
          
        }
    }
}

#Preview {
    ResetPasswordViewUI(userIdByOTP: "")
}
