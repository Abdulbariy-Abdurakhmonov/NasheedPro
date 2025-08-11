//
//  MarqueeText.swift
//  NasheedPro
//
//  Created by Abdulboriy on 13/07/25.
//


import SwiftUI

struct MarqueeText: View {
    let text: String
    let speed: Double = 30 // pixels per second
    let size: CGFloat
    

    @State private var textWidth: CGFloat = 0
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
  
    var body: some View {
        GeometryReader { geo in
            let containerWidth = geo.size.width

            TimelineView(.animation) { timeline in
                let now = timeline.date.timeIntervalSinceReferenceDate
                let totalDistance = textWidth + containerWidth
                let x = CGFloat(now.truncatingRemainder(dividingBy: totalDistance / speed)) * speed


                HStack {
                    Text(text)
                        .scaledFont(name: "serif", size: size)
                        .fontDesign(.serif)
                        .fixedSize(horizontal: true, vertical: true)
                        .background(WidthGetter(width: $textWidth))
                        .offset(x: textWidth > containerWidth ? geo.size.width - x : 0)

                    Spacer(minLength: 0)
                }
                .frame(width: containerWidth, alignment: .leading)
                .mask(fadeMask(width: geo.size.width))
            }
        }
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
            Rectangle().fill(Color.black)
        }
    }
    
}

//


//


#Preview(body: {
    MarqueeText(text: "This is very very This is very very hththththth ", size: 22)
})



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




// new

//
//import SwiftUI
//import UIKit
//
//// MARK: - MarqueeText (works with Dynamic Type & accessibility)
//struct MarqueeText: View {
//    let text: String
//    let baseFontSize: CGFloat // e.g. 23.5
//    let speed: Double // pixels / second
//    
//    @Environment(\.sizeCategory) private var sizeCategory
//    
//    @State private var textWidth: CGFloat = 0
//    @State private var containerWidth: CGFloat = 0
//    @State private var startTime: TimeInterval? = nil
//
//    init(text: String, fontSize: CGFloat = 23.5, speed: Double = 30) {
//        self.text = text
//        self.baseFontSize = fontSize
//        self.speed = speed
//    }
//
//    var body: some View {
//        // If user has accessibility text sizes enabled, don't marquee — present readable text instead
//        if sizeCategory.isAccessibilityCategory {
//            Text(text)
//                .font(scaledUIFontAsFont)
//                .lineLimit(nil)
//                .fixedSize(horizontal: false, vertical: true)
//        } else {
//            GeometryReader { geo in
//                let containerW = geo.size.width
//
//                TimelineView(.animation) { timeline in
//                    let now = timeline.date.timeIntervalSinceReferenceDate
//                    let totalDistance = textWidth + containerWidth
//                    let elapsed = (startTime != nil) ? now - (startTime ?? 0) : 0
//                    let progress = (totalDistance > 0 && startTime != nil)
//                        ? CGFloat(fmod(elapsed * speed, Double(totalDistance)))
//                        : 0
//                    let xOffset = (textWidth > containerWidth) ? containerW - progress : 0
//
//                    HStack(spacing: 0) {
//                        Text(text)
//                            .font(scaledUIFontAsFont)
//                            .lineLimit(1)
//                            .fixedSize()
//                            .background(WidthGetter(width: $textWidth))
//                            .offset(x: xOffset)
//                        Spacer(minLength: 0)
//                    }
//                    .frame(width: containerW, alignment: .leading)
//                    .mask(fadeMask(width: containerW))
//                }
//                // measure container width safely via preference
//                .background(
//                    GeometryReader { g in
//                        Color.clear.preference(key: ContainerWidthKey.self, value: g.size.width)
//                    }
//                )
//            }
//            .onPreferenceChange(ContainerWidthKey.self) { newWidth in
//                // container width measured -> update state and decide whether to start/stop
//                let prev = containerWidth
//                containerWidth = newWidth
//                evaluateStartStop()
//                // if width changed and text already measured > new width, ensure startTime is set
//                if prev != newWidth { evaluateStartStop() }
//            }
//            .onChange(of: textWidth) {_, _ in evaluateStartStop() }
//            .clipped()
//        }
//    }
//
//    // start/stop logic (always call from main thread since it mutates @State)
//    private func evaluateStartStop() {
//        // only start marquee when we know both widths and text is wider
//        if textWidth > 0 && containerWidth > 0 && textWidth > containerWidth {
//            if startTime == nil {
//                startTime = Date().timeIntervalSinceReferenceDate
//            }
//        } else {
//            startTime = nil
//        }
//    }
//
//    // create a Font scaled via UIFontMetrics so it responds to Dynamic Type
//    private var scaledUIFontAsFont: Font {
//        let uiFont = UIFont.systemFont(ofSize: baseFontSize, weight: .regular)
//        let scaled = UIFontMetrics(forTextStyle: .title2).scaledFont(for: uiFont)
//        return Font(scaled)
//    }
//
//    // fade mask
//    @ViewBuilder
//    private func fadeMask(width: CGFloat) -> some View {
//        if textWidth > width {
//            HStack(spacing: 0) {
//                LinearGradient(
//                    gradient: Gradient(colors: [.clear, .black]),
//                    startPoint: .leading, endPoint: .trailing
//                )
//                .frame(width: 20)
//                Rectangle().fill(Color.black)
//                LinearGradient(
//                    gradient: Gradient(colors: [.black, .clear]),
//                    startPoint: .leading, endPoint: .trailing
//                )
//                .frame(width: 20)
//            }
//        } else {
//            Rectangle().fill(Color.black)
//        }
//    }
//}
//
//// MARK: - Container width preference key
//private struct ContainerWidthKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
//// MARK: - WidthGetter for measuring text width (you already had this)
//struct WidthGetter: View {
//    @Binding var width: CGFloat
//
//    var body: some View {
//        GeometryReader { geometry in
//            Color.clear
//                .preference(key: WidthKey.self, value: geometry.size.width)
//        }
//        .onPreferenceChange(WidthKey.self) { self.width = $0 }
//    }
//}
//
//private struct WidthKey: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
//    }
//}
//
