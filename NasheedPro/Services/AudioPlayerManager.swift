//
//  AudioPlayerManager.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/07/25.
//

import Foundation
import SwiftUI
import AVFoundation

class AudioPlayerManager: ObservableObject {
        
    
    @Published var isRepeatEnabled: Bool = false
    @Published var timer: Timer?
    @Published var progress: Double = 0.0
    @Published var totalDuration: Double = 0
    @Published var previewProgress: Double? = nil
    @Published var isPlayerReady: Bool = false
    
    let sleepTimer = SleepTimerManager()
    static let shared = AudioPlayerManager()
    private var player: AVPlayer?
    
    @Published var isPlaying = true
    @Published var allNasheeds: [NasheedModel] = []
    @Published var currentIndex: Int = 0

//    @EnvironmentObject var viewModel: NasheedViewModel
    
    var onNasheedChange: ((NasheedModel) -> Void)?
    
    
    
    
    init() {
        sleepTimer.onSleepTimeout = { [weak self] in
            self?.pause()
        }
        
        sleepTimer.isPlaying = { [weak self] in
             self?.isPlaying == true
        }
    }
    
    
    
    
    
    @objc private func playerDidFinishPlaying() {
        if isRepeatEnabled {
            player?.seek(to: .zero)
            player?.play()
        } else {
            playNext()
        }
    }
    

    func play(player: AVPlayer) {
        player.play()
        isPlaying = true
        
        sleepTimer.playTriggered()
    }
    
    
    func pause() {
        player?.pause()
        isPlaying = false
        timer?.invalidate()
        
        sleepTimer.pauseTriggered()
    }
    
    
    func stop() {
        player?.pause()
        player?.replaceCurrentItem(with: nil)  // Clears the current item
        timer?.invalidate()
        progress = 0
        isPlaying = false
    }
    
    
    func rewind15Seconds() {
        guard let player = player else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = max(currentTime - 15, 0)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
        progress = newTime
    }
    
    
    func forward15Seconds() {
        guard let player = player else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime(seconds: totalDuration, preferredTimescale: 600))
        let newTime = min(currentTime + 15, duration)
        player.seek(to: CMTime(seconds: newTime, preferredTimescale: 600))
        progress = newTime
    }

    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func playNext() {
        let nextIndex = currentIndex + 1
        guard allNasheeds.indices.contains(nextIndex) else { return }
        loadAndPlay(nasheeds: allNasheeds, index: nextIndex)
    }

    
    func playPrevious() {
        let prevIndex = currentIndex - 1
        guard allNasheeds.indices.contains(prevIndex) else { return }
        loadAndPlay(nasheeds: allNasheeds, index: prevIndex)
    }

    
    func loadAndPlay(nasheeds: [NasheedModel], index: Int) {
        guard nasheeds.indices.contains(index),
              let url = URL(string: nasheeds[index].audioURL) else { return }
                
        self.allNasheeds = nasheeds
        self.currentIndex = index

        DispatchQueue.main.async {
            self.onNasheedChange?(nasheeds[index])
        }

        loadAndPlay(url: url)
    }

    
    func loadAndPlay(url: URL) {
        player?.pause()
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        player = AVPlayer(url: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            
        player?.play()
        isPlaying = true
        isPlayerReady = false
        
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
                    await MainActor.run { [weak self] in
                        self?.totalDuration = CMTimeGetSeconds(duration)
                        self?.isPlayerReady = true
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
            pause()
        } else {
            if let currentAsset = player?.currentItem?.asset as? AVURLAsset {
                if currentAsset.url != url {
                    player = AVPlayer(url: url)
                    progress = 0 // reset progress for new track
                }
            } else {
                
                player = AVPlayer(url: url)
            }
            
            if let player = player {
                play(player: player)
            }
            
            
            Task {
                do {
                    if let duration = try await player?.currentItem?.asset.load(.duration) {
                        await MainActor.run { [weak self] in
                            self?.totalDuration = CMTimeGetSeconds(duration)
                            
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
