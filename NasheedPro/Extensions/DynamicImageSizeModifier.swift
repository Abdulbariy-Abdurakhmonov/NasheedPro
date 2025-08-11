//
//  DynamicImageSizeModifier.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/08/25.
//

import Foundation
import SwiftUI

struct DynamicImageSizeModifier: ViewModifier {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var baseSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: scaledSize, height: scaledSize)
    }
    
    private var scaledSize: CGFloat {
        let scale: CGFloat
        switch dynamicTypeSize {
        case .xSmall: scale = 0.8
        case .small: scale = 0.9
        case .medium: scale = 1.0
        case .large: scale = 1.1
        case .xLarge: scale = 1.2
        case .xxLarge: scale = 1.3
        case .xxxLarge: scale = 1.4
        case .accessibility1: scale = 1.4
        default: scale = 1.0
        }
        return baseSize * scale
    }
}

extension View {
    func dynamicImageSize(base: CGFloat) -> some View {
        self.modifier(DynamicImageSizeModifier(baseSize: base))
    }
}

