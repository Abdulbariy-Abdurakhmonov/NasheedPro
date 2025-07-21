//
//  LikedView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 03/07/25.
//

import SwiftUI
import MinimizableView

struct LikedView: View {
    
    @EnvironmentObject var viewModel: NasheedViewModel
    @Binding var selectedNasheed: NasheedModel?
    
    var body: some View {
        
        ListVIew(title: "My Favorites",
                 emptyMessage: "No liked nasheeds yet.",
                 emptyIcon: "heart.slash.fill",
                 emptyDescription: "Like a nasheed to see it here.",
                 nasheedsOf: viewModel.filteredNasheeds,
                 selectedNasheed: $selectedNasheed)
        .onAppear {
            viewModel.currentScope = .liked
        }
    }
        
}




#Preview {
    NavigationStack {
        LikedView(selectedNasheed: .constant(.none))
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
}
