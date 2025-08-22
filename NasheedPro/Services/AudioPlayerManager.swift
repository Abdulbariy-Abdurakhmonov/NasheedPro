//
//  AudioPlayerManager.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/07/25.
//

import Foundation
import SwiftUI
import AVFoundation
import MediaPlayer

class AudioPlayerManager: ObservableObject {
    
    
    @Published var isRepeatEnabled: Bool = false
    @Published var timer: Timer?
    @Published var progress: Double = 0.0
    @Published var totalDuration: Double = 0
    @Published var previewProgress: Double? = nil
    @Published var isPlayerReady: Bool = false
    
    let sleepTimer = SleepTimerManager()
    static let shared = AudioPlayerManager()
    var player: AVPlayer?
    
    @Published var isPlaying = true
    @Published var allNasheeds: [NasheedModel] = []
    @Published var currentIndex: Int = 0
    
    var onNasheedChange: ((NasheedModel) -> Void)?
    
    
    
    
    init() {
        
        configureAudioSession()
        setupRemoteTransportControls()
        
        sleepTimer.onSleepTimeout = { [weak self] in
            self?.pause()
        }
        
        sleepTimer.isPlaying = { [weak self] in
            self?.isPlaying == true
        }
    }
    
    
    
    private func configureAudioSession() {
           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
               try AVAudioSession.sharedInstance().setActive(true)
           } catch {
               print("Failed to configure audio session: \(error)")
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
        player?.replaceCurrentItem(with: nil)
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
    
    
    func localFilePath(for fileName: String) -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("Downloads").appendingPathComponent(fileName)
    }
    
//    -----
    
    func loadAndPlay(nasheeds: [NasheedModel], index: Int) {
        guard nasheeds.indices.contains(index) else { return }
        
        let nasheed = nasheeds[index]
        self.allNasheeds = nasheeds
        self.currentIndex = index
        
        DispatchQueue.main.async {
            self.onNasheedChange?(nasheed)
        }
        

     
        setNowPlaying(for: nasheed)
        
        if nasheed.isDownloaded {
            if let localNasheed = NasheedViewModel().downloadedNasheeds.first(where: { $0.id == nasheed.id }) {
                let fileURL = localNasheed.localAudioURL
                loadAndPlay(url: fileURL)
            }
        } else {
            if let remoteURL = URL(string: nasheed.audioURL) {
                loadAndPlay(url: remoteURL)
            }
        }
        
        
    }
        
    
    func setNowPlaying(for nasheed: NasheedModel) {
        let title = nasheed.title
        let artist = nasheed.reciter
        
        if nasheed.isDownloaded {
            if let localNasheed = NasheedViewModel().downloadedNasheeds.first(where: { $0.id == nasheed.id }) {
                let fileURL = localNasheed.localImageURL
                if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                    updateNowPlayingInfo(title: title, artist: artist, artwork: image)
                    return
                }
            }
        }
        
        
        if let url = URL(string: nasheed.imageURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                var artwork: UIImage? = nil
                if let data = data {
                    artwork = UIImage(data: data)
                }
                DispatchQueue.main.async {
                    self.updateNowPlayingInfo(title: title, artist: artist, artwork: artwork)
                }
            }.resume()
        } else {
            updateNowPlayingInfo(title: title, artist: artist, artwork: nil)
        }
    }

    
    
    
    func loadAndPlay(url: URL) {
        player?.pause()
        timer?.invalidate()
        isPlayerReady = false
        progress = 0
        totalDuration = 0
        
        if url.isFileURL {
            if FileManager.default.fileExists(atPath: url.path) {
                print("✅ File exists at: \(url.path)")
            } else {
                print("❌ File does not exist at: \(url.path)")
            }
        }
        
        
        if url.isFileURL {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
                if let fileSize = attributes[.size] as? NSNumber {
                    print("📦 File size: \(fileSize.intValue / 1024) KB")
                }
            } catch {
                print("⚠️ Failed to get file size: \(error.localizedDescription)")
            }
        }
        
        
        
        let asset = AVURLAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: nil,
            queue: .main
        ) { notification in
            if let error = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey] as? NSError {
                print("🚨 Player failed: \(error)")
            }
        }
        
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        
        player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1, preferredTimescale: 1),
            queue: .main
        ) { [weak self] time in
            guard let self = self else { return }
            var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = time.seconds
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.player?.rate ?? 0
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
        
        
        Task {
            do {
                let duration = try await asset.load(.duration)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.totalDuration = CMTimeGetSeconds(duration)
                    self.isPlayerReady = true
                    self.isPlaying = true
                    self.player?.play()
                }
            } catch {
                print("Failed to load duration:", error)
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if let currentTime = self.player?.currentTime() {
                self.progress = CMTimeGetSeconds(currentTime)
            }
            if self.progress >= self.totalDuration, self.totalDuration > 0 {
                self.timer?.invalidate()
                self.isPlaying = false
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
            let isFileURL = url.isFileURL
            
            if let currentAsset = player?.currentItem?.asset as? AVURLAsset {
                if currentAsset.url != url {
                    player = AVPlayer(url: isFileURL ? url : url)
                    progress = 0
                }
            } else {
                player = AVPlayer(url: isFileURL ? url : url)
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


extension DownloadedNasheedModel {
    var localAudioURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("Downloads").appendingPathComponent(audioFileName)
    }
    
    var localImageURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("Downloads").appendingPathComponent(imageFileName)
    }
}
