//
//  PlatListView.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject var viewModel = RecipeViewModel()
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage).foregroundColor(.red)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 16) {
                    ForEach(viewModel.filteredRecipes) { plat in
                        RecipeCardUIViewComponent(plat: plat)
                            .frame(width: 200).padding(30)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchRecipes() // This will fetch the recipes when the view appears
            }
        }
    }
}


