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
        HStack(spacing: 12){
            
            Spacer()
            
            Button { guard let url = URL(string: viewModel.selectedNasheed?.audioURL ?? "") else { return }
                player.togglePlayPause(url: url)
            } label: { AnimatedPlayPause(isPlaying: $player.isPlaying, size: 23)}
                .contentShape(Rectangle())
                

            Button {
                player.playNext()
                
            } label: {ControllButton(icon: "forward.fill", size: 22, color: player.disabledNextColor())}
                .disabled(player.isNextDisabled())
                .buttonStyle(ScaleButtonStyle())
                
        }
        .padding(.trailing, 5)
        
    }
}
