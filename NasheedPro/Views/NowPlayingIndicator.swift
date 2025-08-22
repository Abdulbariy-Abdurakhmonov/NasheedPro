//
//  NowPlayingIndicator.swift
//  NasheedPro
//
//  Created by Abdulboriy on 21/08/25.



import SwiftUI

struct NowPlayingIndicator: View {
    @Binding var isPlaying: Bool
    @Binding var isPlayerReady: Bool
    
    let barCount = 5
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<barCount, id: \.self) { index in
                BarView(isPlaying: $isPlaying,
                        isPlayerReady: $isPlayerReady,
                        index: index,
                        barCount: barCount)
            }
        }
        .frame(height: 16)
    }
}

struct BarView: View {
    @Binding var isPlaying: Bool
    @Binding var isPlayerReady: Bool
    
    let index: Int
    let barCount: Int
    
    @State private var height: CGFloat = 2.5
    @State private var offsetY: CGFloat = 0.0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.accentColor)
            .frame(width: 2, height: height)
            .offset(y: offsetY)
            .onAppear { updateAnimation() }
            .onChange(of: isPlaying) { _, _ in updateAnimation() }
            .onChange(of: isPlayerReady) { _, _ in updateAnimation() }
    }
    
    private func updateAnimation() {
        if !isPlayerReady {
            startLoadingBounce()
        } else if isPlaying {
            startPlayingAnimation()
        } else {
            stopAll()
        }
    }

    private func startLoadingBounce() {
        height = 2.5
        let delay = Double(index) * 0.1
        withAnimation(
            .easeInOut(duration: 0.4)
                .repeatForever(autoreverses: true)
                .delay(delay)
        ) {
            offsetY = -5 // bounce up
        }
    }
    
    private func startPlayingAnimation() {
        offsetY = 0
        animateHeights()
    }
    
    private func animateHeights() {
        guard isPlaying, isPlayerReady else { return }
        
        let range: ClosedRange<CGFloat> = (index == 0 || index == barCount-1) ? 2...5 : 2...16
        let newHeight = CGFloat.random(in: range)
        
        withAnimation(.easeInOut(duration: 0.3)) {
            height = newHeight
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateHeights()
        }
    }
    
    private func stopAll() {
        withAnimation(.easeOut(duration: 0.2)) {
            height = 2.5
            offsetY = 0
        }
    }
}


#Preview {
    HStack {
        NowPlayingIndicator(isPlaying: .constant(true), isPlayerReady: .constant(true))
//        NowPlayingIndicator(isPlaying: .constant(false))
            
    }
    
}

