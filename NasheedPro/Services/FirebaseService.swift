//
//  FirebaseService.swift
//  NasheedPro
//
//  Created by Abdulboriy on 07/08/25.
//

import Foundation

import FirebaseFirestore


final class FirebaseService {
    private let db = Firestore.firestore()

    func fetchNasheeds() async throws -> [NasheedModel] {
        let snapshot = try await db.collection("nasheeds").getDocuments()

        var fetched: [NasheedModel] = []

        for document in snapshot.documents {
            do {
                var nasheed = try document.data(as: NasheedModel.self)
                nasheed.isLiked = false
                nasheed.isDownloaded = false
                fetched.append(nasheed)
            } catch {
                print("❌ Failed to decode nasheed: \(error)")
            }
        }

        return fetched
    }
}
