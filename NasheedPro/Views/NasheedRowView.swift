//
//  NasheedRowView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct NasheedRowView: View {
    
    let nasheed: NasheedModel
    
    
    var body: some View {
        HStack {
//            Image("nasheedImage")
            ImageLoader(url: nasheed.image)
                .frame(width: 46, height: 46)
                .cornerRadius(36)
                .padding(.trailing, 10)

            VStack(alignment: .leading) {
                Text(nasheed.nasheed)
                    .font(.title3)
                    .fontDesign(.serif)
                    
                Text(nasheed.reciter)
                    .font(.subheadline)
                    .fontDesign(.serif)
                    .foregroundStyle(.secondary)
                
            }
           
            Spacer()
            
            DownloadButtonView()
                .frame(width: 26, height: 26)
        }
        

    }
}

#Preview {
    NasheedRowView(nasheed: dev.mockData)
}
