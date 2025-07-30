import Foundation
import SwiftUI

class SleepTimerManager: ObservableObject {
    
    
    
    @Published var pendingSleepDuration: TimeInterval?
    @Published var pausedSleepRemainingTime: TimeInterval?
    @Published var sleepEndDate: Date?
    
    @Published var countdownPaused = false
    @Published var selectedSleepDuration: TimeInterval? = nil
    @Published var countdownTimer: Timer?
    @Published var sleepTimer: Timer?
    @Published var remainingSleepTime: TimeInterval? = nil
    @Published var isSleepTimerActive = false
    
//    static let shared = SleepTimerManager()
    

    var onSleepTimeout: (() -> Void)?
    var isPlaying: (() -> Bool)?
    
    
    
    

    func startSleepTimer(for duration: TimeInterval) {
        cancelSleepTimer()

        selectedSleepDuration = duration
        isSleepTimerActive = true
        countdownPaused = true
        remainingSleepTime = duration
        pendingSleepDuration = duration


        if isPlaying?() == true {
            sleepEndDate = Date().addingTimeInterval(duration)
            updateRemainingTime()
            beginCountdown()
            countdownPaused = false
            pendingSleepDuration = nil
        }
    }
    

    func playTriggered() {
        if isSleepTimerActive {
            if countdownPaused {
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

    
    func pauseTriggered() {
        if isSleepTimerActive && !countdownPaused {
            pausedSleepRemainingTime = sleepEndDate?.timeIntervalSinceNow
            cancelSleepTimer(keepState: true)
            countdownPaused = true
        }
    }

    
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
    

    private func beginCountdown() {
        guard let endDate = sleepEndDate else { return }

        sleepTimer = Timer.scheduledTimer(withTimeInterval: endDate.timeIntervalSinceNow, repeats: false) { [weak self] _ in
//            AudioPlayerManager.shared.pause()
            self?.onSleepTimeout?()
            self?.cancelSleepTimer()
        }

        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }

        countdownPaused = false
    }
    
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
    
    
    
}

