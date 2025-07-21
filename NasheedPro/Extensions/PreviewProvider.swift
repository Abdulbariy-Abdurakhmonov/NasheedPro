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
    
    let mockData = NasheedModel(reciter: "Muhammad Tohir", nasheed: "New Nasheed publish", image: "https://cdn.pixabay.com/photo/2016/10/13/09/06/lake-1733352_1280.jpg", audio: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3", isLiked: false, isDownloaded: false)
    
    let mockList = ListVIew(title: "Online Nasheeds", emptyMessage: "No nasheeds yet.", emptyIcon: "questionmark.circle", emptyDescription: "Be online to discover nasheed.", nasheedsOf: NasheedViewModel().filteredNasheeds, selectedNasheed: .constant(.none))
    
    
    
}

let dev = DeveloperPreview.instance
