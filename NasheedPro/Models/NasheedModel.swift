//
//  NasheedModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI

/*
 url = https://gist.githubusercontent.com/Abdulbariy-Abdurakhmonov/84e3c82958f40aaf03a604e69a6bd0a3/raw/03488719f558a7d3c6b77cfeafdf37231ed595e0/nasheeds.json
 
 */


//struct NasheedModel: Identifiable, Codable {
//    var id = UUID().uuidString
//    var reciter: String
//    var nasheed: String
//    var image: String
//    var audio: String
//    var isLiked: Bool = false
//    var isDownloaded: Bool = false
//    
//    private enum CodingKeys: String, CodingKey {
//            case reciter, nasheed, image, audio
//        }
//    
//}

final class NasheedModel: Identifiable, ObservableObject, Codable {
    var id = UUID().uuidString
    var reciter: String
    var nasheed: String
    var image: String
    var audio: String
    
    @Published var isLiked: Bool = false
    @Published var isDownloaded: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case reciter, nasheed, image, audio
    }
    
    init(id: String = UUID().uuidString, reciter: String, nasheed: String, image: String, audio: String, isLiked: Bool = false, isDownloaded: Bool = false) {
        self.id = id
        self.reciter = reciter
        self.nasheed = nasheed
        self.image = image
        self.audio = audio
        self.isLiked = isLiked
        self.isDownloaded = isDownloaded
        
    }
}
