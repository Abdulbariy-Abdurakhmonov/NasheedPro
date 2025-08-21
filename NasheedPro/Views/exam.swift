//
//  exam.swift
//  NasheedPro
//
//  Created by Abdulboriy on 21/08/25.
//

import SwiftUI

struct exam: View {
    var body: some View {
        Image(.logo)
            .resizable()
            .background(.red)
            .frame(width: 280, height: 280)
            .clipShape(.rect(cornerRadius: 20))
    }
}

#Preview {
    exam()
}
