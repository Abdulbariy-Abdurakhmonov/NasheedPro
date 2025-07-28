//
//  LikeButtonView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 25/07/25.
//

import SwiftUI

struct LikeButtonView: View {

    let size: CGFloat
    @EnvironmentObject var viewModel: NasheedViewModel
    
    @State private var heartStyle: AnyShapeStyle = AnyShapeStyle(Color.gray)
    @State private var animate = false
    @State private var wasTapped = false
    @State private var isLiked: Bool = false
    
    let tapAction: () -> Void

   
    
    var body: some View {
        Image(systemName: viewModel.selectedNasheed?.isLiked ?? false ? "heart.fill" : "heart")
            .font(.system(size: size))
            .foregroundStyle(heartStyle)
            .scaleEffect(animate ? 1.3 : 1.0)
            .onTapGesture {
                wasTapped = true
                tapAction()
                isLiked.toggle()
                if isLiked { // !if
                    
                    triggerLikeAnimation()
                } else {
                    
                    heartStyle = AnyShapeStyle(Color.gray)
                }
            }
            .onAppear {
                isLiked = viewModel.selectedNasheed?.isLiked ?? false
                heartStyle = isLiked ? AnyShapeStyle(Color.red) : AnyShapeStyle(Color.gray)
            }
            .onChange(of: viewModel.selectedNasheed) { _, newValue in
                isLiked = newValue?.isLiked ?? false
                if wasTapped {
                    wasTapped = false
                    return 
                }
                
                heartStyle = isLiked ? AnyShapeStyle(Color.red) : AnyShapeStyle(Color.gray)
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
    LikeButtonView(size: 28, tapAction: {})
}
