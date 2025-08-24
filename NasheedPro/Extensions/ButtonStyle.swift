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
               .frame(width: 65, height: 65) // 👈 make all buttons same size
               .background(
                   Circle()
                       .fill(configuration.isPressed ? Color.secondary.opacity(0.5) : Color.clear)
               )
               .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
               .animation(.spring(response: 0.5, dampingFraction: 0.6), value: configuration.isPressed)
       }
}


struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .scaleEffect(configuration.isPressed ? 0.7 : 1.0)
               .animation(.spring(response: 0.5, dampingFraction: 0.6), value: configuration.isPressed)
       }
}




struct AnimatedPlayPause: View {
    @Binding var isPlaying: Bool
    let size: CGFloat
    
    var body: some View {
        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
            .scaledFont(name: "", size: size)
            .foregroundStyle(Color.primary)
            .transition(.scale.combined(with: .opacity)) 
            .id(isPlaying)
            .animation(.easeInOut(duration: 0.03), value: isPlaying)
    }
}
