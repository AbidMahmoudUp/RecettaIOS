//
//  PlatListView.swift
//  Recetta
//
//  Created by wicked on 10.11.24.
//

import SwiftUI

struct PlatListView: View {
    @ObservedObject var viewModel = PlatViewModel()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment : .center,spacing: 16) {
                ForEach(viewModel.plats) { plat in
                    PlatCardUIViewComponent(plat: plat)
                        .frame(width: 200).padding(30)
                }
            }
            .padding()
        }
    }
}
