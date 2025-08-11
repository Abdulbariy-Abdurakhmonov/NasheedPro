//
//  AnimatedText.swift
//  NasheedPro
//
//  Created by Abdulboriy on 14/07/25.
//

import SwiftUI

//struct AnimatedText: View {
//    let text: String
//    let font: Font
//    let delay: Double
//    
//    @State private var visibleCharacters: Int = 0
//
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            
//            
//            ForEach(Array(text.enumerated()), id: \.offset) { index, char in
//                Text(String(char))
//                    .font(font)
//                    .opacity(index < visibleCharacters ? 1 : 0)
//                    .animation(.easeOut.delay(Double(index) * delay), value: visibleCharacters)
//            }
//            
//        }
//        .onAppear {
//            visibleCharacters = text.count
//        }
//        .onChange(of: text) { _, newValue in
//            visibleCharacters = 0
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { // 0.8 is good
//                visibleCharacters = newValue.count
//            }
//        }
//        
//    }
//}

struct AnimatedText: View {
    let text: String
    let delay: Double
    let size: CGFloat
    
    @State private var visibleCharacters: Int = 0
   
    
    var body: some View {
        // Wrap everything in a single Text container so wrapping works
        Text(composedText)
            .scaledFont(name: "Serif", size: size)
            .fontDesign(.serif)
            .multilineTextAlignment(.center)
            .lineLimit(2) // ✅ allow 2 lines
//            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
            .onAppear {
                visibleCharacters = text.count
            }
            .onChange(of: text) { _, newValue in
                visibleCharacters = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    visibleCharacters = newValue.count
                }
            }
    }
    
    private var composedText: String {
        String(text.prefix(visibleCharacters))
    }
}





#Preview {
    AnimatedText(text: "This is very long nasheed test text to be tested", delay: 0.3, size: 35)
}
