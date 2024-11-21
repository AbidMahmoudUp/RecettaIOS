import SwiftUI

struct RegisterViewUI: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var  userViewModel = UserViewModel()
    @State var user = ""
    @State var pass = ""
    @State var repass = ""
    @State var agree = false
    @Binding var show: Bool
    
    var body: some View {
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
                    Text("Hello").font(.title).fontWeight(.bold)
                    Text("Sign Into Your Account").fontWeight(.bold)
                    
                    CustomTFComponent(value: $userViewModel.username, isemail: true)
                    CustomTFComponent(value: $userViewModel.email, isemail: true)
                    CustomTFComponent(value: $userViewModel.password, isemail: false, reenter: true)
                    
                    HStack {
                        Button(action: {
                            agree.toggle()
                        }) {
                            ZStack {
                                Circle().fill(Color.black.opacity(0.05)).frame(width: 20, height: 20)
                                if agree {
                                    Image("check")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(Color("Color1"))
                                }
                            }
                        }
                        Text("I Read And Agree The Terms And Conditions")
                            .font(.caption)
                            .foregroundColor(Color.black.opacity(0.3))
                        Spacer()
                    }
                    
                    Button(action: {
                        userViewModel.signUp()
                    }) {
                        Text("Register Now")
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .padding(.vertical)
                            .foregroundColor(.white)
                    }
                    .background(Color("Color1"))
                    .clipShape(Capsule())
                    
                    Text("Or Register Using Social Media").fontWeight(.bold)
                    SocialMediaComponent()
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
            .offset(x:0,y:20)
            
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#Preview {
    RegisterViewUI(show: .constant(true))
}

