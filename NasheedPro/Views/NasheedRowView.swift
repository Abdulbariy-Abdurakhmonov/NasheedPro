//
//  NasheedRowView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct NasheedRowView: View {
    
    
    let nasheed: NasheedModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @EnvironmentObject var viewModel: NasheedViewModel
    @ObservedObject var audioPlayer = AudioPlayerManager.shared
    
    
    var body: some View {
        
        HStack {
            ImageLoader(url: nasheed.imageURL)
                .dynamicImageSize(base: 45)
                .cornerRadius(36)
                .padding(.trailing, 10)

            
            VStack(alignment: .leading) {
                Text(nasheed.title)
                    .foregroundStyle(.primary)
                    .scaledFont(name: "Rounded", size: 22)
                    .fontDesign(.serif)
                    
                               
                Text(nasheed.reciter)
                    .scaledFont(name: "Serif", size: 17.5)
                    .fontDesign(.serif)
                    .foregroundStyle(.secondary)
        
            }
                       
            Spacer()
      
            
            DownloadButtonView(
                state: viewModel.stateFor(nasheed),
                action: { viewModel.downloadNasheed(nasheed) }
            )
            
             
            NowPlayingIndicator(isPlaying: $audioPlayer.isPlaying, isPlayerReady: $audioPlayer.isPlayerReady)
                    .frame(height: 16)
                    .padding(.leading, 4)
                    .opacity(viewModel.selectedNasheed?.id == nasheed.id ? 1 : 0)
    
        }
        .dynamicTypeSize(.xSmall ... .accessibility1)
        

    }
}

#Preview {
    NasheedRowView(nasheed: dev.mockData)
        .environmentObject(NasheedViewModel())
}
