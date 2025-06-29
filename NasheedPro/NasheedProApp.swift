//
//  NasheedProApp.swift
//  NasheedPro
//
//  Created by Abdulboriy on 27/06/25.
//

import SwiftUI

@main
struct NasheedProApp: App {
    
    @StateObject private var viewmodel = NasheedViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
            .environmentObject(viewmodel)
        }
    }
}
