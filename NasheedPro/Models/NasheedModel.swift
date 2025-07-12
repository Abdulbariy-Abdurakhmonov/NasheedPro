//
//  NasheedModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUICore

/*
 url = https://gist.githubusercontent.com/Abdulbariy-Abdurakhmonov/84e3c82958f40aaf03a604e69a6bd0a3/raw/03488719f558a7d3c6b77cfeafdf37231ed595e0/nasheeds.json
 
 


 
 */


struct NasheedModel: Identifiable, Codable {
    var id = UUID().uuidString
    let reciter: String
    let nasheed: String
    let image: String
    let audio: String
    
    private enum CodingKeys: String, CodingKey {
            case reciter, nasheed, image, audio
        }
    
}
