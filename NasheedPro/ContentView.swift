//
//  ContentView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 27/06/25.
//


/*
 Commit messages:
NEW FEATURE:
[Feature] Description of the new feature
 
BUG IN PRODUCTION: something that is working in app but should be changed
[Patch] Description of Patch
 
BUG NOT IN PRODUCTION:
[Bag] Description of Bag
 
MUNDANE TASKS:
[Clean] Description of changes
 
RELEASE(Big change/Feature readey to publish)
[Release] Description of Relese
 
 */

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 12){
            Image(systemName: "heart.fill")
                .imageScale(.large)
                .foregroundStyle(.pink)
            Text("Hello, world!")
            Text("Second change has been made!")
            
            Button("Start") {
                
            }
            .tint(.red)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
