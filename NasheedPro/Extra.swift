//
//  Extra.swift
//  NasheedPro
//
//  Created by Abdulboriy on 28/06/25.
//

import SwiftUI

struct Extra: View {
    var body: some View {
        ForEach(0..<5) {_ in
            Image(systemName: "tree.fill")
                .resizable()
                .scaledToFit()
//                .frame(width: 300, height: 300)
                .foregroundStyle(.green)
        } // Still working
            
    }
}

#Preview {
    Extra()
}
