//
//  APIServiceTests.swift
//  TravelStartTests
//
//  Created by HsiaoAi on 2018/5/17.
//  Copyright © 2018 HsiaoAi. All rights reserved.
//

import XCTest

@testable import TravelStart

class APIServiceTests: XCTestCase {
    
    var apiService: APIService!
    
    override func setUp() {
        super.setUp()
        self.apiService = APIService()
    }
    
    override func tearDown() {
        self.apiService = nil
        super.tearDown()
    }
    
    func testAPIServiceIsNotNill() {
        XCTAssertNotNil(self.apiService, "apiService is Nill")
    }
    
    func testmockFetchTouristSitesWithWrongUrl() {
        self.apiService.mockFetchTouristSitesWithWrongUrl(limit: 10, offset: 0) { (success, touristSties, error, totalPages) in
            XCTAssertEqual(success, false)
            XCTAssertTrue(error != nil)
            XCTAssertTrue(touristSties == nil)
            XCTAssertTrue(totalPages == nil)
        }
    }
    
    func testMockFetchTouristSitesWithOffsetMoreThanTotalPage() {
        let offset = 400
        self.apiService.fetchTouristSites(limit: 0 , offset: offset){ (success, touristSties, error, totalPages) in
            XCTAssertEqual(success, false)
            XCTAssertTrue(error != nil)
            XCTAssertTrue(touristSties == nil)
            XCTAssertTrue(totalPages == nil)
        }
    }
    
    func testMockFetchTouristSitesWithoutError() {
        self.apiService.fetchTouristSites(limit: 10 , offset: 0){ (success, touristSties, error, totalPages) in
            XCTAssertEqual(success, true)
            XCTAssertTrue(error == nil)
            XCTAssertTrue(touristSties != nil)
            XCTAssertTrue(totalPages != nil)
        }
    }
    
    
}
