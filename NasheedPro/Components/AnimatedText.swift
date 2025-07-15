//
//  AnimatedText.swift
//  NasheedPro
//
//  Created by Abdulboriy on 14/07/25.
//

import SwiftUI

struct AnimatedText: View {
    let text: String
    let font: Font
    let delay: Double
    
    @State private var visibleCharacters: Int = 0
    
    //    @Binding var shouldAnimate: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            
            
            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                Text(String(char))
                    .font(font)
                    .opacity(index < visibleCharacters ? 1 : 0)
                    .animation(.easeOut.delay(Double(index) * delay), value: visibleCharacters)
            }
            
        }
        .onAppear {
            visibleCharacters = text.count
        }
        .onChange(of: text) { _, newValue in
            visibleCharacters = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 0.8 is good
                visibleCharacters = newValue.count
            }
        }
        
    }
}


#Preview {
    AnimatedText(text: "Nasheed test text", font: .title, delay: 0.03)
}
