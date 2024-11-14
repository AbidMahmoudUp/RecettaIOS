//
//  SocialMediaComponent.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import SwiftUI

struct SocialMediaComponent: View {
    var body : some View{
        
        HStack(spacing: 40){
            
            Button(action: {
                
            }) {
                
                Image("fb").renderingMode(.original)
            }
            
            Button(action: {
                
            }) {
                
                Image("twitter").renderingMode(.original)
            }
        }
    }
}

#Preview {
    SocialMediaComponent()
}
