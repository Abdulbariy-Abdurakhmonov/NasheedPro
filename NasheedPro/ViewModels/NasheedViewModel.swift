//
//  NasheedViewModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

//@MainActor
final class NasheedViewModel: ObservableObject {
    
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
    
    
    private var db = Firestore.firestore()

    
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
                return $0.title.localizedCaseInsensitiveContains(text)
            case .reciter:
                return $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    
    //new one
    @MainActor
    func loadNasheeds() async  {
            do {
                let snapshot = try await db.collection("nasheeds").getDocuments()

                var fetched: [NasheedModel] = []
                
                
                for document in snapshot.documents {
                    do {
                        var nasheed = try document.data(as: NasheedModel.self)

                        // Reset local-only properties
                        nasheed.isLiked = false
                        nasheed.isDownloaded = false

                        fetched.append(nasheed)
                    } catch {
                        print("❌ Failed to decode nasheed: \(error)")
                    }
                }

                // Update on main thread
                await MainActor.run {
                    self.nasheeds = fetched

                    // Restore liked state from Core Data
                    let likedIds = likeService.likedEntities.compactMap { $0.likedID }

                    for index in self.nasheeds.indices {
                        if likedIds.contains(self.nasheeds[index].id) {
                            self.nasheeds[index].isLiked = true
                            print("❤️ \(self.nasheeds[index].title) is liked")
                        }
                    }

                    // Update likedNasheeds array
                    self.likedNasheeds = self.nasheeds.filter { $0.isLiked }

                    print("✅ Loaded \(self.nasheeds.count) nasheeds from Firestore")
                }

            } catch {
                print("❌ Error loading nasheeds from Firestore: \(error)")
            }
        }

    
//    func fetchNasheeds() {
//        db.collection("nasheeds").getDocuments { snapshot, error in
//            if let error = error {
//                print("❌ Error fetching nasheeds: \(error.localizedDescription)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("❌ No documents found")
//                return
//            }
//
//            self.nasheeds = documents.compactMap { document in
//                do {
//                    // Decode using your Nasheed struct (with `id` from Firestore field, not @DocumentID)
//                    var nasheed = try document.data(as: NasheedModel.self)
//
//                    // Local-only properties (reset every fetch)
//                    nasheed.isLiked = false
//                    nasheed.isDownloaded = false
//
//                    return nasheed
//                } catch {
//                    print("❌ Failed to decode nasheed: \(error)")
//                    return nil
//                }
//            }
//
//            print("✅ Loaded \(self.nasheeds.count) nasheeds")
//        }
//    }
//
//
//    func loadNasheeds() async {
//        do {
//            let fetched = try await service.fetchMedia()
//
//            await MainActor.run {
//                nasheeds = fetched
//
//                let mappedNasheeds = fetched.map(\.isLiked)
//                print(mappedNasheeds)
//
//                // restore liked state from Core Data
//                let likedIds = likeService.likedEntities.compactMap { $0.likedID }
////                print("liked nasheeds' Ids from Core Data. \(likedIds)")
//
//                for index in nasheeds.indices {
//                    if likedIds.contains(nasheeds[index].id ?? "") {
//                        nasheeds[index].isLiked = true
//                        print("\(nasheeds[index].title). \(nasheeds[index].isLiked)")
//                    }
//                }
//
//                likedNasheeds = nasheeds.filter { $0.isLiked }
////                print("after assigning liked nasheeds:\(likedNasheeds)")
//
//            }
//
//        } catch let error {
//            print(error)
//        }
//    }
//
//

    
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
