//
//  LaunchView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 31/07/25.
//

import SwiftUI

struct LaunchView: View {
    
    @State private var visibleLetters: Int = 0
    
    @State private var launchText = "Nasheed Pro"
    @Binding var showLaunchView: Bool
    @State private var animate = false
    
    let animationDuration: Double = 0.05
    
    var body: some View {
        ZStack {
            Color.theme.launchBackgroundColor
                .ignoresSafeArea()
            
            Image("logo")
                .resizable()
                .frame(width: 200, height: 200)
            
            
            ZStack {
                
                HStack(spacing: 0) {
                    ForEach(Array(launchText.enumerated()), id: \.offset) { index, char in
                        Text(String(char))
                            .font(.title)
                            .fontWeight(.bold)
                            .fontDesign(.serif)
                            .foregroundColor(.black.opacity(0.8))
                            .opacity(index < visibleLetters ? 1 : 0)
                            .animation(.easeOut(duration: 0.3).delay(Double(index) * animationDuration), value: visibleLetters)
                    }
                }
                
            }
            .offset(y: 100)
            
        }
        .onAppear {
            animateText()
        }
    }
    
    func animateText() {
        for i in 1...launchText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * animationDuration) {
                visibleLetters = i
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(launchText.count) * animationDuration + 2.0) {
            withAnimation {
                showLaunchView = false
            }
        }
    }
    
}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}
