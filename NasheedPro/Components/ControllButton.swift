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
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size))
            .padding(.trailing)
            .foregroundStyle(primary)
    }
}


#Preview {
    ControllButton(icon: "info.circle", size: 40)
        
}
