//
//  EditProfileViewUI.swift
//  Recetta
//
//  Created by wicked on 28.11.24.
//

import Foundation
import SwiftUI

struct EditProfileViewUI: View {
    @StateObject var userViewModel = UserViewModel()
    @State private var emailTfShow = false
    @State private var editState = false
    @State private var phoneNumberTfShow = false
    @State private var passwordValue = ""
    @State private var passwordTfShow = false
    @State private var navigateToLoginView = false
    @State private var emailValue = ""
    @State private var phoneNumberValue = ""

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

                    //Profile Image
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
                HStack {
                    Text("User Name")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.black)
                        .padding(5)

                    
                        Image(systemName: "square.and.pencil")
                    
                }

               

                // User Details Section
             
                    editableDetailsView()
                
            }
            .navigationDestination(isPresented: $navigateToLoginView) {
                LoginScreenViewUI().navigationBarBackButtonHidden()
            }
        }
    }


    private func editableDetailsView() -> some View {
        VStack(spacing: 30) {
            editableRow(icon: "envelope", title: "Email", value: $emailValue, show: $emailTfShow)
            editableRow(icon: "iphone.gen2", title: "Mobile number", value: $phoneNumberValue, show: $phoneNumberTfShow)

            VStack {
                HStack {
                    Image(systemName: "person.badge.key").foregroundStyle(Color.cyan)
                    Text("Password")
                        .font(.system(size: 24, weight: .semibold))
                        .onTapGesture {
                            passwordTfShow.toggle()
                        }
                        .foregroundColor(.black)
                        .padding(.trailing, 100)
                }

                if passwordTfShow {
                    SecureField("Old Password", text: $passwordValue)
                        .frame(width: 200, height: 40)
                    SecureField("New Password", text: $passwordValue)
                        .frame(width: 200, height: 40)
                }
            }
        }
        .padding(35)
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

#Preview {
    ProfileViewUI()
}
