//
//  HapticManager.swift
//  NasheedPro
//
//  Created by Abdulboriy on 12/07/25.
//

import Foundation
import SwiftUI

//import UIKit

class HapticManager {
    static let shared = HapticManager()

    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private var lastTickTime: TimeInterval = 0

    private init() {}

    
    
    func playImpact() {
        let now = Date().timeIntervalSince1970
        if now - lastTickTime > 0.1 {
            impactGenerator.prepare()
            impactGenerator.impactOccurred()
            lastTickTime = now
        }
    }
    

    func playSelection() {
        selectionGenerator.prepare()
        selectionGenerator.selectionChanged()
    }
}

