

import SwiftUI
import MinimizableView

struct MainView: View {
    @EnvironmentObject var viewModel: NasheedViewModel
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @State var miniViewBottomMargin: CGFloat = 0
    @GestureState var dragOffset = CGSize.zero
    @Namespace var namespace
    @State var selectedNasheed: NasheedModel? = nil
    
    @StateObject private var miniVM: MiniViewModel

        init() {
            _miniVM = StateObject(wrappedValue: MiniViewModel(miniHandler: MinimizableViewHandler(), colorScheme: .light))}
    
    
    var body: some View {
        
        TabView {
            NavigationView {
                OnlineView(selectedNasheed: $selectedNasheed)
                
            }
            .tabItem {
                Image(systemName: "headphones")
                Text("Stream")
            }.tag(0)
                .background(TabBarAccessor { tabBar in 
                    self.miniViewBottomMargin = tabBar.bounds.height - 1
                })
            
            NavigationView {
                LikedView()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favourites")
            }.tag(1)
            
            NavigationView {
                DownloadedView()
            }
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("Downloads")
            }.tag(2)
        }
        
        .background(Color(.secondarySystemFill))
        .statusBar(hidden: self.miniHandler.isPresented && self.miniHandler.isMinimized == false)
        .minimizableView(content: {
            if let nasheed = selectedNasheed {
                PlayingDetailView(nasheed: nasheed, animationNamespaceId: self.namespace)
            }
        },
                         compactView: {
            EmptyView()
            
        }, backgroundView: {
            miniVM.backgroundView()},
                         dragOffset: $dragOffset,
                         dragUpdating: { (value, state, transaction) in
            state = value.translation
            miniVM.dragUpdated(value: value)
            
        }, dragOnChanged: { (value) in
            // add some custom logic if needed
        },
                         dragOnEnded: { (value) in
            miniVM.dragOnEnded(value: value)
        }, minimizedBottomMargin: self.miniViewBottomMargin, settings: MiniSettings(minimizedHeight: 80))
        
        .environmentObject(self.miniHandler)
        .onAppear {
            miniVM.setHandler(miniHandler)
        }
        
    }
    
}



#Preview {
    NavigationStack {
        MainView()
    }
    .environmentObject(dev.nasheedVM)
    .environmentObject(MinimizableViewHandler())
//    .preferredColorScheme(.dark)
}
