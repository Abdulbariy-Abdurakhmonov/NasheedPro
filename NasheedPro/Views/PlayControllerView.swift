//
//  PlayControllerView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI



struct PlayControllerView: View {
    
    
    let sleepOptions: [TimeInterval] = [15 * 60, 30 * 60, 60 * 60] // in seconds
    
    @State private var isRotating = false
    @State private var isRepeatEnabled = false
    
    @State private var isRepeating: Bool = false
    @StateObject var player = AudioPlayerManager.shared
    let haptic = HapticManager.shared

    @ObservedObject var sleepTManager: SleepTimerManager
    @ObservedObject var nasheed: NasheedModel
    
    @EnvironmentObject var viewModel: NasheedViewModel
    
    var body: some View {
        VStack {
            sliderView
            upperButtons
            lowerButtons
        }
    }
    
}


#Preview {
    NavigationStack {
        PlayControllerView(sleepTManager: AudioPlayerManager.shared.sleepTimer, nasheed: dev.mockData)
    }.environmentObject(dev.nasheedVM)
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

                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.red)
                        .frame(width: sliderWidth * progressRatio, height: 4)
                    
       
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
                } label: { ControllButton(icon: "15.arrow.trianglehead.counterclockwise", size: 24, color: primary) }.disabled(!player.isPlayerReady)
                
                
                Button {
                    player.playPrevious()
                } label: {
                    HStack(spacing: -20) {
                        ControllButton(icon: "arrowtriangle.left.fill", size: 19, color: primary)
                        ControllButton(icon: "arrowtriangle.left.fill", size: 22, color: primary)
                    }
                }
                
                
                Button {
                    guard let url = URL(string: nasheed.audio) else { return }
                    player.togglePlayPause(url: url)
                    
                } label: { ControllButton(icon: player.isPlaying ? "pause.fill" : "play.fill", size: 35, color: primary) }
                
                Button {
                    player.playNext()
                    
                } label: {
                    HStack(spacing: -20) {
                        ControllButton(icon: "arrowtriangle.right.fill", size: 22, color: primary)
                        ControllButton(icon: "arrowtriangle.right.fill", size: 19, color: primary)
                    }
                }
                
                Button {
                    player.forward15Seconds()
                } label: { ControllButton(icon: "15.arrow.trianglehead.clockwise", size: 24, color: primary) }.disabled(!player.isPlayerReady)
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
    
    @ViewBuilder
    private func sleepButton(for duration: TimeInterval, label: String) -> some View {
        Button(action: {
            sleepTManager.startSleepTimer(for: duration)
        }) {
            HStack {
                Text(label)
                Spacer()
                if sleepTManager.selectedSleepDuration == duration {
                    Image(systemName: "checkmark")
                        .tint(.accent)
                }
            }
        }
    }

    
    private var lowerButtons: some View {
        HStack {
                Menu {
                    if sleepTManager.isSleepTimerActive {
                        Button("Cancel Timer", role: .destructive) {
                            sleepTManager.cancelSleepTimer()
                        }
                    }
                        sleepButton(for: 30 * 60, label: "30 Minutes")
                        sleepButton(for: 15 * 60, label: "15 Minutes")
                        sleepButton(for: 0.16 * 60, label: "10 Seconds")
                } label: {
                    
                    ControllButton(icon: sleepTManager.isSleepTimerActive ? "moon.zzz.fill" : "moon.zzz", size: 28, color: sleepTManager.isSleepTimerActive ? .accent.opacity(0.7) : .secondary)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: sleepTManager.isSleepTimerActive)
                }
                
                
                    .overlay {
                       
                        if sleepTManager.isSleepTimerActive, let remaining = sleepTManager.remainingSleepTime {
                               Text(player.formatTime(remaining))
                                   .font(.caption2)
                                   .padding(4)
                                   .background(Color.red.opacity(0.9))
                                   .foregroundColor(.white)
                                   .clipShape(Capsule())
                                   .offset(x: 20, y: -20)

                            
                                   .transition(
                                    .asymmetric(
                                        insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale),
                                        removal: AnyTransition.scale(scale: 0.1)
                                            .combined(with: .opacity)
                                            .combined(with: .offset(x: 10, y: -10))
                                    )
                                   )
                            
                           }
                        
                    }.animation(.spring(response: 0.4, dampingFraction: 0.7), value: sleepTManager.isSleepTimerActive)
                

            
            Spacer()
            
            Button {
                viewModel.toggleLike(for: nasheed)
            } label: {
//                ControllButton(icon: nasheed.isLiked ? "heart.fill" : "heart", size: 28,
//                    color: nasheed.isLiked ? .pink : .secondary)
                
                LikeButtonView(isLiked: $nasheed.isLiked, size: 28)
                    
                    
                
            }
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                        isRepeatEnabled.toggle()
                        isRotating = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {isRotating = false}
                player.isRepeatEnabled = isRepeatEnabled
                
            } label: {
                    ControllButton(icon:isRepeatEnabled ? "repeat.1" : "repeat", size: 28,
                                   color: isRepeatEnabled ? .accent.opacity(0.7): .secondary)
//                    .rotationEffect(.degrees(isRotating ? 15 : 0))
                    .scaleEffect(isRotating ? 1.2 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isRotating)

            }
            
        }
        .padding(.horizontal, 55)
    }
    
    
    
}
