//
//  AudioPlayerManager.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/07/25.
//

import Foundation
import AVFoundation

class AudioPlayerManager: ObservableObject {
    
    
    private var pendingSleepDuration: TimeInterval?
    private var pausedSleepRemainingTime: TimeInterval?
    private var sleepEndDate: Date?
    
    @Published var countdownPaused = false
    @Published var selectedSleepDuration: TimeInterval? = nil
    @Published var countdownTimer: Timer?
    @Published var sleepTimer: Timer?
    @Published var remainingSleepTime: TimeInterval? = nil
    @Published var isSleepTimerActive = false
    
    
    @Published var isRepeatEnabled: Bool = false
    @Published var timer: Timer?
    @Published var progress: Double = 0.0
    @Published var totalDuration: Double = 0
    @Published var previewProgress: Double? = nil
    @Published var isPlayerReady: Bool = false

    static let shared = AudioPlayerManager()
    private var player: AVPlayer?
    
    @Published var isPlaying = true
    @Published var allNasheeds: [NasheedModel] = []
    @Published var currentIndex: Int = 0

    
    var onNasheedChange: ((NasheedModel) -> Void)?

    //go
    func startSleepTimer(for duration: TimeInterval) {
        cancelSleepTimer()
        
        selectedSleepDuration = duration
        isSleepTimerActive = true
        countdownPaused = true
        remainingSleepTime = duration
        pendingSleepDuration = duration
        
        if isPlaying {
            sleepEndDate = Date().addingTimeInterval(duration)
            updateRemainingTime()
            beginCountdown()
            countdownPaused = false
            pendingSleepDuration = nil
        }
    }
    
    //go
    private func beginCountdown() {
        guard let endDate = sleepEndDate else { return }

        sleepTimer = Timer.scheduledTimer(withTimeInterval: endDate.timeIntervalSinceNow, repeats: false) { [weak self] _ in
            self?.pause()
            self?.cancelSleepTimer()
        }

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }

        countdownPaused = false
    }

    
    

    
    //go
     func cancelSleepTimer(keepState: Bool = false) {
         sleepTimer?.invalidate()
         countdownTimer?.invalidate()
         sleepTimer = nil
         countdownTimer = nil

         if !keepState {
             remainingSleepTime = nil
             isSleepTimerActive = false
             sleepEndDate = nil
             selectedSleepDuration = nil
             pausedSleepRemainingTime = nil
             pendingSleepDuration = nil
             countdownPaused = false
         }
     }

     
    
    //go
    private func updateRemainingTime() {
           guard let endDate = sleepEndDate else { return }
           let timeLeft = endDate.timeIntervalSinceNow
           if timeLeft <= 0 {
               remainingSleepTime = 0
               cancelSleepTimer()
           } else {
               remainingSleepTime = timeLeft
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
        
        
        if isSleepTimerActive {
            if countdownPaused {
                
                // go
                if let pending = pendingSleepDuration {
                    sleepEndDate = Date().addingTimeInterval(pending)
                    pendingSleepDuration = nil
                } else if let remaining = pausedSleepRemainingTime {
                    sleepEndDate = Date().addingTimeInterval(remaining)
                }
                
                beginCountdown()
                countdownPaused = false
            }
        }
    }
    
    
    func pause() {
        player?.pause()
        isPlaying = false
        timer?.invalidate()
        
        // go
        if isSleepTimerActive && !countdownPaused {
               pausedSleepRemainingTime = sleepEndDate?.timeIntervalSinceNow
               cancelSleepTimer(keepState: true)
               countdownPaused = true
           }
        
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
              let url = URL(string: nasheeds[index].audio) else { return }
        
        self.allNasheeds = nasheeds
        self.currentIndex = index
//        self.currentNasheed = nasheeds[index] // if you keep this
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
