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
    @Binding var selectedNasheed: NasheedModel?
    
    
    var icon: String {
        if #available(iOS 16, *) {
            "bookmark.slash.fill"
        } else {
            "bookmark.fill"
        }
        
    }
    
    var body: some View {
        
        NavigationStack {
            ListVIew(
                title: "Downloads",
                emptyMessage: "No downloaded nasheed yet.",
                emptyIcon: icon,
                emptyDescription: "Download a nasheed to see it here.",
                nasheedsOf: Array(viewModel.filteredNasheeds),
                
                onDelete: viewModel.deleteDownloaded,
                selectedNasheed: $selectedNasheed
                
            )
        }
   
        .onAppear { viewModel.currentScope = .downloaded }
        
    }
}

#Preview {
    NavigationStack {
        DownloadedView(selectedNasheed: .constant(.none))
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
}



    

