//
//  NobelPrizeService.swift
//  NobelHistory
//
//  Created by Lars Dahmen on 20.09.23.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidData
    case badResponse
    case missingData
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "The URL provided was invalid."
        case .invalidData:
            return "The data received was invalid."
        case .badResponse:
            return "The response from the server was not as expected."
        case .missingData:
            return "Data is missing from the response."
        }
    }
}

class NobelPrizeService {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    private let baseUrlString = "https://api.nobelprize.org/2.0"
    
    private var nobelPrizesUrl: URL? {
        return URL(string: "\(baseUrlString)/nobelPrizes")
    }
    
    private var nobelPrizeFilterUrl: URL? {
        return URL(string: "\(baseUrlString)/nobelPrize")
    }
    
    private var laureateUrl: URL? {
        return URL(string: "\(baseUrlString)/laureate/")
    }
    
    /// Generic network fetch method to reduce code duplication
    private func fetch<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await session.data(from: url)
        
        // Ensure we have a valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.badResponse
        }
        
        // Attempt to decode the data
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.dataCorrupted {
            throw NetworkError.invalidData
        } catch {
            throw error
        }
    }
    
    /// Fetch Nobel Prize
    func fetchNobelPrizes(offset: Int = 0,
                          limit: Int = 20) async throws -> [NobelPrize] {
        guard var components = URLComponents(url: nobelPrizesUrl!, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidUrl
        }
        
        components.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = components.url else {
            throw NetworkError.invalidUrl
        }
        
        let response: NobelPrices = try await fetch(from: url)
               return response.nobelPrizes
    }
    
    /// Fetch details of a specific Nobel laureate
    func fetchLaureateDetails(id: String) async throws -> NobelLaureate? {
        guard let url = laureateUrl?.appendingPathComponent(id) else {
            throw NetworkError.invalidUrl
        }
        
        let laureates: [NobelLaureate] = try await fetch(from: url)
        return laureates.first
    }
    
    /// Fetch Nobel Prizes for a specific category and year
    func fetchFilteredNobelPrizes(category: String, year: String) async throws -> NobelPrize {
        guard let url = nobelPrizeFilterUrl?.appendingPathComponent(category).appendingPathComponent(year) else {
            throw NetworkError.invalidUrl
        }
        
        let filteredPrizes: [NobelPrize] = try await fetch(from: url)
        
        // Ensure that we have at least one Nobel Prize in the response
        guard let firstPrize = filteredPrizes.first else {
            throw NetworkError.missingData
        }
        
        return firstPrize
    }
}
