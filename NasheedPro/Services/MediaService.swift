//
//  MediaService.swift
//  NasheedPro
//
//  Created by Abdulboriy on 09/07/25.
//

import Foundation

class MediaService {
    
    func fetchMedia() async throws -> [NasheedModel] {
        let urlString = "https://gist.githubusercontent.com/Abdulbariy-Abdurakhmonov/84e3c82958f40aaf03a604e69a6bd0a3/raw/03488719f558a7d3c6b77cfeafdf37231ed595e0/nasheeds.json"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode([NasheedModel].self, from: data)
        return decoded

    }
 
    
}
