//
//  OnlineView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI
import MinimizableView

struct OnlineView: View {
    
    @EnvironmentObject private var viewmodel: NasheedViewModel
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @State private var showDetailView: Bool = false
    @State var selectedNasheed: NasheedModel? = nil
    
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
           listView
            
        }
        .navigationTitle("All Nasheeds")
        .toolbarTitleDisplayMode(.inline)
        
    }
    
}


#Preview {
    NavigationStack {
        OnlineView()
            .preferredColorScheme(.light)
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
    
}




extension OnlineView {
    private var listView: some View {
        @Namespace var namespace
        return VStack {
            List {
                ForEach(viewmodel.nasheeds) { nasheed in
                    
                    NasheedRowView(nasheed: nasheed)
                    
                        .onTapGesture {
                            selectedNasheed = nasheed
                        }
                        .padding(.trailing, 20)
                        .listRowBackground(Color.clear)
                }
            }

            .listStyle(.plain)
            
        }
        .fullScreenCover(item: $selectedNasheed) { nasheed in
            PlayingDetailView(viewModel: _viewmodel, nasheed: nasheed, animationNamespaceId: namespace)
        }
    }
    
}
