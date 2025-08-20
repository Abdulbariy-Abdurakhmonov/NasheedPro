//
//  PlayingDetailView.swift
//  NasheedPro
//  Created by Abdulboriy on 30/06/25.
//
//    @ObservedObject var nasheed: NasheedModel class related

import SwiftUI
import MinimizableView

struct PlayingDetailView: View {
    
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @EnvironmentObject var viewModel: NasheedViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var animationNamespaceId: Namespace.ID
    
    
    
    //MARK: - Body
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                blurryBackground(url: viewModel.selectedNasheed?.imageURL ?? "")
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .zIndex(0)
            }

            VStack(alignment: .center, spacing: 0) {
                upperControllers(safeAreaTopInset: proxy.safeAreaInsets.top)
                Spacer()
                imageAndMiniViews(proxy: proxy)
                fullScreenTextsAndControllers()
                Spacer()
            }
            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
            .dynamicTypeSize(.xSmall ... .accessibility1)
            .zIndex(1)
        }
        .transition(.move(edge: .bottom))
    }
}



//MARK: - Preview
#Preview {
    @Previewable @Namespace var previewNamespace
    NavigationStack {
        PlayingDetailView(animationNamespaceId: previewNamespace)
    }
    .environmentObject(NasheedViewModel())
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
                    withAnimation {
                        self.miniHandler.minimize()
                    }
                    
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24))
                        .foregroundColor(.accent)
                        .fontWeight(.medium)
                }.padding(.horizontal, 10)
                    .frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0)
                
                Spacer()
                
                Button(action: {
                    
                    withAnimation {
                        self.miniHandler.dismiss()
                    }
                    
                    AudioPlayerManager.shared.stop()
                    AudioPlayerManager.shared.isRepeatEnabled = false
                    AudioPlayerManager.shared.sleepTimer.cancelSleepTimer()
                    
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundColor(.accent)
                        .fontWeight(.medium)
                    
                }
                .padding(.trailing, 10)
                    .frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0)
            }.frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0)
                .padding(.horizontal, 10)
                .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
        }
        .frame(width: self.miniHandler.isMinimized == false ? nil : 0, height: self.miniHandler.isMinimized == false ? nil : 0).opacity(self.miniHandler.isMinimized ? 0 : 1)
            .padding(.top, self.miniHandler.isMinimized ? 0 : 50)
            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
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
        
          .padding(.leading, miniHandler.isMinimized ? 16: 0)
      }
    
    private func imageView(proxy: GeometryProxy) -> some View {
        ImageLoader(url: viewModel.selectedNasheed?.imageURL ?? "")
            .frame(width: self.imageSize(proxy: proxy), height: self.imageSize(proxy: proxy))
            .cornerRadius(30)
    }
    
    
    var nasheedName: String {
        viewModel.selectedNasheed?.title ?? ""
    }
    var reciter: String {
        viewModel.selectedNasheed?.reciter ?? ""
    }
    
    var nasheedID: String {
        viewModel.selectedNasheed?.id ?? ""
    }
    
    private func miniControllerView() -> some View {
        HStack {
            VStack(alignment: .leading) {
                
                MarqueeText(text: nasheedName, size: 22)
                    .matchedGeometryEffect(id: nasheedName, in: animationNamespaceId)
                    .fontDesign(.serif)
                    .padding(.top, 5)

                Text(reciter)
                    .fontDesign(.serif)
                    .scaledFont(name: "serif", size: 19)
                    .foregroundStyle(.secondary)
                    .matchedGeometryEffect(id: reciter, in: animationNamespaceId)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer(minLength: 0)
            MinimizedController(player: AudioPlayerManager.shared)
                .padding(.trailing, 16)
                .frame(width: 100)
                .padding(.leading, 6)

                
        }
    }
    
    private func fullScreenTextsAndControllers() -> some View {
        Group {
            if !miniHandler.isMinimized {
                VStack {
                    
                    VStack(alignment: .center, spacing: 6){
        
                        AnimatedText(text: nasheedName, font: .title, delay: 0.03,
                                     maxCharsPerLine: UIDevice.current.userInterfaceIdiom == .pad ? 35 : 24)
                            .fontDesign(.serif)
                            .dynamicTypeSize(.xSmall ... .xxLarge)
                            .padding(.horizontal, 20)
                            .id(nasheedID)
                            
                        
                        AnimatedText(text: reciter, font: .title2, delay: 0.03,
                                     maxCharsPerLine: UIDevice.current.userInterfaceIdiom == .pad ? 35 : 24)
                            .fontDesign(.serif)
                            .minimumScaleFactor(dynamicTypeSize.customMinScaleFactor)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .id(nasheedID)
                    }
                    
                    .padding(.horizontal, 10)
    
                    PlayControllerView()
                    
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
