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
    
    let mockData = NasheedModel(id: "", title: "This is nasheed to be previewed", reciter: "Abdulboriy Mashhur", imageURL: "", audioURL: "", isLiked: false, isDownloaded: false)
    let fakeShortTitle = "Huz Dimana"
    let fakeLongTitle = "This is ver long nasheed to listen"
    let fakeReciter = "Abdulboriy Mashhur"
    
    let mockList = ListVIew(title: "Online Nasheeds", emptyMessage: "No nasheeds yet.", emptyIcon: "questionmark.circle", emptyDescription: "Be online to discover nasheed.", nasheedsOf: NasheedViewModel().filteredNasheeds, selectedNasheed: .constant(.none))
    
    
    
}

let dev = DeveloperPreview.instance
