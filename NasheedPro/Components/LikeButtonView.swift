//
//  LikeButtonView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 25/07/25.
//

import SwiftUI

struct LikeButtonView: View {
    @Binding var isLiked: Bool
    let size: CGFloat
    
    @State private var heartStyle: AnyShapeStyle = AnyShapeStyle(Color.gray)
    @State private var animate = false
    @State private var wasTapped = false
    
    let tapAction: () -> Void

    
    var body: some View {
        Image(systemName: isLiked ? "heart.fill" : "heart")
            .font(.system(size: size))
            .foregroundStyle(heartStyle)
            .scaleEffect(animate ? 1.3 : 1.0)
            .onTapGesture {
                wasTapped = true
                if !isLiked {
                    tapAction()
                    triggerLikeAnimation()
                } else {
                    tapAction()
                    heartStyle = AnyShapeStyle(Color.gray)
                }
            }
            .onAppear {
                heartStyle = isLiked ? AnyShapeStyle(Color.red) : AnyShapeStyle(Color.gray)
            }
            .onChange(of: isLiked) { _, newValue in
                if wasTapped {
                    wasTapped = false
                    return // Already handled via tap
                }
                
                heartStyle = newValue ? AnyShapeStyle(Color.red) : AnyShapeStyle(Color.gray)
            }
            .animation(.easeOut(duration: 0.3), value: animate)
    }
    
    

    private func triggerLikeAnimation() {
        withAnimation {
            heartStyle = AnyShapeStyle(linearHear())
        }
        animate = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animate = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if isLiked {
                withAnimation {
                    heartStyle = AnyShapeStyle(Color.red)
                }
            }
        }
    }
    
    
    func linearHear() -> LinearGradient {
       let myLinear = LinearGradient(
        colors: [.orange, .red, .purple],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
        return myLinear
    }
    
}



#Preview {
    LikeButtonView(isLiked: .constant(false), size: 28, tapAction: ({}))
}
