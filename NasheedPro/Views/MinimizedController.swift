//
//  MinimizedController.swift
//  NasheedPro
//
//  Created by Abdulboriy on 12/07/25.
//

import Foundation
import SwiftUI

struct MinimizedController: View {
    
    @ObservedObject var player: AudioPlayerManager
    @EnvironmentObject var viewModel: NasheedViewModel
    
    
    var body: some View {
        HStack(spacing: 0){
            
            Spacer()
            
            Button(action: {
                guard let url = URL(string: viewModel.selectedNasheed?.audioURL ?? "") else { return }
//                AudioPlayerManager.shared.togglePlayPause(url: url)
                player.togglePlayPause(url: url)
                
            }, label: {
                ControllButton(icon: player.isPlaying ? "pause.fill" : "play.fill", size: 24, color: primary)

            })
            
            Button(action: {
                player.playNext()
            }, label: {
                ControllButton(icon: "forward.fill", size: 24, color: .primary)
            })
        }
        
    }
}
