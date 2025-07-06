

import SwiftUI
import MinimizableView

struct MainView: View {
    @EnvironmentObject var viewModel: NasheedViewModel
    @EnvironmentObject var miniHandler: MinimizableViewHandler
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTabIndex: Int = 0
    @State var miniViewBottomMargin: CGFloat = 0
    @GestureState var dragOffset = CGSize.zero
    @Namespace var namespace
    @State var selectedNasheed: NasheedModel? = nil

    
    var body: some View {
               GeometryReader { proxy in

                       TabView(selection: self.$selectedTabIndex) {
                                   
                           OnlineView(selectedNasheed: $selectedNasheed)
                               .tabItem {
                                   Image(systemName: "headphones")
                                   Text("Stream")
                           }.tag(0)
                           .background(TabBarAccessor { tabBar in        // add to update the minimizedBottomMargin dynamically!
                                   self.miniViewBottomMargin = tabBar.bounds.height - 1
                               })
                           
                           Text("More stuff")
                               .tabItem {
                               Image(systemName: "heart.fill")
                               Text("Favourites")
                           }.tag(1)
                           
                           Text("3rd stuff")
                               .tabItem {
                               Image(systemName: "bookmark.fill")
                               Text("Downloads")
                           }.tag(2)
                           
                           
                       }.background(Color(.secondarySystemFill))
                       .statusBar(hidden: self.miniHandler.isPresented && self.miniHandler.isMinimized == false)
                       .minimizableView(content: {
                           if let nasheed = selectedNasheed {
                               PlayingDetailView(nasheed: nasheed, animationNamespaceId: self.namespace)
                           }
                       },
                         compactView: {
                           EmptyView()
                           
                       }, backgroundView: {
                           self.backgroundView()},
                           dragOffset: $dragOffset,
                           dragUpdating: { (value, state, transaction) in
                               state = value.translation
                               self.dragUpdated(value: value)
          
                       }, dragOnChanged: { (value) in
                               // add some custom logic if needed
                       },
                           dragOnEnded: { (value) in
                           self.dragOnEnded(value: value)
                       }, minimizedBottomMargin: self.miniViewBottomMargin, settings: MiniSettings(minimizedHeight: 80))
                   
                       .environmentObject(self.miniHandler)
                       
            
               }
           
           }
           
           
           func backgroundView() -> some View {
               VStack(spacing: 0){
                   Color.init(uiColor: .systemBackground)
                   if self.miniHandler.isMinimized {
                       Divider()
                   }
               }.cornerRadius(self.miniHandler.isMinimized ? 0 : 20)
                .shadow(color: .gray.opacity(self.colorScheme == .light ? 0.18 : 0), radius: 5, x: 0, y: -5)
               .onTapGesture(perform: {
                   if self.miniHandler.isMinimized {
                       self.miniHandler.expand()
                       //alternatively, override the default animation. self.miniHandler.expand(animation: Animation)
                   }
               })
           }
           
           
           func dragUpdated(value: DragGesture.Value) {
               
               if self.miniHandler.isMinimized == false && value.translation.height > 0   { // expanded state
                   
                   self.miniHandler.draggedOffsetY = value.translation.height  // divide by a factor > 1 for more "inertia" if needed
                   
               } else if self.miniHandler.isMinimized && value.translation.height < 0   {// minimized state
                   self.miniHandler.draggedOffsetY = value.translation.height  // divide by a factor > 1 for more "inertia" if needed
                   
               }
           }
           
           func dragOnEnded(value: DragGesture.Value) {
               
               if self.miniHandler.isMinimized == false && value.translation.height > 90  {
                   self.miniHandler.minimize()

               } else if self.miniHandler.isMinimized &&  value.translation.height < -60 {
                         self.miniHandler.expand()
               }
              withAnimation(.spring()) {
                   self.miniHandler.draggedOffsetY = 0
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
