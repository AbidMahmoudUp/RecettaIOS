//
//  RecipeGenerationLoadingViewUI.swift
//  Recetta
//
//  Created by wicked on 04.12.24.
//

import SwiftUI

struct RecipeGenerationLoadingView: View {
    @Binding var progress: Float // Progress value
    @Binding var isLoading: Bool // Controls the visibility of the loading screen
    @State private var currentPage = 0 // For tracking the current page in the pager
    private let images = ["image1", "image2", "image3", "image4"] // Replace with your image names

    var body: some View {
        ZStack {
            // Swiping Images (Horizontal Pager)
            TabView(selection: $currentPage) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index) // Tag for tracking the current page
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame()
            .onAppear {
                // Automatic swipe
                startAutoSwipe()
            }

            // Progress Indicator and Text
            VStack {
                Spacer()
                Text("Loading Recipes...")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200)
                    .tint(.yellow)
                    .padding(.bottom, 16)
            }
        }
        .background(Color.black.opacity(0.8))
        .edgesIgnoringSafeArea(.all)
        .opacity(isLoading ? 1 : 0) // Show only when loading
        .animation(.easeInOut, value: isLoading)
    }

    // Timer for auto-swiping images
    private func startAutoSwipe() {
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
            if !isLoading {  // Stop swiping if loading ends
                timer.invalidate()
            } else {
                currentPage = (currentPage + 1) % images.count
            }
        }
    }
}
