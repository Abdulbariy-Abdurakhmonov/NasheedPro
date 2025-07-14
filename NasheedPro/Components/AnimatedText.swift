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
    }
}


#Preview {
    AnimatedText(text: "Nasheed test text", font: .title, delay: 0.03)
}
