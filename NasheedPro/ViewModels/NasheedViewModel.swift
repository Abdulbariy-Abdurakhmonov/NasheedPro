//
//  NasheedViewModel.swift
//  NasheedPro
//
//  Created by Abdulboriy on 29/06/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import Combine


final class NasheedViewModel: ObservableObject {
    
    @Published var downloadStates: [String: DownloadButtonView.DownloadState] = [:]
    @Published var downloadedNasheeds: [DownloadedNasheedModel] = []
    
    @Published var likedNasheeds: [NasheedModel] = []
    @Published var nasheeds: [NasheedModel] = []
    @Published var selectedNasheed: NasheedModel?
    
    @Published var searchMode: SearchMode = .title
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLiked: Bool = false
    @Published var currentScope: ScopeType = .all
    
    @Published private(set) var debouncedText: String = ""  // <- for debounce

    private var cancellables = Set<AnyCancellable>() // <- for Combine
    
    let service = MediaService()
    let likeService = LikePersistingService()
    private let firebaseService = FirebaseService()
    let haptic = HapticManager.shared
    private let downloadService = DownloadService()
   

 
    enum ScopeType { case all, liked, downloaded }
    
    enum SearchMode { case reciter, title }
    
    init() {
        
        loadDownloadedNasheeds()
        
        $searchText
             .removeDuplicates()
             .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
             .sink { [weak self] value in
                 guard let self = self else { return }
                 
                 Task { @MainActor in
                     self.debouncedText = value
                 }
             }
             .store(in: &cancellables)
    }
    
    
    // MARK: - Base Source Lists
    var allNasheeds: [NasheedModel] {
        nasheeds
    }
    
    
    var baseNasheeds: [NasheedModel] {
        switch currentScope {
        case .all:
            return allNasheeds
        case .liked:
            return likedNasheeds
        case .downloaded:
            return  downloadedNasheeds.compactMap { local in
                NasheedModel(
                    id: local.id,
                    title: local.title,
                    reciter: local.reciter,
                    imageURL: local.localImageURL.absoluteString,
                    audioURL: local.localAudioURL.absoluteString,
                    isDownloaded: true
                )
            }
        }
    }
    
    
    
    var filteredNasheeds: [NasheedModel] {
        
        searchNasheeds(in: baseNasheeds, using: debouncedText)
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
    

    
    func loadDownloadedNasheeds() {
           downloadedNasheeds = downloadService.loadAllDownloads()
       }

    func stateFor(_ nasheed: NasheedModel) -> DownloadButtonView.DownloadState {
        if let s = downloadStates[nasheed.id] {
            return s
        }
        return downloadedNasheeds.contains(where: { $0.id == nasheed.id }) ? .downloaded : .notDownloaded
    }

    
    
    func downloadNasheed(_ nasheed: NasheedModel) {
        downloadStates[nasheed.id] = .downloading(0.0)

        Task {
            do {
                let downloaded = try await downloadService.downloadNasheed(
                    nasheed,
                    progressHandler: { progress in
                        Task { @MainActor in
                            self.downloadStates[nasheed.id] = .downloading(progress)
                        }
                    }
                )
                
                await MainActor.run {
                    self.downloadedNasheeds.append(downloaded)
                    self.downloadStates[nasheed.id] = .finished
                    haptic.generator.notificationOccurred(.success)

                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
                     
                        if self?.downloadStates[nasheed.id] == .finished {
                            self?.downloadStates[nasheed.id] = .downloaded
                        }
                    }
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = "Download failed: \(error.localizedDescription)"
                    self.downloadStates[nasheed.id] = .notDownloaded
                }
            }
        }

    }


    
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
                   
                   let safeUpdated = updated  // Immutable copy
                   
                   await MainActor.run {
                       self.nasheeds = safeUpdated
                       self.likedNasheeds = safeUpdated.filter { $0.isLiked }
                   }
                   
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
