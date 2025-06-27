//
//  ContentView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 27/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12){
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.pink)
            Text("Hello, world!")
            Text("Second change has been made!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
