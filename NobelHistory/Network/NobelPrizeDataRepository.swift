//
//  NobelPrizeDataRepository.swift
//  NobelHistory
//
//  Created by Lars Dahmen on 20.09.23.
//

import Foundation

class NobelPrizeDataRepository {
    static let shared = NobelPrizeDataRepository(service: NobelPrizeService())
    
    private let service: NobelPrizeService

    init(service: NobelPrizeService) {
        self.service = service
    }
    
    func getNobelPrizes(offset: Int = 0,
                        limit: Int = 20) async throws -> [NobelPrize] {
        do {
            return try await service.fetchNobelPrizes(offset: offset,
                                                      limit: limit)
        } catch {
            print("Error fetching Nobel Prizes: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getNobelLaureateDetails(id: String) async throws -> NobelLaureate? {
        do {
            return try await service.fetchLaureateDetails(id: id)
        } catch {
            print("Error fetching laureate details: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getFilteredNobelPrizes(category: String,
                                year: String) async throws -> NobelPrize {
        do {
            return try await service.fetchFilteredNobelPrizes(category: category,
                                                              year: year)
        } catch {
            print("Error fetching filtered Nobel Prizes: \(error.localizedDescription)")
            throw error
        }
    }
}
