//
//  CustomButton.swift
//  Recetta
//
//  Created by wicked on 13.11.24.
//

import SwiftUI

struct CustomButtonConfig {
    let title: String
    let action: () -> Void
    var titleColor: Color = .white
    var fontSize: CGFloat = 16
}

struct CustomButton: View {
    let config: CustomButtonConfig
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 57)
                .background {
                    LinearGradient(
                        stops: [
                            Gradient.Stop(color: .color2, location: 0.0),
                            Gradient.Stop(color: .color1, location: 1.0)
                        ],
                        startPoint: UnitPoint(x: 0, y: 0),
                        endPoint: UnitPoint(x: 1, y: 1)
                    )
                    .cornerRadius(15)
                }
            
            Text(config.title)
                .font(.system(size: config.fontSize, weight: .bold))
                .foregroundColor(config.titleColor)
        }
        .onTapGesture {
            config.action()
        }
    }
}

#Preview {
    CustomButton(config: .init(title: "Test", action: {
        
    }))
}
