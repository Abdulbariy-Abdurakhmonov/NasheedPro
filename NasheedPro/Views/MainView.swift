///
///  MainView.swift
///  NasheedPro
///
/// Created by Abdulboriy on 29/06/25.



import SwiftUI
import MinimizableView

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var miniHandler = MinimizableViewHandler()
    @State var selectedTabIndex: Int = 0
    @State var miniViewBottomMargin: CGFloat = 0
    @GestureState var dragOffset = CGSize.zero
    @Namespace var namespace
    
    var body: some View {
               GeometryReader { proxy in

                       TabView(selection: self.$selectedTabIndex) {
                           
                           Button(action: {
                               print(proxy.safeAreaInsets.bottom)
                               self.miniHandler.present()
                               
                           }) { Text("Launch Minimizable View").foregroundStyle(.green).disabled(self.miniHandler.isPresented)}
                                   
                               
                               .tabItem {
                                   Image(systemName: "chevron.up.square.fill")
                                   Text("Main View")
                           }.tag(0)
                           .background(TabBarAccessor { tabBar in        // add to update the minimizedBottomMargin dynamically!
                                   self.miniViewBottomMargin = tabBar.bounds.height - 1
                               })
                           
                           Text("More stuff")
                               .tabItem {
                               Image(systemName: "dot.square.fill")
                               Text("2nd View")
                           }.tag(1)
                           
                           Text("3rd stuff")
                               .tabItem {
                               Image(systemName: "square.split.2x1.fill")
                               Text("List View")
                           }.tag(2)
                           
                           
                       }.background(Color(.secondarySystemFill))
                       .statusBar(hidden: self.miniHandler.isPresented && self.miniHandler.isMinimized == false)
                       .minimizableView(content: {PlayingDetailView(nasheed: dev.mockData, animationNamespaceId: self.namespace)},
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
}
