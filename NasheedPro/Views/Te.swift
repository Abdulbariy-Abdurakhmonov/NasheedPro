//
//  Te.swift
//  NasheedPro
//
//  Created by Abdulboriy on 10/08/25.
//


import SwiftUI
import SDWebImageSwiftUI

//Generic ImageLoader
struct ImageLoader2: View {
    
    let url: String
    
    var body: some View {
     
        Rectangle()
            .opacity(0)
            .overlay {
                SDWebImageLoader2(url: url, contentMode: .fill)
                    .allowsTightening(false)
            }
            .clipped()
        
           
   
            
            
    }
}



//SDWebImageLoader
struct SDWebImageLoader2: View {
    
    let url: String
    let contentMode: ContentMode
    
    var body: some View {
        
        WebImage(url: URL(string: url))
            .resizable()
            .aspectRatio(contentMode: contentMode)
            
            
    }
}

import SwiftUI

struct Te: View {
    
    
    
    var body: some View {
        
        List{
            ForEach(0..<10) {_ in
                HStack {
                    
                    ImageLoader2(url: "https://images.unsplash.com/photo-1526045612212-70caf35c14df")
  
                        .dynamicImageSize(base: 40)
                        .cornerRadius(46)
                        .padding(.trailing, 10)
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "apple.logo")
                            .font(.system(size: 24))
                            
                    }
                    
                }
            }
        }
        .listStyle(.insetGrouped)
       

    }
    
   
    
}

#Preview {
    Te()
}
