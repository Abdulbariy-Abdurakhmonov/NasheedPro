//
//  PlayControllerViewModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import Foundation
import SwiftUI

class PlayControllerViewModel: ObservableObject {
    
    @Published var isPlaying: Bool = false
    @Published var timer: Timer?
    @Published var progress: Double = 0.0
    @Published var totalDuration: Double = 200 // Example: 200 seconds
    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func togglePlayback() {
        if isPlaying {
            timer?.invalidate() // Pause
        } else {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                if self.progress < self.totalDuration {
                    self.progress += 1
                } else {
                    self.timer?.invalidate() // Stop when song ends
                    self.isPlaying = false
                }
            }
        }
        isPlaying.toggle()
    }
    
}
