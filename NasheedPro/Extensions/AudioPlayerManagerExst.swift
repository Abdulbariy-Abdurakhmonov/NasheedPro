//
//  AudioPlayerManagerExst.swift
//  NasheedPro
//
//  Created by Abdulboriy on 21/08/25.
//

import Foundation
import MediaPlayer

extension AudioPlayerManager {
        
    func updateNowPlayingInfo(title: String, artist: String, artwork: UIImage? = nil) {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: title,
            MPMediaItemPropertyArtist: artist
        ]

        if let player = player, let asset = player.currentItem?.asset {
            Task {
                do {
                    let duration = try await asset.load(.duration)
                    if duration.isNumeric {
                        let seconds = CMTimeGetSeconds(duration)
                        if seconds.isFinite {
                            info[MPMediaItemPropertyPlaybackDuration] = seconds
                        }
                    }
                } catch {
                    print("❌ Failed to load duration: \(error)")
                }

                info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime().seconds
                info[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

                if let artwork = artwork {
                    let resized = makeArtwork(image: artwork, targetSize: 500, cornerRadius: 0)
                    info[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: resized.size) { _ in resized }

                }

                MPNowPlayingInfoCenter.default().nowPlayingInfo = info
            }
        }
    }

    

//    func resizeAndRound(image: UIImage, size: CGFloat) -> UIImage {
//        let squareSize = CGSize(width: size, height: size)
//        let renderer = UIGraphicsImageRenderer(size: squareSize)
//        return renderer.image { _ in
//            let rect = CGRect(origin: .zero, size: squareSize)
//            
//            image.draw(in: rect)
//        }
//    }
    
    
    func makeArtwork(image: UIImage, targetSize: CGFloat, cornerRadius: CGFloat = 0) -> UIImage {
        let squareSize = CGSize(width: targetSize, height: targetSize)
        let renderer = UIGraphicsImageRenderer(size: squareSize)

        return renderer.image { _ in
            let aspect = max(targetSize / image.size.width, targetSize / image.size.height)
            let newSize = CGSize(width: image.size.width * aspect,
                                 height: image.size.height * aspect)

            let x = (targetSize - newSize.width) / 2
            let y = (targetSize - newSize.height) / 2
            let rect = CGRect(origin: CGPoint(x: x, y: y), size: newSize)

            // Clip to rounded rect (like DetailView cornerRadius)
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: squareSize),
                                    cornerRadius: cornerRadius)
            path.addClip()

            image.draw(in: rect)
        }
    }


    
    
    
    func setupRemoteTransportControls() {
          let commandCenter = MPRemoteCommandCenter.shared()
  
          commandCenter.playCommand.addTarget { [weak self] _ in
              self?.player?.play()
              return .success
          }
  
          commandCenter.pauseCommand.addTarget { [weak self] _ in
              self?.player?.pause()
              return .success
          }
  
          commandCenter.nextTrackCommand.addTarget { [weak self] _ in
              self?.playNext()
              return .success
          }
  
          commandCenter.previousTrackCommand.addTarget { [weak self] _ in
              self?.playPrevious()
              return .success
          }
        
           commandCenter.changePlaybackPositionCommand.isEnabled = true
           commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
               guard let self = self,
                     let positionEvent = event as? MPChangePlaybackPositionCommandEvent else {
                   return .commandFailed
               }
               self.seek(to: positionEvent.positionTime)
               return .success
           }
        
        
      }
    
}
