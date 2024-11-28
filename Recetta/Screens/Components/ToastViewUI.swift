//
//  ToastViewUI.swift
//  Recetta
//
//  Created by wicked on 28.11.24.
//

import SwiftUI

struct ToastViewUI: View {
    let message: String
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
    }
}


#Preview {
    ToastViewUI(message: "test here")
}
