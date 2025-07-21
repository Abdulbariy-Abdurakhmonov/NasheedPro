//
//  NasheedProApp.swift
//  NasheedPro
//
//  Created by Abdulboriy on 27/06/25.
//

import SwiftUI
import MinimizableView

@main
struct NasheedProApp: App {
    
    @StateObject private var viewmodel = NasheedViewModel()
    @StateObject private var miniHandler = MinimizableViewHandler()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
            .environmentObject(viewmodel)
            .environmentObject(miniHandler)
            
        }
        
    }
}
