//
//  PlayControllerView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI



struct PlayControllerView: View {
    
    @Binding var isPlaying: Bool
    @State private var isRepeating: Bool = false
    @State private var isLiked: Bool = false

    @StateObject var player = AudioPlayerManager.shared
    
    let haptic = HapticManager.shared
    
    let nasheed: NasheedModel
    
    var body: some View {
        VStack {
            sliderView
            upperButtons
            lowerButtons
        }
    }
    
}


#Preview {
    PlayControllerView(isPlaying: .constant(false), nasheed: dev.mockData)
    //        .preferredColorScheme(.dark)
}




extension PlayControllerView {
    
    private var sliderView: some View {
        VStack {
            GeometryReader { geometry in
                let sliderWidth = geometry.size.width // Use full width
                
                ZStack(alignment: .leading) {
                    // Custom Track
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                    
                    
                    let currentProgress = player.previewProgress ?? player.progress
                    let progressRatio = player.totalDuration > 0 ? currentProgress / player.totalDuration : 0


                    // Custom Progress Bar
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.red)
                        .frame(width: sliderWidth * progressRatio, height: 4)
                    
       
                    
                    // Custom SF Symbol Thumb (Draggable)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 14, height: 14) // Adjust thumb size
                        .foregroundColor(.red)
                        .offset(x: progressRatio * sliderWidth - 7 )
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let newProgress = min(max(0, value.location.x / sliderWidth * player.totalDuration), player.totalDuration)
                                    
                                    player.previewProgress = newProgress
                                    haptic.playImpact()
                                }
                                .onEnded { value in
                                        let newProgress = min(max(0, value.location.x / sliderWidth * player.totalDuration), player.totalDuration)
                                        player.seek(to: newProgress)
                                    player.previewProgress = nil
                                    haptic.playSelection()
                                    
                                    }
                        )
                }
                .contentShape(Rectangle()) // Make the entire area tappable
                .onTapGesture { location in
                    let newProgress = min(max(0, location.x / sliderWidth * player.totalDuration), player.totalDuration)
                    player.seek(to: newProgress)
                    haptic.playSelection()
                }//Zstack
                
            }
            .frame(height: 20) // Ensure enough space for the thumb
            timeLabel
        }
        .frame(height: 28)
        .padding(.horizontal)
    }
    
    private var timeLabel: some View {
        HStack {
            Text(player.formatTime(player.previewProgress ?? player.progress))
            Spacer()
            Text(player.formatTime(player.totalDuration))
        }
        .font(.caption)
        .foregroundStyle(.primary)
    }
    
    private var upperButtons: some View {
        
            HStack(spacing: 16) {
                Button {
                    player.rewind15Seconds()
                } label: { ControllButton(icon: "15.arrow.trianglehead.counterclockwise", size: 24) }.disabled(!player.isPlayerReady)
                
                
                Button {
                    // Skip backward
                } label: {
                    HStack(spacing: -20) {
                        ControllButton(icon: "arrowtriangle.left.fill", size: 19)
                        ControllButton(icon: "arrowtriangle.left.fill", size: 22)
                    }
                }
                
                Button {
                    
                    guard let url = URL(string: nasheed.audio) else { return }
                    player.togglePlayPause(url: url)
                    
                    
                } label: { ControllButton(icon: player.isPlaying ? "pause.fill" : "play.fill", size: 35) }
                
                Button {
                    // Skip forward
                    
                } label: {
                    HStack(spacing: -20) {
                        ControllButton(icon: "arrowtriangle.right.fill", size: 22)
                        ControllButton(icon: "arrowtriangle.right.fill", size: 19)
                    }
                }
                
                Button {
                    player.forward15Seconds()
                } label: { ControllButton(icon: "15.arrow.trianglehead.clockwise", size: 24) }.disabled(!player.isPlayerReady)
            }.overlay(content: {
                if !player.isPlayerReady {
                       ProgressView()
                           .progressViewStyle(CircularProgressViewStyle())
                           .offset(x: -10, y: -35)
                   }
            })
            
            .padding(.vertical, 26)
            .padding(.bottom, 28)
            
           
            
      
        
        
    }
    
    private var lowerButtons: some View {
        HStack {
            Button {
                isRepeating.toggle()
            }label: { ControllButton(icon: isRepeating ? "moon.zzz" : "moon.zzz.fill", size: 28) }

            Spacer()
            
            Button {
                isLiked.toggle()
            } label: { ControllButton(icon: isLiked ? "heart" : "heart.fill", size: 28) }
            
            Spacer()
            
            Button {
                isRepeating.toggle()
            } label: {
                ControllButton(icon: isRepeating ? "repeat" : "repeat.1", size: 28)
            }
        }
        .padding(.horizontal, 55)
    }
    
    
    
}
