//
//  NobelPrizeDataRepositoryTests.swift
//  NobelHistoryTests
//
//  Created by Daris Mathew on 08.09.24.
//

import XCTest
@testable import NobelHistory

class MockNobelPrizeDataRepository: NobelPrizeDataRepository {
    var mockNobelPrizes: [NobelPrize] = []
    var mockLaureate: NobelLaureate?
    var shouldReturnError = false

    // Override the method to return mock data or an error
    override func getNobelPrizes(offset: Int, limit: Int) async throws -> [NobelPrize] {
        if shouldReturnError {
            throw NetworkError.invalidData
        }
        return mockNobelPrizes
    }

    // Override the method to return mock laureate data or an error
    override func getNobelLaureateDetails(id: String) async throws -> NobelLaureate? {
        if shouldReturnError {
            throw NetworkError.invalidData
        }
        return mockLaureate
    }

    // Override the method to return mock filtered Nobel prizes
    override func getFilteredNobelPrizes(category: String, year: String) async throws -> NobelPrize {
        if shouldReturnError {
            throw NetworkError.invalidData
        }
        return mockNobelPrizes.first ?? NobelPrize(awardYear: "", category: .init(en: ""), laureates: [])
    }
}

final class NobelPrizeDataRepositoryTests: XCTestCase {
    var repository: NobelPrizeDataRepository!
    var mockService: MockNobelPrizeService!

    override func setUp() {
        super.setUp()
        mockService = MockNobelPrizeService()
        repository = NobelPrizeDataRepository(service: mockService)
    }

    override func tearDown() {
        repository = nil
        mockService = nil
        super.tearDown()
    }

    func testGetNobelPrizesSuccess() async throws {
        // Arrange
        let mockPrizes = [NobelPrize(awardYear: "2020", category: .init(en: "Peace"), laureates: nil)]
        mockService.mockNobelPrizes = mockPrizes

        // Act
        let prizes = try await repository.getNobelPrizes()

        // Assert
        XCTAssertEqual(prizes.count, 1)
        XCTAssertEqual(prizes.first?.awardYear, "2020")
    }

    func testGetNobelPrizesFailure() async throws {
        // Arrange
        mockService.shouldReturnError = true

        // Act & Assert
        do {
            _ = try await repository.getNobelPrizes()
            XCTFail("Expected to throw, but it did not throw.")

        } catch {
            // Assert that the correct error was thrown
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidData)
        }
    }
}
