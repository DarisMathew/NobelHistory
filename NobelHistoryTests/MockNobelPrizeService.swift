//
//  MockNobelPrizeService.swift
//  NobelHistoryTests
//
//  Created by Daris Mathew on 06.09.24.
//

@testable import NobelHistory
import Foundation
import XCTest

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class MockNobelPrizeService: NobelPrizeService {
    
    var shouldReturnError = false
    var mockNobelPrizes: [NobelPrize] = []
    var mockNobelLaureate: NobelLaureate?
    
    // Simulate network error condition
    func triggerError() {
        shouldReturnError = true
    }
    
    override func fetchNobelPrizes(offset: Int = 0, limit: Int = 20) async throws -> [NobelPrize] {
        if shouldReturnError {
            throw NetworkError.invalidData
        }
        return mockNobelPrizes
    }
    
    override func fetchLaureateDetails(id: String) async throws -> NobelLaureate? {
        if shouldReturnError {
            throw NetworkError.invalidUrl
        }
        return mockNobelLaureate
    }
    
    override func fetchFilteredNobelPrizes(category: String, year: String) async throws -> NobelPrize {
        if shouldReturnError {
            throw NetworkError.missingData
        }
        guard let firstPrize = mockNobelPrizes.first else {
            throw NetworkError.missingData
        }
        return firstPrize
    }
}


class MockURLSession: URLSessionProtocol {
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = nextError {
            throw error
        }
        let response = nextResponse ?? HTTPURLResponse(url: request.url!,
                                                       statusCode: 200,
                                                       httpVersion: nil,
                                                       headerFields: nil)!
        return (nextData ?? Data(), response)
    }
}

final class NobelPrizeServiceTests: XCTestCase {
    var service: NobelPrizeService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        service = NobelPrizeService() // Inject mock session
    }

    override func tearDown() {
        service = nil
        mockSession = nil
        super.tearDown()
    }

    func testFetchNobelPrizesSuccess() async throws {
        // Arrange
        let jsonData = """
        {
          "nobelPrizes": [{
            "awardYear": "2020",
            "category": { "en": "Peace" },
            "laureates": []
          }]
        }
        """.data(using: .utf8)!
        mockSession.nextData = jsonData

        // Act
        let prizes = try await service.fetchNobelPrizes()

        // Assert
        XCTAssertEqual(prizes.count, 1)
        XCTAssertEqual(prizes.first?.awardYear, "2020")
        XCTAssertEqual(prizes.first?.category.en, "Peace")
    }

    func testFetchNobelPrizesFailure() async {
            // Arrange
            mockSession.nextError = NetworkError.invalidData

            // Act & Assert
            do {
                _ = try await service.fetchNobelPrizes()
                XCTFail("Expected to throw, but it did not throw.")
            } catch {
                // Assert that the correct error was thrown
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidData)
            }
        }
}

