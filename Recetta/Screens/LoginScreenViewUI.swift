import SwiftUI

struct LoginScreenViewUI: View {
    @State var user = ""
    @State var pass = ""
    @State var show = false
    @State private var navigateToContentView = false // New state variable for ContentView navigation
    
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
                        Text("Hello").font(.title).fontWeight(.bold)
                        Text("Sign Into Your Account").fontWeight(.bold)
                        
                        CustomTFComponent(value: self.$user, isemail: true)
                        CustomTFComponent(value: self.$pass, isemail: false)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                // Forgot password action
                            }) {
                                Text("Forget Password ?")
                                    .foregroundColor(Color.black.opacity(0.3))
                            }
                        }
                        
                        Button(action: {
                            self.navigateToContentView = true // Trigger navigation to ContentView
                        }) {
                            Text("Login")
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .padding(.vertical)
                                .foregroundColor(.white)
                        }
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                        
                        Text("Or Login Using Social Media").fontWeight(.bold)
                        SocialMediaComponent()
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding()
                    
                    HStack {
                        Text("Don't Have an Account ?")
                        Button(action: {
                            self.show.toggle()
                        }) {
                            Text("Register Now")
                                .foregroundColor(Color("Color1"))
                        }
                    }
                    .padding(.top)
                    
                    Spacer(minLength: 0)
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color("Color").edgesIgnoringSafeArea(.all))
            }
            // Navigation destination to RegisterViewUI
            .navigationDestination(isPresented: $show) {
                RegisterViewUI(show: self.$show)
            }
            // Navigation destination to ContentView when
            .navigationDestination(isPresented: $navigateToContentView) {
                ContentView().navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    LoginScreenViewUI()
}
