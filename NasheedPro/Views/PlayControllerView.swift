//
//  PlayControllerView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI



struct PlayControllerView: View {
    
    
    let sleepOptions: [TimeInterval] = [10 * 60, 20 * 60, 30 * 60]
    
    @State private var isRotating = false
    @State private var isRepeatEnabled = false
    
    @EnvironmentObject var viewModel: NasheedViewModel
    
    @StateObject var player = AudioPlayerManager.shared
    let haptic = HapticManager.shared
    
    
    
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
        PlayControllerView()
    }.environmentObject(dev.nasheedVM)
    //        .preferredColorScheme(.dark)
}




extension PlayControllerView {
    
    private var sliderView: some View {
        VStack {
            GeometryReader { geometry in
                let sliderWidth = geometry.size.width
                
                ZStack(alignment: .leading) {
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
                        .frame(width: 14, height: 14)
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
                }
                
            }
            .frame(height: 20)
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
                    guard let url = URL(string: viewModel.selectedNasheed?.audioURL ?? "") else { return }
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
    
    private var lowerButtons: some View {
        HStack {
            SleepTimerButton(sleepTManager: AudioPlayerManager.shared.sleepTimer)
            Spacer()
            LikeButtonView(size: 28) {
                if let nasheed = viewModel.selectedNasheed {
                    viewModel.toggleLike(for: nasheed)
                }
            }
            .environmentObject(viewModel)
            
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
