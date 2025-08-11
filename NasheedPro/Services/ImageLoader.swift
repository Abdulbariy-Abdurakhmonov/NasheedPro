//
//  ImageLoader.swift
//  NasheedPro
//
//  Created by Abdulboriy on 08/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

//Generic ImageLoader
struct ImageLoader: View {
    
    let url: String
    
    var body: some View {
     
        Rectangle()
            .opacity(0)
            .overlay {
                SDWebImageLoader(url: url, contentMode: .fill)
                    .allowsTightening(false)
            }
            .clipped()
    }
}



//SDWebImageLoader 
struct SDWebImageLoader: View {
    
    let url: String
    let contentMode: ContentMode
    
    var body: some View {
        
        WebImage(url: URL(string: url))
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}


