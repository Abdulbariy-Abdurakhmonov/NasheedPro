//
//  DownloadButtonView.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import SwiftUI

struct DownloadButtonView: View {
    var body: some View {
        VStack {
            Image(systemName: "icloud.and.arrow.down")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.theme.accent)
                .fontWeight(.semibold)
            
        }
    }
}

#Preview {
    DownloadButtonView()
}
