//
//  CostumTFComponent.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import SwiftUI

struct CustomTFComponent: View {
    @Binding var value : String
    var isemail = false
    var reenter = false
    var isValidationCode = false
    var isConfirmPassword = false
    var body : some View{
        
        VStack(spacing: 8){
            
            HStack {
                Text(self.isemail ? "Email ID" : self.reenter ? "Re-Enter" : isValidationCode ? "Validation Code" : isConfirmPassword ? "Confirm Password" : "Password")
                               .foregroundColor(Color.black.opacity(0.3))
                           Spacer()
                       }
            
            
            
            HStack{
                
                if self.isemail{
                    
                    TextField("", text: self.$value)
                }
                else if isValidationCode {
                                    TextField("", text: self.$value)
                                        .keyboardType(.numberPad)
                                        .onChange(of: value){ newValue in
                                            // Restrict input to 6 digits and numbers only
                                            let filtered = newValue.filter { $0.isNumber }
                                            if filtered.count > 6 {
                                                value = String(filtered.prefix(6))
                                            } else {
                                                value = filtered
                                            }
                                        }
                                }
                else if isConfirmPassword || reenter {
                                    SecureField("", text: self.$value)
                                } else {
                                    SecureField("", text: self.$value)
                                }
                
                
                Button(action: {
                    
                }) {
                    
                    Image(systemName: self.isemail ? "envelope.fill" : "eye.slash.fill").foregroundColor(Color("Color1"))
                }
            }
            
            Divider()
        }
    }
}

