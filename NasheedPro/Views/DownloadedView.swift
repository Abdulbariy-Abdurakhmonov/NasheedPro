//
//  DownloadedView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 03/07/25.
//

import SwiftUI
import MinimizableView

struct DownloadedView: View {
    
    @EnvironmentObject private var viewModel: NasheedViewModel
//    @ObservedObject var downloadedVM: DownloadedNasheedViewModel
    @Binding var selectedNasheed: NasheedModel?
    
    var body: some View {
        
        ListVIew(title: "Downloaded Nasheeds",
                 emptyMessage: "No downloaded nasheed yet.",
                 emptyIcon: "bookmark.slash.fill",
                 emptyDescription: "Download a nasheed to see it here.",
                 nasheedsOf: viewModel.filteredNasheeds,
                 selectedNasheed: $selectedNasheed)
        .onAppear {
            viewModel.currentScope = .downloaded
        }
    }
        
}




#Preview {
    NavigationStack {
        DownloadedView(selectedNasheed: .constant(.none))
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
}
