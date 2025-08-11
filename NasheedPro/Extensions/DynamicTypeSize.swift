//
//  DynamicTypeSize.swift
//  NasheedPro
//
//  Created by Abdulboriy on 09/08/25.
//

import SwiftUI

extension DynamicTypeSize {
    var customMinScaleFactor: CGFloat {
        switch self {
        case .xSmall, .small, .medium, .large:
            return 1.0
        case .xLarge, .xxLarge:
            return 0.8
       
        default:
            return 0.7
            
        }
    }
    
//    private var imageSize: CGFloat {
//          // Base size = 40 points, scale up/down with dynamic type
//          let baseSize: CGFloat = 40
//          let scaleFactor = dynamicTypeScale
//          return baseSize * scaleFactor
//      }
//    
//    private var dynamicTypeScale: CGFloat {
//           switch self {
//           case .xSmall: return 0.8
//           case .small: return 0.9
//           case .medium: return 1.0
//           case .large: return 1.1
//           case .xLarge: return 1.2
//           case .xxLarge: return 1.3
//           case .xxxLarge: return 1.4
//           case .accessibility1: return 1.6
//           default: return 1.0
//           }
//       }
    
    
    
}

import SwiftUI
import UIKit


struct ScaledFont: ViewModifier {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    var name: String
    var size: Double

    func body(content: Content) -> some View {
                
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)

        return content.font(.custom(name, size: scaledSize))
    }
}


extension View {
    func scaledFont(name: String, size: Double) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}







