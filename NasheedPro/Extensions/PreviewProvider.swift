//
//  PreviewProvider.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI


class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init() { }

    let nasheedVM = NasheedViewModel()
    let mockData = NasheedModel(reciter: "Muhammad Tohir", nasheedName: "Xuz Dimana", picture: Image("nasheedImage"))
    
    
}

let dev = DeveloperPreview.instance
