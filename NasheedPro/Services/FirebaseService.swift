//
//  FirebaseService.swift
//  NasheedPro
//
//  Created by Abdulboriy on 07/08/25.
//

import Foundation
import FirebaseFirestore


final class FirebaseService {
    //    private let db = Firestore.firestore()
    
    //    func fetchNasheeds() async throws -> [NasheedModel] {
    //
    //        let snapshot = try await db.collection("nasheeds").getDocuments()
    //
    //        var fetched: [NasheedModel] = []
    //
    //        for document in snapshot.documents {
    //            do {
    //                var nasheed = try document.data(as: NasheedModel.self)
    //                nasheed.isLiked = false
    //                nasheed.isDownloaded = false
    //                fetched.append(nasheed)
    //            } catch {
    //                print("❌ Failed to decode nasheed: \(error)")
    //            }
    //        }
    //
    //        return fetched
    //    }
    
    func fetchNasheeds() async throws -> [NasheedModel] {
            try await withCheckedThrowingContinuation { continuation in
                Firestore.firestore()
                    .collection("nasheeds")
                    .getDocuments { snapshot, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                            return
                        }
                        guard let snapshot = snapshot else {
                            continuation.resume(returning: [])
                            return
                        }
                        let models: [NasheedModel] = snapshot.documents.compactMap { doc in
                            try? doc.data(as: NasheedModel.self)
                        }
                        continuation.resume(returning: models)
                    }
            }
        }
    
}
