//
//  AudioPlayerManager.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/07/25.
//

import Foundation
import AVFoundation

class AudioPlayerManager: ObservableObject {
    
    @Published var timer: Timer?
    @Published var progress: Double = 0.0
    @Published var totalDuration: Double = 200
    
    @Published var previewProgress: Double? = nil
    
    //
    static let shared = AudioPlayerManager()
    
    private var player: AVPlayer?
    
    @Published var isPlaying = false
    
    func play(url: URL) {
        if player?.currentItem?.asset as? AVURLAsset != AVURLAsset(url: url) {
            // If different track, replace it
            player = AVPlayer(url: url)
        }
        player?.play()
        isPlaying = true
    }
    
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    
    func stop() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)  // Clears the current item
        timer?.invalidate()
        progress = 0
        isPlaying = false
    }
    
    
    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    
    
    func loadAndPlay(url: URL) {
        player?.pause()
        player = AVPlayer(url: url)
        player?.play()
        isPlaying = true
        
        // Reset and start timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let currentTime = self.player?.currentTime() {
                self.progress = CMTimeGetSeconds(currentTime)
            }
            if self.progress >= self.totalDuration {
                self.timer?.invalidate()
                self.isPlaying = false
            }
        }
        
        
        Task {
            do {
                if let duration = try await player?.currentItem?.asset.load(.duration) {
                    await MainActor.run {
                        totalDuration = CMTimeGetSeconds(duration)
                    }
                }
            } catch {
                print("Failed to load duration:", error)
            }
        }
    }
    
    
    
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
        progress = time
    }
    
    
    
    func togglePlayPause(url: URL) {
        if isPlaying {
            // Pause everything
            player?.pause()
            timer?.invalidate()
            isPlaying = false
        } else {
            if let currentAsset = player?.currentItem?.asset as? AVURLAsset {
                if currentAsset.url != url {
                    player = AVPlayer(url: url)
                    progress = 0 // reset progress for new track
                }
            } else {
                player = AVPlayer(url: url)
            }
            
            
            // Start playback
            player?.play()
            isPlaying = true
            
            Task {
                do {
                    if let duration = try await player?.currentItem?.asset.load(.duration) {
                        await MainActor.run {
                            totalDuration = CMTimeGetSeconds(duration)
                        }
                    }
                } catch {
                    print("Failed to load duration:", error)
                }
            }
            
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                guard let self = self else { return }
                if let currentTime = self.player?.currentTime() {
                    self.progress = CMTimeGetSeconds(currentTime)
                }
                if self.progress >= self.totalDuration {
                    self.timer?.invalidate()
                    self.isPlaying = false
                }
            }
        }
    }
    
    
}
