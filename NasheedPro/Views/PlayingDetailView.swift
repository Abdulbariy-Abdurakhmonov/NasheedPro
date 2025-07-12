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
    
    @State var isPlaying: Bool = false
    @State private var volume : Double = 0
    
    var nasheed: NasheedModel
    var animationNamespaceId: Namespace.ID
    
    var body: some View {
        //Background Layer
        GeometryReader { proxy in
            VStack(alignment: .center, spacing: 0) {
                
                VStack {
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.35))
                        .frame(width: 40, height: 5)
                        .padding(.top, proxy.safeAreaInsets.top + 10)
                    
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
                    
                
                
                Spacer()
                
                HStack(spacing: 15){
                    
                    // makes the image centered if not minimized, but if minimized, it makes it leading age
                    if miniHandler.isMinimized == false {Spacer(minLength: 0)}
                    
                    Image(nasheed.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: self.imageSize(proxy: proxy), height: self.imageSize(proxy: proxy))
                        .cornerRadius(30)


                    
                    //Mini view
                    if miniHandler.isMinimized {
                        VStack(alignment: .leading) {
                            Text(nasheed.nasheed)
                                .font(.title2)
                                .fontDesign(.serif)
                                .fixedSize(horizontal: true, vertical: false)
                                .matchedGeometryEffect(id: nasheed.nasheed, in: animationNamespaceId)
                            
                            
                            Text(nasheed.reciter)
                                .font(.subheadline)
                                .fontDesign(.serif)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: true, vertical: false)
                                .matchedGeometryEffect(id: nasheed.reciter, in: animationNamespaceId)
                        }
                        
                        Spacer(minLength: 0)
                        self.minimizedControls
                            
                    } else {
                        Spacer(minLength: 0)
                    }
                }
                .padding(.horizontal)
                
             
                
                if self.miniHandler.isMinimized == false {
                    VStack {
                        Text(nasheed.nasheed)
                            .font(.title)
                            .fontDesign(.serif)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .matchedGeometryEffect(id: nasheed.nasheed, in: animationNamespaceId)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        
                        Text(nasheed.reciter)
                            .font(.title2)
                            .fontDesign(.serif)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .matchedGeometryEffect(id: nasheed.reciter, in: animationNamespaceId)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        
                        PlayControllerView(isPlaying: $isPlaying, nasheed: nasheed)
                            .padding(.top)
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                
            }
        }.transition(AnyTransition.move(edge: .bottom))
        
    } //Body
    
        
    var minimizedControls: some View {
        HStack(spacing: 16) {
            Button(action: {}, label: {
                
                Image(systemName: "play.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            })
            
            Button(action: {}, label: {
                
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            })
        }
        .padding(.trailing, 16)
    }
    
    // square shaped, so we only need the edge length
    func imageSize(proxy: GeometryProxy)->CGFloat {
        if miniHandler.isMinimized {
            return 55 + abs(self.miniHandler.draggedOffsetY) / 2
        } else {
            return proxy.size.height * 0.36
        }
        
    }
    
} //Struct





#Preview {
    @Previewable @Namespace var previewNamespace
    NavigationStack {
        PlayingDetailView(nasheed: dev.mockData, animationNamespaceId: previewNamespace)
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
    
}
