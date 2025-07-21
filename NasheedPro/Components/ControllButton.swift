//
//  ControllButton.swift
//  NasheedPro
//
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI

struct ControllButton: View {
    
    let icon: String
    let size: CGFloat
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size))
            .padding(.trailing)
            .foregroundStyle(color)
    }
}


#Preview {
    ControllButton(icon: "info.circle", size: 40, color: primary)
        
}
