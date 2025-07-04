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
                    
                    Image("nasheedImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: self.imageSize(proxy: proxy), height: self.imageSize(proxy: proxy))
                        .cornerRadius(15)
                    
                    
                    
                    
                    //Mini view
                    if miniHandler.isMinimized{
                        VStack(alignment: .leading) {
                            Text(nasheed.nasheedName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .fixedSize(horizontal: true, vertical: false)
                                .matchedGeometryEffect(id: nasheed.nasheedName, in: animationNamespaceId)
                            
                            
                            Text(nasheed.reciter)
                                .font(.title3)
                                .fontWeight(.medium)
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
//                    self.expandedControls(safeInsets: proxy.safeAreaInsets)
                    VStack {
                        Text(nasheed.nasheedName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .matchedGeometryEffect(id: nasheed.nasheedName, in: animationNamespaceId)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        
                        Text(nasheed.reciter)
                            .fontWeight(.medium)
                            .font(.title3)
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
        Group {
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
    NavigationStack {
        PlayingDetailView(nasheed: dev.mockData, animationNamespaceId: try! Namespace().wrappedValue)
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
    
}
