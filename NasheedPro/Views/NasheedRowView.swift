//
//  NasheedRowView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct NasheedRowView: View {
    
//    @ObservedObject var nasheed: NasheedModel
    
    
    let nasheed: NasheedModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @EnvironmentObject var viewModel: NasheedViewModel
    
    
    var body: some View {
        
        HStack {
            ImageLoader(url: nasheed.imageURL)
                .dynamicImageSize(base: 45)
                .cornerRadius(36)
                .padding(.trailing, 10)

            
            VStack(alignment: .leading) {
                Text(nasheed.title)
                    .scaledFont(name: "Rounded", size: 22)
                    .fontDesign(.serif)
                    
                               
                Text(nasheed.reciter)
                    .scaledFont(name: "Serif", size: 17.5)
                    .fontDesign(.serif)
                    .foregroundStyle(.secondary)
        
            }
                       
            Spacer()
            
            if viewModel.selectedNasheed?.id == nasheed.id {
                NowPlayingIndicator(isPlaying: AudioPlayerManager().isPlaying)
                    .frame(height: 20)
            }
                
            
            DownloadButtonView(
                state: viewModel.stateFor(nasheed),
                action: { viewModel.downloadNasheed(nasheed) }
            )


                
                
        }
        .dynamicTypeSize(.xSmall ... .accessibility1)
        

    }
}

#Preview {
    NasheedRowView(nasheed: dev.mockData)
        .environmentObject(NasheedViewModel())
}
