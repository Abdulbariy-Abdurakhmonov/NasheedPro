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
    
    @Published var likedNasheeds: [NasheedModel] = []
    
    @Published var nasheeds: [NasheedModel] = []
    
    @Published var selectedNasheed: NasheedModel?
    
    @Published var searchMode: SearchMode = .nasheed
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLiked: Bool = false
    
    let service = MediaService()
    let likeService = LikePersistingService()

    
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
            
            
            // Generate fake IDs based on index or title (consistent pattern)
            let withFakeIDs = fetched.enumerated().map { index, nasheed in
                var copy = nasheed
                copy.id = "FAKE_ID_\(index)" // or "\(nasheed.title)_ID"
                return copy
            }
            
            
            await MainActor.run {
//                nasheeds = fetched -> for real Id comes
                nasheeds = withFakeIDs

                let mappedNasheeds = withFakeIDs.map(\.isLiked)
                print(mappedNasheeds)
                
                // restore liked state from Core Data
                let likedIds = likeService.likedEntities.compactMap { $0.likedID }
//                print("liked nasheeds' Ids from Core Data. \(likedIds)")
                
//                print("Fetched nasheeds: \(nasheeds)")
                for index in nasheeds.indices {
                    if likedIds.contains(nasheeds[index].id) {
                        nasheeds[index].isLiked = true
                        print("\(nasheeds[index].nasheed). \(nasheeds[index].isLiked)")
                    }
                }
                
                likedNasheeds = nasheeds.filter { $0.isLiked }
//                print("after assigning liked nasheeds:\(likedNasheeds)")
                
            }
            
        } catch let error {
            print(error)
        }
    }
    
    

    
    func toggleLike(for nasheed: NasheedModel?) {
        selectedNasheed?.isLiked.toggle()
        guard let index = nasheeds.firstIndex(where: { $0.id == nasheed?.id ?? "" }) else {
            print("Cannot find the index")
            return
        }

        // Mutate a copy, then reassign
        guard let selectedNasheed else { return }
//        var updated = nasheeds[index]
//        updated.isLiked.toggle()
        
        
        nasheeds[index] = selectedNasheed

        objectWillChange.send()

        if selectedNasheed.isLiked {
            likeService.add(nasheed: selectedNasheed)
            likedNasheeds = nasheeds.filter { $0.isLiked }
        } else {
            if let entity = likeService.likedEntities.first(where: { $0.likedID == selectedNasheed.id }) {
                likeService.delete(entity: entity)
                likedNasheeds = nasheeds.filter { $0.isLiked }
            }
        }
    }


    
    
}
