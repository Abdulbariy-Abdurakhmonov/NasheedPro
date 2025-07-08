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
        .searchable(text: $viewModel.searchText, prompt: "Find Nasheed...")
        .navigationTitle("All Nasheeds")
        .toolbarTitleDisplayMode(.inline)
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





    
    

