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
    
    @StateObject private var vm = PlayControllerViewModel()
    
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
                    
                    // Custom Progress Bar
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.red)
                        .frame(width: (vm.progress / vm.totalDuration) * sliderWidth, height: 4)
                    
                    // Custom SF Symbol Thumb (Draggable)
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 14, height: 14) // Adjust thumb size
                        .foregroundColor(.red)
                        .offset(x: (vm.progress / vm.totalDuration) * sliderWidth - 7) // Fix thumb position
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let newProgress = min(max(0, value.location.x / sliderWidth * vm.totalDuration), vm.totalDuration)
                                    vm.progress = newProgress
                                }
                        )
                }
                .contentShape(Rectangle()) // Make the entire area tappable
                .onTapGesture { location in
                    let newProgress = min(max(0, location.x / sliderWidth * vm.totalDuration), vm.totalDuration)
                    vm.progress = newProgress
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
            Text(vm.formatTime(vm.progress))  // Current time
            Spacer()
            Text(vm.formatTime(vm.totalDuration)) // Total duration
        }
        .font(.caption)
        .foregroundStyle(.primary)
    }
    
    
    
    private var upperButtons: some View {
        HStack(spacing: 16) {
            Button {
                // Rewind 15 seconds
            } label: { ControllButton(icon: "15.arrow.trianglehead.counterclockwise", size: 24) }
            
            Button {
                // Skip backward
            } label: {
                HStack(spacing: -20) {
                    ControllButton(icon: "arrowtriangle.left.fill", size: 19)
                    ControllButton(icon: "arrowtriangle.left.fill", size: 22)
                }
            }
            
            Button {
                vm.togglePlayback()
            } label: { ControllButton(icon: vm.isPlaying ? "pause.fill" : "play.fill", size: 35) }
            
            Button {
                // Skip forward
            } label: {
                HStack(spacing: -20) {
                    ControllButton(icon: "arrowtriangle.right.fill", size: 22)
                    ControllButton(icon: "arrowtriangle.right.fill", size: 19)
                }
            }
            
            Button {
                // Fast forward 15 seconds
            } label: { ControllButton(icon: "15.arrow.trianglehead.clockwise", size: 24) }
        }
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
