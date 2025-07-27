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
                let copy = nasheed
                copy.id = "FAKE_ID_\(index)" // or "\(nasheed.title)_ID"
                return copy
            }
            
            
            await MainActor.run {
//                nasheeds = fetched -> for real Id comes
                nasheeds = withFakeIDs
                
                // restore liked state from Core Data
                let likedIds = likeService.likedEntities.compactMap { $0.likedID }
                print("liked nasheeds' Ids from Core Data. \(likedIds)")
                
                print("Fetched nasheeds: \(nasheeds)")
                for index in nasheeds.indices {
                    if likedIds.contains(nasheeds[index].id) {
                        nasheeds[index].isLiked = true
                        print("if statement executed. \(nasheeds[index].id),\(nasheeds[index].isLiked)")
                    }
                }
                
                likedNasheeds = nasheeds.filter { $0.isLiked }
                print("after assigning liked nasheeds:\(likedNasheeds)")
                
            }
            
        } catch let error {
            print(error)
        }
    }
    
    
    
    func toggleLike(for nasheed: NasheedModel) {
        print("toggle like has bees started")
        guard let index = nasheeds.firstIndex(where: { $0.id == nasheed.id }) else { print("cannot find the index"); return }
        print("recently liked nasheed Before toggle: \(nasheed.id),\(nasheed.isLiked)")
        
        nasheeds[index].isLiked.toggle()
        print("recently liked nasheed After toggle: \(nasheed.id),\(nasheed.isLiked)")
        
        objectWillChange.send()

        let updated = nasheeds[index]

        if updated.isLiked {
            print("before adding to Core Data:\(likeService.likedEntities)")
            likeService.add(nasheed: updated)
            print("after adding to Core Data:\(likeService.likedEntities)")
            
            // Updating likedNasheeds array after adding new liked nasheed
            likedNasheeds = nasheeds.filter { $0.isLiked }
            
        } else {
            // Find and delete matching entity from Core Data
            if let entity = likeService.likedEntities.first(where: { $0.likedID == updated.id }) {
                likeService.delete(entity: entity)
                print("recently unliked nasheed id: \(entity)")
                print(likeService.likedEntities)
                
                likedNasheeds = nasheeds.filter { $0.isLiked }
            }
        }
    }

    
}
