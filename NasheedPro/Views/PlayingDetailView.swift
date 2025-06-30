//
//  PlayingDetailView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI

struct PlayingDetailView: View {
    
    @EnvironmentObject var viewModel: NasheedViewModel
    var nasheed: NasheedModel
    @State var isPlaying: Bool = false
    
    var body: some View {
        VStack(spacing: 30) {
            Image("nasheedImage")
                .resizable()
                .frame(width: 300, height: 300)
                .clipShape(.rect(cornerRadius: 20))
                .shadow(radius: 4)
            
            VStack(alignment: .center, spacing: 12) {
                Text(nasheed.nasheedName)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                
                Text(nasheed.reciter)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 25)
            
            PlayControllerView(isPlaying: $isPlaying, nasheed: nasheed)
                
        }
    }
    
}


#Preview {
    NavigationStack {
        PlayingDetailView(nasheed: dev.mockData)
    }
    .environmentObject(dev.nasheedVM)
        
}
