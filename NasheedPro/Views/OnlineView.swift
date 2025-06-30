//
//  OnlineView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct OnlineView: View {
    
    @EnvironmentObject private var viewmodel: NasheedViewModel
    @State private var showDetailView: Bool = false
//    @State var selectedNasheed: NasheedModel? = nil
    
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
}



extension OnlineView {
    private var listView: some View {
        VStack {
            List {
                ForEach(viewmodel.nasheeds, id: \.nasheedName) { nasheed in
                    NasheedRowView(nasheed: nasheed)
                        .onTapGesture {
                            
                        }
                        .padding(.trailing, 20)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
        }
    }
    
}
