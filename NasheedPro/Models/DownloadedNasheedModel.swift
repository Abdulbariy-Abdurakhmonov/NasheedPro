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
    let audioFileName: String   
    let imageFileName: String
    let downloadedAt: Date
}
