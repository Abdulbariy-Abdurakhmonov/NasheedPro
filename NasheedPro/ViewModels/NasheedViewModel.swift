//
//  NasheedViewModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI

//@MainActor
    class NasheedViewModel: ObservableObject {
    
    @Published var nasheeds: [NasheedModel] = []
    @Published var searchMode: SearchMode = .nasheed
    @Published var searchText: String = ""
        
    @Published var isLoading = false
    @Published var errorMessage: String?
        
    let service = MediaService()
    
    enum SearchMode {
        case reciter
        case nasheed
    }
    
    var filteredNasheeds: [NasheedModel] {
        
        
        if searchText.isEmpty {
            return nasheeds
        } else {
            return nasheeds.filter {
                searchMode == .nasheed ? $0.nasheed.localizedCaseInsensitiveContains(searchText)
                : $0.reciter.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    
//    init() {
//
//
//    }
    
    func loadNasheeds() async {
        
        do {
            let fetched = try await service.fetchMedia()
            await MainActor.run {
                nasheeds = fetched
            }
            
        } catch let error {
            print(error)
        }
        
        
    }
    
    
    
}
