//
//  NasheedModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

//import Foundation
//import SwiftUI
//
//
//
//struct NasheedModel: Identifiable,Equatable, Codable {
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

import Foundation
import FirebaseFirestore

struct NasheedModel: Identifiable, Codable, Equatable {
    var id: String   
    var title: String
    var reciter: String
    var imageURL: String
    var audioURL: String

    // Local-only properties (won't be synced to Firestore)
    var isLiked: Bool = false
    var isDownloaded: Bool = false

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case reciter
        case imageURL
        case audioURL
        // Note: isLiked and isDownloaded are intentionally left out
    }
}




