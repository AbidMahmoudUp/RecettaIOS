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
    
    var body : some View{
        
        VStack(spacing: 8){
            
            HStack{
                
                Text(self.isemail ? "Email ID" : self.reenter ? "Re-Enter" : "Password").foregroundColor(Color.black.opacity(0.3))
                
                Spacer()
            }
            
            
            
            HStack{
                
                if self.isemail{
                    
                    TextField("", text: self.$value)
                }
                else{
                    
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

