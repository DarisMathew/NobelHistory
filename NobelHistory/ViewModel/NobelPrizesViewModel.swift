//
//  NobelPrizesViewModel.swift
//  NobelHistory
//
//  Created by Daris Mathew on 21.09.23.
//

import Foundation


class NobelPrizesViewModel {
    private let repository: NobelPrizeDataRepository
    var nobelPrizes: [NobelPrize] = []
    var isLoading = false
    var offset = 0
    let limit = 20
    var currentCategory: String? = nil
    var currentYear: String? = nil
    var isFilterEnabled = false
    var dataChangeHandler: (() -> Void)?
    
    init(repository: NobelPrizeDataRepository, dataChangeHandler: (() -> Void)? = nil) {
        self.repository = repository
        self.dataChangeHandler = dataChangeHandler
    }
    
    func updateData() async throws {
        guard !isLoading else { return }
        isLoading = true
        defer {
            isLoading = false
        }
        
        do {
            let newPrizes: [NobelPrize]
            if isFilterEnabled, let category = currentCategory, let year = currentYear {
                // Fetch filtered data
                newPrizes = [try await repository.getFilteredNobelPrizes(category: category, year: year)]
            } else {
                // Fetch paginated data
                newPrizes = try await repository.getNobelPrizes(offset: offset, limit: limit)
            }
            
            appendNewPrizes(newPrizes)
            notifyDataChanged()
        } catch {
            print("Error fetching data: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func appendNewPrizes(_ newPrizes: [NobelPrize]) {
        let startingIndex = nobelPrizes.count
        for (index, prize) in newPrizes.enumerated() {
            var mutablePrize = prize
            mutablePrize.assignUniqueID(index: startingIndex + index)
            nobelPrizes.append(mutablePrize)
        }
        offset += newPrizes.count
    }
    
    func filterNobelPrizes(category: String, year: String) async throws {
        currentCategory = category
        currentYear = year
        isFilterEnabled = true
        
        try await applyFilterAndUpdate()
    }
    
    func resetFilter() async throws {
        isFilterEnabled = false
        currentCategory = nil
        currentYear = nil
        
        try await applyFilterAndUpdate()
    }
    
    private func applyFilterAndUpdate() async throws {
        resetData()
        try await updateData()
    }
    
    private func resetData() {
        offset = 0
        nobelPrizes.removeAll()
    }
    
    func getNobelLaureateItemDetails(id: String) async throws -> NobelLaureate? {
        return try await repository.getNobelLaureateDetails(id: id)
    }
    
    private func notifyDataChanged() {
        Task { @MainActor in
            self.dataChangeHandler?()
        }
    }
}
