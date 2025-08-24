//
//  SleepTimerButton.swift
//  NasheedPro
//
//  Created by Abdulboriy on 28/07/25.
//

import SwiftUI

struct SleepTimerButton: View {
    
    @ObservedObject var sleepTManager: SleepTimerManager
    
    var body: some View {
        Menu {
            if sleepTManager.isSleepTimerActive {
                Button("Cancel Timer", role: .destructive) {
                    sleepTManager.cancelSleepTimer()
                }
            }
            sleepButton(for: 30 * 60, label: "30 Minutes")
            sleepButton(for: 20 * 60, label: "20 Minutes")
            sleepButton(for: 10 * 60, label: "10 Minutes")
        } label: {
            ControllButton(icon: sleepTManager.isSleepTimerActive ? "moon.zzz.fill" : "moon.zzz", size: 24, color: sleepTManager.isSleepTimerActive ? .accent.opacity(0.7) : .secondary)
                .padding(.trailing)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: sleepTManager.isSleepTimerActive)
        }
        .overlay {
            
            if sleepTManager.isSleepTimerActive, let remaining = sleepTManager.remainingSleepTime {
                Text(AudioPlayerManager.shared.formatTime(remaining))
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
    }
    
    
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
}

#Preview {
    SleepTimerButton(sleepTManager: AudioPlayerManager.shared.sleepTimer)
}
