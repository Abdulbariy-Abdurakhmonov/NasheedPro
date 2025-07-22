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
    
    @Published var isLiked: Bool = false
    
    let service = MediaService()
    
    @Published var currentScope: ScopeType = .all
    
  
    
    enum ScopeType {
        case all
        case liked
        case downloaded
    }
    
    
    enum SearchMode {
        case reciter
        case nasheed
    }
    
    
    
    // MARK: - Base Source Lists
    var allNasheeds: [NasheedModel] {
        nasheeds
    }

    var likedNasheeds: [NasheedModel] {
        nasheeds.filter { $0.isLiked }
    }

    var downloadedNasheeds: [NasheedModel] {
        nasheeds.filter { $0.isDownloaded }
    }
    
    
    var baseNasheeds: [NasheedModel] {
        switch currentScope {
        case .all:
            return allNasheeds
        case .liked:
            return likedNasheeds
        case .downloaded:
            return downloadedNasheeds
        }
    }
    
    
    var filteredNasheeds: [NasheedModel] {
        searchNasheeds(in: baseNasheeds, using: searchText)
    }
    
    
    func searchNasheeds(in source: [NasheedModel], using text: String) -> [NasheedModel] {
        guard !text.isEmpty else { return source }

        return source.filter {
            switch searchMode {
            case .nasheed:
                return $0.nasheed.localizedCaseInsensitiveContains(text)
            case .reciter:
                return $0.reciter.localizedCaseInsensitiveContains(text)
            }
        }
    }

    
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
    
    
    func toggleLike(for nasheed: NasheedModel) {
        nasheed.isLiked.toggle()
        
        if let index = nasheeds.firstIndex(where: { $0.id == nasheed.id }) {
            nasheeds[index].isLiked = nasheed.isLiked
            objectWillChange.send()
        }

        
    }
    
    
}
