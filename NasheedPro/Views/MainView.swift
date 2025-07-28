

import SwiftUI
import MinimizableView

struct MainView: View {
    
    
    @EnvironmentObject var viewModel: NasheedViewModel
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @Namespace var namespace
    @State var miniViewBottomMargin: CGFloat = 0
    @State var selectedNasheed: NasheedModel? = nil
    @StateObject private var miniVM: MiniViewModel

        init() {
            _miniVM = StateObject(wrappedValue: MiniViewModel(miniHandler: MinimizableViewHandler(), colorScheme: .light))}
    
    
    var body: some View {
        tabViews
        .task {
            await viewModel.loadNasheeds()
            }
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





extension MainView {
    private var tabViews: some View {
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
                LikedView(selectedNasheed: $selectedNasheed)
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favourites")
            }.tag(1)
            
            NavigationView {
                DownloadedView(selectedNasheed: $selectedNasheed)
            }
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("Downloads")
            }.tag(2)
        }
        .modifier(miniPlayerModifier())
        .environmentObject(self.miniHandler)
    }
    
    
    
    func miniPlayerModifier() -> some ViewModifier {
        MiniPlayerModifier(
            namespace: self.namespace,
            miniHandler: self.miniHandler,
            miniViewBottomMargin: self.miniViewBottomMargin,
            content: {
//                if let nasheed = self.selectedNasheed {
                if let _ = viewModel.selectedNasheed {
                    return AnyView(PlayingDetailView(animationNamespaceId: self.namespace))
                } else {
                    return AnyView(EmptyView())
                }
            },
            compactView: { AnyView(EmptyView()) },
            backgroundView: { AnyView(miniVM.backgroundView()) },
            dragUpdated: { value in miniVM.dragUpdated(value: value) },
            dragEnded: { value in miniVM.dragOnEnded(value: value) }
        )
    }
    
    
}

