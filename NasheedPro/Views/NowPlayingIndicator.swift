//
//  NowPlayingIndicator.swift
//  NasheedPro
//
//  Created by Abdulboriy on 21/08/25.
//

import SwiftUI

//struct NowPlayingIndicator: View {
//    let isPlaying: Bool
//    
//    
//    @State private var barHeights: [CGFloat] = []
//    
//    var body: some View {
//        HStack(spacing: 2) {
//            ForEach(0..<5, id: \.self) { index in
//                Capsule()
//                    .fill(isPlaying ? Color.green : Color.secondary)
//                    .frame(width: 3,
//                           height: isPlaying ? barHeights[safe: index] ?? 4 : 4)
//            }
//        }
//        .onAppear {
//            setupBars()
//        }
//        .onChange(of: isPlaying) {_, newValue in
//            if newValue {
//                startAnimating()
//            }
//        }
//    }
//    
//    private func setupBars() {
//        barHeights = Array(repeating: 4, count: barCount)
//    }
//    
//    private func startAnimating() {
//        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { _ in
//            if isPlaying {
//                withAnimation(.easeInOut(duration: 0.25)) {
//                    barHeights = barHeights.map { _ in CGFloat.random(in: 4...20) }
//                }
//            } else {
//                withAnimation(.easeOut) {
//                    barHeights = Array(repeating: 4, count: barCount)
//                }
//            }
//        }
//    }
//}

import SwiftUI

struct NowPlayingIndicator: View {
    var isPlaying: Bool
    let barCount = 4
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<barCount, id: \.self) { _ in
                BarView(isPlaying: isPlaying)
            }
        }
        .frame(height: 20)
    }
}

struct BarView: View {
    var isPlaying: Bool
    
    @State private var height: CGFloat = 2
    
    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: 3, height: height)
            .onAppear {
                startAnimating()
            }
            .onChange(of: isPlaying) {_, _ in
                if !isPlaying {
                    withAnimation(.easeOut(duration: 0.2)) {
                        height = 0 // paused → "nil"
                    }
                } else {
                    startAnimating()
                }
            }
    }
    
    private func startAnimating() {
        guard isPlaying else { return }
        let newHeight = CGFloat.random(in: 5...20)
        withAnimation(.easeInOut(duration: Double.random(in: 0.2...0.4))) {
            height = newHeight
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.2...0.4)) {
            startAnimating() // repeat
        }
    }
}

#Preview {
    VStack {
        NowPlayingIndicator(isPlaying: true)
        NowPlayingIndicator(isPlaying: false)
    }
    .padding()
}

