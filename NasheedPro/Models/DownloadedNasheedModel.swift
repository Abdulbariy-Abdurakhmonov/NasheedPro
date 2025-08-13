//
//  DownloadingsModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 11/08/25.
//

import Foundation


struct DownloadedNasheedModel: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let reciter: String
    
    // Local file URLs (these are saved files on device)
    let localAudioURL: URL
    let localImageURL: URL
    
    // Download date (optional, for sorting)
    let downloadedAt: Date
}
