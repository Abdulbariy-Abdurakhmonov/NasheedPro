//
//  Color.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUICore

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: Double
        r = Double((int >> 16) & 0xFF) / 255.0
        g = Double((int >> 8) & 0xFF) / 255.0
        b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
    
    static let theme = ColorTheme()
    
//    var backgroundColor: Color {
//        colorScheme == .dark ? Color(hex: "1E201E") : Color(hex: "F8F3D9")
//    }
    

    
}

struct ColorTheme {
    
    let background = Color("BackgroundColor")
    let accent = Color("AccentColor")
    let mainColor = Color("MainColor")
    let launchBackgroundColor = Color("LaunchBackgroundColor")
    
    var hex: Color {
        .init(hex: "222831")
    }
}

let primary = Color.theme.mainColor
