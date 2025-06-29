//
//  OnlineView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct OnlineView: View {
    
    @EnvironmentObject private var viewmodel: NasheedViewModel
    @State var text: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
           listView
            
        }
        .background(Color.red)
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
                        .padding(.trailing, 20)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
        }
    }
}
