//
//  UnavailableView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 28/07/25.
//

import SwiftUI

struct UnavailableView: View {
    
    let searchResult: String?
    
    var body: some View {
        
        VStack(spacing: 0){
                
                Image("sad_magnifier2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                
                Text("No Nasheeds")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)
                
                if let text = searchResult {
                    Text("No results found for \"\(text)\"")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
         
            }

                    
    }
}

#Preview {
    UnavailableView(searchResult: "ABC")
}
