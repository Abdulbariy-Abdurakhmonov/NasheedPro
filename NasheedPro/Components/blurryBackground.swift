//
//  blurryBackground.swift
//  NasheedPro
//
//  Created by Abdulboriy on 19/08/25.
//

import SwiftUI

struct blurryBackground: View {
    
    let mock = "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/396e9/MainBefore.jpg"
    let mock2 = "https://cdn.pixabay.com/photo/2024/05/26/10/15/bird-8788491_1280.jpg"
    
    let url: String
    
    var body: some View {
        
            ImageLoader(url: url)
                .scaledToFill()
                .blur(radius: 20)
                .opacity(0.6)
                .ignoresSafeArea()

            
            
        
    }
}

#Preview {
    blurryBackground(url: "https://letsenhance.io/static/73136da51c245e80edc6ccfe44888a99/396e9/MainBefore.jpg")
}
