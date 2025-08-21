//
//  DownloadService.swift
//  NasheedPro
//
//  Created by Abdulboriy on 12/08/25.

import Foundation
import SwiftUI


final class DownloadService: NSObject, URLSessionDownloadDelegate {

    var fileManager: FileManager { .default }

    private var progressHandlers: [URL: (Double) -> Void] = [:]
    private var completionHandlers: [URL: (Result<URL, Error>) -> Void] = [:]

    private var downloadsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Downloads", isDirectory: true)
    }

    private lazy var session: URLSession = {
        URLSession(configuration: .default, delegate: self, delegateQueue: .main)
    }()

    override init() {
        super.init()
        try? fileManager.createDirectory(at: downloadsDirectory, withIntermediateDirectories: true)
    }

    // MARK: Public download method with progress
    func downloadNasheed(
        _ nasheed: NasheedModel,
        progressHandler: @escaping (Double) -> Void
    ) async throws -> DownloadedNasheedModel {
        
        // Download audio
        _ = try await downloadFile(
            from: nasheed.audioURL,
            name: "\(nasheed.id).mp3",
            progressHandler: progressHandler
        )
        
        
        _ = try await downloadFile(
            from: nasheed.imageURL,
            name: "\(nasheed.id).jpg"
        )

        let downloaded = DownloadedNasheedModel(
            id: nasheed.id,
            title: nasheed.title,
            reciter: nasheed.reciter,
            audioFileName: "\(nasheed.id).mp3",
            imageFileName: "\(nasheed.id).jpg",
            downloadedAt: Date()
        )

        try saveMetadata(downloaded)
        return downloaded
    }

    // MARK: - Internal
    private func downloadFile(
        from urlString: String,
        name: String,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> URL {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let destinationURL = downloadsDirectory.appendingPathComponent(name)

        return try await withCheckedThrowingContinuation { continuation in
            let task = session.downloadTask(with: url)
            if let handler = progressHandler {
                progressHandlers[url] = handler
            }
            completionHandlers[url] = { result in
                continuation.resume(with: result)
            }
            // Store the intended destination so delegate can use it
            destinationMap[url] = destinationURL
            task.resume()
        }
    }


    private func saveMetadata(_ newDownload: DownloadedNasheedModel) throws {
        var all = loadAllDownloads()
        if !all.contains(where: { $0.id == newDownload.id }) {
            all.append(newDownload)
        }
        let data = try JSONEncoder().encode(all)
        try data.write(to: downloadsDirectory.appendingPathComponent("downloads.json"))
    }

    func loadAllDownloads() -> [DownloadedNasheedModel] {
        let metadataFile = downloadsDirectory.appendingPathComponent("downloads.json")
        guard let data = try? Data(contentsOf: metadataFile) else { return [] }
        return (try? JSONDecoder().decode([DownloadedNasheedModel].self, from: data)) ?? []
    }
    

    // MARK: URLSessionDownloadDelegate
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        guard
            let url = downloadTask.originalRequest?.url,
            let handler = progressHandlers[url],
            totalBytesExpectedToWrite > 0
        else { return }

        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        handler(progress)
    }

    
    private var destinationMap: [URL: URL] = [:]

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        let destinationURL = destinationMap[sourceURL] ?? downloadsDirectory.appendingPathComponent(sourceURL.lastPathComponent)
        try? fileManager.removeItem(at: destinationURL)
        try? fileManager.moveItem(at: location, to: destinationURL)

        completionHandlers[sourceURL]?(.success(destinationURL))
        progressHandlers[sourceURL] = nil
        completionHandlers[sourceURL] = nil
        destinationMap[sourceURL] = nil
    }


    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {
        guard let url = task.originalRequest?.url else { return }
        if let error = error {
            completionHandlers[url]?(.failure(error))
        }
        progressHandlers[url] = nil
        completionHandlers[url] = nil
    }
    
    
    // MARK: - Delete downloaded nasheed
    func deleteNasheed(_ nasheed: DownloadedNasheedModel) throws {
        // Remove files
        try? fileManager.removeItem(at: nasheed.localAudioURL)
        try? fileManager.removeItem(at: nasheed.localImageURL)
        
        // Update metadata
        var all = loadAllDownloads()
        all.removeAll { $0.id == nasheed.id }
        let data = try JSONEncoder().encode(all)
        try data.write(to: downloadsDirectory.appendingPathComponent("downloads.json"))
    }
    
    // MARK: - Reorder
    func saveDownloads(_ updated: [DownloadedNasheedModel]) throws {
        let data = try JSONEncoder().encode(updated)
        try data.write(to: downloadsDirectory.appendingPathComponent("downloads.json"))
    }
    
    func isDownloaded(id: String, in list: [DownloadedNasheedModel]) -> DownloadedNasheedModel? {
        guard let item = list.first(where: { $0.id == id }) else { return nil }
        if FileManager.default.fileExists(atPath: item.localAudioURL.path) {
            return item
        } else {
            return nil 
        }
    }

    
}


    


