//
//  PlayingDetailView.swift
//  NasheedPro
//  Created by Abdulboriy on 30/06/25.
//

import SwiftUI
import MinimizableView

struct PlayingDetailView: View {
    
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @EnvironmentObject var viewModel: NasheedViewModel
    @ObservedObject var nasheed: NasheedModel
    var animationNamespaceId: Namespace.ID
    
    
    
    //MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                upperControllers(safeAreaTopInset: proxy.safeAreaInsets.top)
                Spacer()
                imageAndMiniViews(proxy: proxy)
                fullScreenTextsAndControllers()
                Spacer()
            }
            
        }.transition(AnyTransition.move(edge: .bottom))
    }
}


//MARK: - Preview
#Preview {
    @Previewable @Namespace var previewNamespace
    NavigationStack {
        PlayingDetailView(nasheed: dev.mockData, animationNamespaceId: previewNamespace)
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
    
}



// MARK: - Subviews
extension PlayingDetailView {
    
    private func upperControllers(safeAreaTopInset: CGFloat) -> some View {
        VStack {
            Capsule()
                .fill(Color.gray.opacity(0.35))
                .frame(width: 40, height: 5)
                .padding(.top, safeAreaTopInset + 10)
            
            HStack {
                
                Button(action: {
                    self.miniHandler.minimize()
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24))
                        .foregroundColor(.accent)
                        .fontWeight(.medium)
                }.padding(.horizontal, 10)
                    .frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0)
                
                Spacer()
                
                Button(action: {
                    AudioPlayerManager.shared.stop()
                    self.miniHandler.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.accent)
                        .fontWeight(.medium)
                    
                }.padding(.trailing, 10)
                    .frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0)
            }.frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0)
                .padding(.horizontal, 10)
        }
        .frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0).opacity(self.miniHandler.isMinimized ? 0 : 1)
            .padding(.top, self.miniHandler.isMinimized ? 0 : 50)
    }
    
    private func imageAndMiniViews(proxy: GeometryProxy) -> some View {
          HStack(spacing: 15) {
              if !miniHandler.isMinimized {
                  Spacer(minLength: 0)
              }

              imageView(proxy: proxy)

              if miniHandler.isMinimized {
                  miniControllerView()
              } else {
                  Spacer(minLength: 0)
              }
          }
          .padding(.leading)
      }
    
    private func imageView(proxy: GeometryProxy) -> some View {
        Image(nasheed.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: self.imageSize(proxy: proxy), height: self.imageSize(proxy: proxy))
            .cornerRadius(30)
    }
    
    private func miniControllerView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                MarqueeText(text: nasheed.nasheed, font: .system(size: 23.5, weight: .regular))
                    .matchedGeometryEffect(id: nasheed.nasheed, in: animationNamespaceId)
                    .fontDesign(.serif)
                Text(nasheed.reciter)
                    .font(.headline)
                    .fontDesign(.serif)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: true, vertical: false)
                    .matchedGeometryEffect(id: nasheed.reciter, in: animationNamespaceId)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
            MinimizedController(nasheed: nasheed, player: AudioPlayerManager.shared)
                .padding(.trailing, 16)
                .frame(width: 100)
                .padding(.leading, 6)
        }
    }
    
    private func fullScreenTextsAndControllers() -> some View {
        Group {
            if !miniHandler.isMinimized {
                VStack {
                    AnimatedText(text: nasheed.nasheed, font: .title, delay: 0.02)
                        .fontDesign(.serif)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.horizontal)
                        .id(nasheed.id)
                    
                    AnimatedText(text: nasheed.reciter, font: .title2, delay: 0.02)
                        .fontDesign(.serif)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .id(nasheed.id)
                    
                    
                    PlayControllerView(nasheed: nasheed)
                        .padding(.top)
                }
                .padding(.top, 20)
            }
        }
        
    }
    
    private func imageSize(proxy: GeometryProxy) -> CGFloat {
        if miniHandler.isMinimized {
            return 55 + abs(self.miniHandler.draggedOffsetY) / 2
        } else {
            return proxy.size.height * 0.36
        }
    }
    
}
