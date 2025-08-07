//
//  NasheedViewModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore


final class NasheedViewModel: ObservableObject {
    
    @Published var likedNasheeds: [NasheedModel] = []
    
    @Published var nasheeds: [NasheedModel] = []
    
    @Published var selectedNasheed: NasheedModel?
    
    @Published var searchMode: SearchMode = .title
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLiked: Bool = false
    
    let service = MediaService()
    let likeService = LikePersistingService()
    
    private let firebaseService = FirebaseService()
   

    
    @Published var currentScope: ScopeType = .all
    
    enum ScopeType {
        case all
        case liked
        case downloaded
    }
    
    enum SearchMode {
        case reciter
        case title
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
            case .title:
                return $0.title.localizedCaseInsensitiveContains(text)
            case .reciter:
                return $0.reciter.localizedCaseInsensitiveContains(text)
            }
        }
        
    }
    
    
    //new one
    @MainActor
    func loadNasheeds() {
           Task {
               do {
                   let fetched = try await firebaseService.fetchNasheeds()

                   var updated = fetched

                   // Restore liked state from Core Data (off-main-thread is OK)
                   let likedIds = likeService.likedEntities.compactMap { $0.likedID }

                   for index in updated.indices {
                       if likedIds.contains(updated[index].id) {
                           updated[index].isLiked = true
                       }
                   }

                   self.nasheeds = updated
                   self.likedNasheeds = updated.filter { $0.isLiked }

                   print("✅ Loaded \(updated.count) nasheeds")
               } catch {
                   print("❌ Error loading nasheeds: \(error)")
               }
           }
       }
    

    
    func toggleLike(for nasheed: NasheedModel?) {
        selectedNasheed?.isLiked.toggle()
        guard let index = nasheeds.firstIndex(where: { $0.id == nasheed?.id ?? "" }) else {
            print("Cannot find the index")
            return
        }

        guard let selectedNasheed else { return }

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
