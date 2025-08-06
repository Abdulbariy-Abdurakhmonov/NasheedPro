//
//  NasheedProApp.swift
//  NasheedPro
//
//  Created by Abdulboriy on 27/06/25.
//

import SwiftUI
import MinimizableView
import FirebaseCore


@main
struct NasheedProApp: App {
    @StateObject private var viewmodel = NasheedViewModel()
    @StateObject private var miniHandler = MinimizableViewHandler()
    @State private var showLaunchView: Bool = true
    
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase")
    }
    
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    MainView()
                }
                .environmentObject(viewmodel)
                .environmentObject(miniHandler)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
                
            }

        }
        
    }
}
