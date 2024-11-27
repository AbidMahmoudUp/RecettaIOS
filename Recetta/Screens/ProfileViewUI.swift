import SwiftUI

struct ProfileViewUI: View {
    @StateObject var  userViewModel = UserViewModel()
//    @State private var userNameTfShow = false
    @State private var EmailTfShow = false
    @State private var editState = false
    @State private var phoneNumberTfShow = false
    @State var PasswordValue = ""
    @State private var PasswordTfShow = false
   
     private var userNameTfShow = false
     @State private var emailValue = ""
     private var oldPasswordValue = ""
     private var newPasswordValue = ""
     @State private var phoneNumberValue = ""

    
    var body: some View {
        
        
        
        
        VStack(spacing: 8) {
            // Header Section
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.orange]),
                    startPoint: .topTrailing,
                    endPoint: .bottomLeading
                )
                .frame(height: 200) // Adjust height as per design
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
                                .stroke(Color.white, lineWidth: 4) // White border around the image
                        )
                        .shadow(radius: 10) // Adds a subtle shadow
                        .padding(.top, 50)
                }
            }
            if editState {
                HStack{
                    Text("User Name")
                        .font(
                            .system(
                                size: 24,
                                weight: .semibold,
                                design: .default
                            )
                        )
                        .foregroundColor(.black)
                        .padding(5)
                 
                    Image(systemName: "square.and.pencil")
                }
            }else
            {
                Text("User Name")
                    .font(
                        .system(
                            size: 24,
                            weight: .semibold,
                            design: .default
                        )
                    )
                    .foregroundColor(.black)
                    .padding(5)
                
            }
            
            Text("Edit")
                .font(
                    .system(
                        size: 20,
                        weight: .bold,
                        design: .default
                    )
                )
                .foregroundColor(.cyan)
                .onTapGesture {
                    editState.toggle()
                }.padding(5)
            // User Details Section
            
            if (!editState){
                
            
            VStack(spacing: 30 ) {
               
                VStack{
                HStack{
                    
                    Image(systemName: "envelope").foregroundStyle(Color.cyan)
                    Text("Email")
                        .font(
                            .system(
                                size: 24,
                                weight: .semibold,
                                design: .default
                            )
                        )
                        .foregroundColor(.black)
                        .padding(.trailing , 138)
                }
                Text("mou3ez@gmail.com")
                    .font(
                        .system(
                            size: 18,
                            design: .default
                        )
                    )
                    .foregroundColor(.black)
                    .padding(.trailing , 20)
                
            }
                
               
                VStack{
                HStack{
                    
                    Image(systemName: "iphone.gen2").foregroundStyle(Color.cyan)
                    Text("Mobile number")
                        .font(
                            .system(
                                size: 24,
                                weight: .semibold,
                                design: .default
                            )
                        )
                        .foregroundColor(.black)
                        .padding(.trailing , 38)
                    
                }
                .padding(.horizontal , -70)
                Text("+216 55623147")
                    .font(
                        .system(
                            size: 18,
                            design: .default
                        )
                    )
                    .foregroundColor(.black)
                    .padding(.trailing , 40)
                
            }
                
                VStack{
                    HStack{
                        
                        Image(systemName: "person.badge.key").foregroundStyle(Color.cyan)
                        Text("Role")
                            .font(
                                .system(
                                    size: 24,
                                    weight: .semibold,
                                    design: .default
                                )
                            )
                            .foregroundColor(.black)
                            .padding(.trailing , 150)
                        
                    }
                    Text("my Role")
                        .font(
                            .system(
                                size: 18,
                                design: .default
                            )
                        )
                        .foregroundColor(.black)
                        .padding(.trailing , 80)
                    
                }
                //if PasswordTfShow {
                 //   SecureField("password",text: $PasswordValue).frame(width: 250, height: 70, alignment: Alignment.center)
               //
                //}
                
                Button(action: {
                        
                         // Trigger navigation to ContentView
                }) {
                    Text("Sign out")
                        .frame(width: UIScreen.main.bounds.width - 200)
                        .padding(.vertical, 15)
                        .foregroundColor(.white)
                }
                .background(Color("Color1"))
                .clipShape(Capsule())
                .padding(.top,20)
                .padding(.bottom,5)
                
            }
            .padding(50)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 7)
            // .padding(.horizontal, 16)
             
                    
                }else
            {
                    
                    VStack(spacing: 30 ) {
                       
                        VStack{
                        HStack{
                            
                            Image(systemName: "envelope").foregroundStyle(Color.cyan)
                            Text("Email")
                                .font(
                                    .system(
                                        size: 24,
                                        weight: .semibold,
                                        design: .default
                                    )
                                )
                                .onTapGesture {
                                    EmailTfShow.toggle()
                                }
                                .foregroundColor(.black)
                                .padding(.trailing , 138)
                        }
                            if EmailTfShow {
                                TextField("example@gmail.com",text: $emailValue).frame(width: 200, height: 60, alignment: Alignment.center)
                                }
                        
                    }
                        
                       
                        VStack{
                        HStack{
                            
                            Image(systemName: "iphone.gen2").foregroundStyle(Color.cyan)
                            Text("Mobile number")
                                .font(
                                    .system(
                                        size: 24,
                                        weight: .semibold,
                                        design: .default
                                    )
                                )
                                .onTapGesture {
                                    phoneNumberTfShow.toggle()
                                }
                                .foregroundColor(.black)
                                .padding(.trailing , 38)
                            
                        }
                        .padding(.horizontal , -70)
                            if phoneNumberTfShow {
                                TextField("phone number",text: $phoneNumberValue).frame(width: 200, height: 60, alignment: Alignment.center)
                                }
                        
                    }
                        
                        VStack{
                            HStack{
                                
                                Image(systemName: "person.badge.key").foregroundStyle(Color.cyan)
                                Text("Password")
                                    .font(
                                        .system(
                                            size: 24,
                                            weight: .semibold,
                                            design: .default
                                        )
                                    )
                                    .onTapGesture {
                                        PasswordTfShow.toggle()
                                    }
                                    .foregroundColor(.black)
                                    .padding(.trailing , 100)
                                
                            }
                            if PasswordTfShow {
                                SecureField("old password",text: $PasswordValue).frame(width: 200, height: 70, alignment: Alignment.center)
                                SecureField("new password",text: $PasswordValue).frame(width: 200, height: 70, alignment: Alignment.center)
                           
                                    }
                            
                        }
                        
                  

                        
                    }
                    .padding(35)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 7)
                    
                }
           
        }
        
    }
}

#Preview {
    ProfileViewUI( )
}
