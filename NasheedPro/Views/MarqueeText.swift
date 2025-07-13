//
//  MarqueeText.swift
//  NasheedPro
//
//  Created by Abdulboriy on 13/07/25.
//


import SwiftUI

struct MarqueeText: View {
    let text: String
    let font: UIFont
    let speed: Double = 30 // pixels per second
    

    @State private var textWidth: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let containerWidth = geo.size.width

            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let totalDistance = textWidth + containerWidth
                let x = CGFloat(now.truncatingRemainder(dividingBy: totalDistance / speed)) * speed


                HStack {
                    Text(text)
                        .font(Font(font))
                        .fontDesign(.serif)
                        .fixedSize()
                        .lineLimit(1)
                        .background(WidthGetter(width: $textWidth))
                        .offset(x: textWidth > containerWidth ? geo.size.width - x : 0)

                    Spacer(minLength: 0)
                }
                .frame(width: containerWidth, alignment: .leading)
                .mask(fadeMask(width: geo.size.width))
            }
        }
        .clipped()
    }
    
    @ViewBuilder
    private func fadeMask(width: CGFloat) -> some View {
        if textWidth > width {
            HStack(spacing: 0) {
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .black]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 20)

                Rectangle().fill(Color.black)

                LinearGradient(
                    gradient: Gradient(colors: [.black, .clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 20)
            }
        } else {
            // Text fits – show full
            Rectangle().fill(Color.black)
        }
    }
    
}







struct WidthGetter: View {
    @Binding var width: CGFloat

    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthKey.self, value: geometry.size.width)
        }
        .onPreferenceChange(WidthKey.self) { self.width = $0 }
    }
}



struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

