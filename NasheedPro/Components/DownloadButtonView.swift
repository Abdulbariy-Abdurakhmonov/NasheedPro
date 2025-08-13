//
//  DownloadButtonView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct DownloadButtonView: View {
    
    enum DownloadState: Equatable {
        case notDownloaded
        case downloading(Double) 
        case finished
        case downloaded
    }
    
    @State private var animateDownloaded = false
    
    let state: DownloadState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            content
        }
        .tint(.accent)
        .buttonStyle(.plain) // or your custom style
        .disabled(!isInteractive)
    }

    @ViewBuilder
    private var content: some View {
        switch state {
        case .notDownloaded:
            Image(systemName: "arrow.down.circle")
                .scaledFont(name: "", size: 22)
                .foregroundStyle(.accent)

        case .downloading(let progress):
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 3)
                    .frame(width: 24, height: 24)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.accent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 24, height: 24)
                    .animation(.linear, value: progress)
            }

        case .finished:
            Image(systemName: "checkmark")
                .foregroundColor(.green)
                .font(.system(size: 26))
                .scaleEffect(animateDownloaded ? 1.3 : 1.0) // bump up size
                .opacity(animateDownloaded ? 0 : 1) // fade out
                .onAppear {
                    withAnimation(.easeOut(duration: 1.2)) {
                        animateDownloaded = true
                    }
                }
            
            

        case .downloaded:
          EmptyView()
      
        }
    }

    private var isInteractive: Bool {
        switch state {
        case .notDownloaded, .downloaded:
            return true
        default:
            return false
        }
    }
}




#Preview {
    DownloadButtonView(state: .notDownloaded, action: {})
}
