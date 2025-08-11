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
    let maxCharsPerLine: Int

    @State private var visibleCharacters: Int = 0
    @State private var isTwoLines: Bool = false

    var body: some View {
        Group {
            if isTwoLines {
                VStack(alignment: .center, spacing: 0) {
                    textLine(0)
                    textLine(1)
                }
            } else {
                textLine(0)
            }
        }
        .onAppear {
            visibleCharacters = text.count
            checkTwoLines()
        }
        .onChange(of: text) { _, newValue in
            visibleCharacters = 0
            checkTwoLines()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                visibleCharacters = newValue.count
            }
        }
    }

    private func textLine(_ lineIndex: Int) -> some View {
        let words = text.split(separator: " ")
      
        var firstLine = ""
        var secondLine = ""
        
        for word in words {
            if (firstLine + (firstLine.isEmpty ? "" : " ") + word).count <= maxCharsPerLine {
                firstLine += (firstLine.isEmpty ? "" : " ") + word
            } else {
                secondLine += (secondLine.isEmpty ? "" : " ") + word
            }
        }

        let lineText = (lineIndex == 0) ? firstLine : secondLine
        
        let start = (lineIndex == 0) ? 0 : firstLine.count
        let _ = start + lineText.count

        return HStack(spacing: 0) {
            ForEach(Array(lineText.enumerated()), id: \.offset) { index, char in
                let globalIndex = start + index
                Text(String(char))
                    .font(font)
                    .opacity(globalIndex < visibleCharacters ? 1 : 0)
                    .animation(.easeOut.delay(Double(globalIndex) * delay), value: visibleCharacters)
            }
        }
    }

    // Decide if text should be split into 2 lines
    private func checkTwoLines() {
        isTwoLines = text.count > maxCharsPerLine
    }
}






#Preview {
    AnimatedText(text: "This is very long nasheed to be tested", font: .title, delay: 0.02, maxCharsPerLine: 25)
}
