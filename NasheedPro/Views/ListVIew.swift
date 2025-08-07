//
//  ListVIew.swift
//  NasheedPro
//
//  Created by Abdulboriy on 18/07/25.
//

import SwiftUI
import MinimizableView

struct ListVIew: View {
    let title: String
    let emptyMessage: String
    let emptyIcon: String
    let emptyDescription: String
    let nasheedsOf: [NasheedModel]
    
    
    
    @EnvironmentObject private var viewModel: NasheedViewModel
    @EnvironmentObject private var miniHandler: MinimizableViewHandler
    @State private var showDetailView: Bool = false
    @Binding var selectedNasheed: NasheedModel?
    @Namespace var namespace
    
    
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            withAnimation(.spring(duration: 0.4)) {
                conditionalViews
            }
            
        }
    }
}



#Preview {
    NavigationStack {
        dev.mockList
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
}


extension ListVIew {
    
    private var searchToolBar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Button("Search by Reciter Name") {
                    viewModel.searchMode = .reciter }
                Button("Search by Nasheed Name") {
                    viewModel.searchMode = .title }
            } label: {
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text(viewModel.searchMode == .reciter ? "Reciter" : "Nasheed")
                }
                .font(.subheadline)
            }
        }
        
    }
    
    private var listParts: some View {
        withAnimation(.spring(duration: 0.3)) {
            List {
                ForEach(nasheedsOf) { nasheed in
                    NasheedRowView(nasheed: nasheed)
                    
                        .onTapGesture {
                            
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            
                            DispatchQueue.main.async {
                                viewModel.selectedNasheed = nasheed
                                
                                
                                if let index = nasheedsOf.firstIndex(where: { $0.id == nasheed.id }) {
                                    AudioPlayerManager.shared.loadAndPlay(nasheeds: nasheedsOf, index: index)
                                    AudioPlayerManager.shared.onNasheedChange  = { newNasheed in
                                        withAnimation(.spring()) {
                                            viewModel.selectedNasheed = newNasheed
                                            AudioPlayerManager.shared.isRepeatEnabled = false
                                        }
                                    }
                                    
                                    withAnimation(.spring) {
                                        if self.miniHandler.isPresented {
                                            self.miniHandler.expand()
                                        } else {
                                            self.miniHandler.present()
                                        }
                                    }
                                }
                            }
                            
                        }
                        .padding(.trailing, 20)
                        .listRowBackground(Color.clear)
                }
                .listSectionSeparator(.hidden, edges: .all)
            }
            .transition(.opacity)
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .safeAreaInset(edge: .bottom) {
                Color.clear
                    .frame(height: miniHandler.isMinimized ? 68 : 0)
            }
        }
        .navigationTitle(title)
        .toolbarTitleDisplayMode(.inline)
    }
    
    private var conditionalViews: some View {
        
        NavigationStack {
            VStack {
                if viewModel.baseNasheeds.isEmpty {
                    withAnimation(.spring(duration: 0.3)) {
                        contentUnavailableView()
                        .transition(.opacity)}
                } else if viewModel.filteredNasheeds.isEmpty && !viewModel.searchText.isEmpty {
                    UnavailableView(searchResult: viewModel.searchText)
                } else {
                    listParts
                }
            }
            
            .toolbar {
                searchToolBar
            }
            .searchable(text: $viewModel.searchText,
                        prompt: viewModel.searchMode ==
                .reciter ? "Search a reciter..." :  "Search a nasheed...")
            .disabled(viewModel.baseNasheeds.isEmpty)
        }
        
    }
    
    func contentUnavailableView() -> some View {
        ContentUnavailableView {
            Label(emptyMessage, systemImage: emptyIcon)
        } description: {
            Text(emptyDescription)
        }
        
    }
    
}
