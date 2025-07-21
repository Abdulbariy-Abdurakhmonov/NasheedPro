//
//  OnlineView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI
import MinimizableView

struct OnlineView: View {
    
    @EnvironmentObject private var viewModel: NasheedViewModel
    @Binding var selectedNasheed: NasheedModel?

        
    
    var body: some View {
        
        ListVIew(
            title: "Streaming",
            emptyMessage: "No saved nasheeds yet.",
            emptyIcon: "wifi.slash",
            emptyDescription: "Be online to discover nasheed",
            nasheedsOf: viewModel.filteredNasheeds,
            selectedNasheed: $selectedNasheed)
        
        .onAppear {
            viewModel.currentScope = .all
        }
        
    }
}



#Preview {
    NavigationStack {
        OnlineView(selectedNasheed: .constant(.none))
            .preferredColorScheme(.light)
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
}



