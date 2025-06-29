//
//  NasheedViewModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI

//@MainActor
final class NasheedViewModel: ObservableObject {
    
    @Published var nasheeds: [NasheedModel] = []
    
    init() {
//        self.nasheeds.append(NasheedModel(reciter: "Muhammad Tohir", nasheedName: "Xuz Dimana"))
//        self.nasheeds.append(NasheedModel(reciter: "Ahmed Bukhatir", nasheedName: "Kun Musliman"))
        getData()

    }
    
    func getData() {
        
        let newNasheeds: [NasheedModel] = [
            NasheedModel(reciter: "Muhammad Tohir", nasheedName: "Xuz Dimana"),
            NasheedModel(reciter: "Unknown", nasheedName: "Kun Musliman"),
            NasheedModel(reciter: "Mishary Al Afasy", nasheedName: "Ana Al Abdu"),
            NasheedModel(reciter: "Ahmed Bukhatir", nasheedName: "Ya Adheeman"),
            NasheedModel(reciter: "Amr Diab", nasheedName: "Habibi ya noor el ein"),
            NasheedModel(reciter: "Unknown", nasheedName: "Xuyulun"),
            NasheedModel(reciter: "Mishary Al Afasy", nasheedName: "Aya Man Yadail Fahm"),
            NasheedModel(reciter: "Ahmed Bukhatir", nasheedName: "Dar al Ghuroor"),
            NasheedModel(reciter: "Mishary Al Arada", nasheedName: "Ashku IlAlloh"),
            NasheedModel(reciter: "Unknown", nasheedName: "Qara Bayraqim"),
            NasheedModel(reciter: "Abu Ali", nasheedName: "Fataat Al Khair"),
            NasheedModel(reciter: "Baraa Masoud", nasheedName: "La La Tahsab Annad Dina")
        ]
        
        self.nasheeds.append(contentsOf: newNasheeds)
        
    }
    
    
    
}
