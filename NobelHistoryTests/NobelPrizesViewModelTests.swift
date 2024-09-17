//
//  NobelPrizesViewModelTests.swift
//  NobelHistoryTests
//
//  Created by Daris Mathew on 08.09.24.
//

import XCTest
@testable import NobelHistory

class NobelPrizesViewModelTests: XCTestCase {
    var viewModel: NobelPrizesViewModel!
    var mockRepository: MockNobelPrizeDataRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockNobelPrizeDataRepository(service: NobelPrizeService()) // Inject a service if needed
        viewModel = NobelPrizesViewModel(repository: mockRepository)
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        super.tearDown()
    }

    func testUpdateDataSuccess() async throws {
        // Arrange
        let mockPrizes = [NobelPrize(awardYear: "2020", category: .init(en: "Peace"), laureates: nil)]
        mockRepository.mockNobelPrizes = mockPrizes

        // Act
        try await viewModel.updateData()

        // Assert
        XCTAssertEqual(viewModel.nobelPrizes.count, 1)
        XCTAssertEqual(viewModel.nobelPrizes.first?.awardYear, "2020")
    }

    func testUpdateDataFailure() async throws {
        // Arrange
        mockRepository.shouldReturnError = true

        // Act & Assert
        await XCTAssertThrowsError(try await viewModel.updateData())
    }

    func testFilterNobelPrizesSuccess() async throws {
        // Arrange
        let mockPrizes = [NobelPrize(awardYear: "2020", category: .init(en: "Peace"), laureates: nil)]
        mockRepository.mockNobelPrizes = mockPrizes

        // Act
        try await viewModel.filterNobelPrizes(category: "Peace", year: "2020")

        // Assert
        XCTAssertEqual(viewModel.nobelPrizes.count, 1)
        XCTAssertEqual(viewModel.nobelPrizes.first?.awardYear, "2020")
    }

    func testFilterNobelPrizesFailure() async throws {
        // Arrange
        mockRepository.shouldReturnError = true

        // Act & Assert
        await XCTAssertThrowsError(try await viewModel.filterNobelPrizes(category: "Peace", year: "2020"))
    }
}

