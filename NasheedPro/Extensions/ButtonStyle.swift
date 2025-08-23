//
//  ButtonStyle.swift
//  NasheedPro
//
//  Created by Abdulboriy on 23/08/25.
//

import Foundation
import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
         configuration.label
             .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
             .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
     }
}


struct AnimatedPlayPause: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            .scaledFont(name: "", size: 35)
            .foregroundStyle(Color.primary)
            .padding(.trailing)
            .transition(.scale.combined(with: .opacity)) 
            .id(isPlaying)
            .animation(.easeInOut(duration: 0.03), value: isPlaying)
    }
}
