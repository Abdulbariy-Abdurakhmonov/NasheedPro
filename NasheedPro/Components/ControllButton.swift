//
//  ControllButton.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI

struct ControllButton: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let icon: String
    let size: CGFloat
//    let font: Font
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .scaledFont(name: "", size: size)
            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
            .padding(.trailing)
            .foregroundStyle(color)
        
    }
}


#Preview {
    ControllButton(icon: "info.circle", size: 24, color: primary)
        
}



