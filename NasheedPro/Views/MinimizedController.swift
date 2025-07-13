//
//  MinimizedController.swift
//  NasheedPro
//
//  Created by Abdulboriy on 12/07/25.
//

import Foundation
import SwiftUI

struct MinimizedController: View {
    
    let nasheed: NasheedModel
//    @Binding var isPlaying: Bool
    @ObservedObject var player: AudioPlayerManager
    
    var body: some View {
        HStack(spacing: 0){
            
            Spacer()
            
            Button(action: {
                guard let url = URL(string: nasheed.audio) else { return }
                AudioPlayerManager.shared.togglePlayPause(url: url)
                
            }, label: {
                ControllButton(icon: player.isPlaying ? "pause.fill" : "play.fill", size: 28)

            })
            
            Button(action: {}, label: {
                
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            })
        }
        
    }
}
