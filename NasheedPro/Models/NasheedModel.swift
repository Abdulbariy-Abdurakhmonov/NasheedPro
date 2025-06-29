//
//  NasheedModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUICore

class NasheedModel {
    var reciter: String
    var nasheedName: String
    var picture: Image?
    
    init(reciter: String, nasheedName: String, picture: Image? = nil) {
        self.reciter = reciter
        self.nasheedName = nasheedName
        self.picture = picture
    }
}
