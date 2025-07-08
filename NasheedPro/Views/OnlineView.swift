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
    @EnvironmentObject private var miniHandler: MinimizableViewHandler
    @State private var showDetailView: Bool = false
    @Binding var selectedNasheed: NasheedModel?
    @Namespace var namespace

    
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
           listView
            
        }
        .toolbar {
            searchToolBar
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




extension OnlineView {
    
    private var searchToolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button("Search by Reciter Name") {
                    viewModel.searchMode = .reciter }
                Button("Search by Nasheed Name") {
                    viewModel.searchMode = .nasheed }
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text(viewModel.searchMode == .reciter ? "Reciter" : "Nasheed")
                }
                .font(.subheadline)
            }
        }
    }
    
    
    private var listView: some View {
        VStack {
            List {
                ForEach(viewModel.filteredNasheeds) { nasheed in
                    
                    NasheedRowView(nasheed: nasheed)
                    
                        .onTapGesture {
                            withAnimation(.spring){
                                selectedNasheed = nasheed
                                if self.miniHandler.isPresented {
                                    self.miniHandler.expand()
                                } else {
                                    self.miniHandler.present()
                                }
                            }
                           
                            
                        }
                        .padding(.trailing, 20)
                        .listRowBackground(Color.clear)
                }
                .listSectionSeparator(.hidden, edges: .all)
                
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            
        }
         .searchable(text: $viewModel.searchText,
                     prompt: viewModel.searchMode ==
            .reciter ? "Search a reciter..." :  "Search a nasheed...")
         .navigationTitle("All Nasheeds")
         .toolbarTitleDisplayMode(.inline)

    }
}

    
    

