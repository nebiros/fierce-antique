//
//  LatestCurrencyManagerImplTests.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/18/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import XCTest
@testable import FierceAntique

class LatestCurrencyManagerImplTests: XCTestCase {
  
  var client: ApiClient!
  var manager: LatestCurrencyManager!
  
  override func setUp() {
    super.setUp()
    
    client = ApiClientImpl(apiUrl: "http://www.mocky.io")
    manager = LatestCurrencyManagerImpl(apiClient: client)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testFetchData() {
    let expectation = expectationWithDescription("fetchData expectation")
    
    manager.fetchData("/v2/578ce6d10f00009f00aebaa9") { (model, error) in
      XCTAssertNil(error, "error should be nil")
      XCTAssertNotNil(model, "model should not be nil")
      
      if let model = model {
        XCTAssertEqual(model.base, "USD", "base should be USD")
        XCTAssertEqual(model.date, "2016-07-18", "date should be 2016-07-18")
        XCTAssertEqual(model.rates?.count, 4, "rates count should be equal to 4")
        XCTAssertEqual(model.rates?["BRL"], 3.2537, "BRL rate should be equal to 3.2537")
        XCTAssertEqual(model.rates?["GBP"], 0.75429, "GBP rate should be equal to 0.75429")
        XCTAssertEqual(model.rates?["JPY"], 105.69, "JPY rate should be equal to 105.69")
        XCTAssertEqual(model.rates?["EUR"], 0.90473, "EUR rate count should be equal to 0.90473")
      }
      
      expectation.fulfill()
    }
    
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func testCalculateRates() {
    let amount = 100
    let rates = ["BRL": 3.2537,
      "GBP": 0.75429,
      "JPY": 105.69,
      "EUR": 0.90473]
    
    let calculatedRates = manager.calculateRates(amount, rates: rates)
    
    XCTAssertNotNil(calculatedRates, "calculatedRates should not be nil")
    XCTAssertEqual(calculatedRates["BRL"], 325)
    XCTAssertEqual(calculatedRates["GBP"], 75)
    XCTAssertEqual(calculatedRates["JPY"], 10569)
    XCTAssertEqual(calculatedRates["EUR"], 90)
  }
  
  func testPrepareDataForChart() {
    let rates = ["BRL": 325,
      "GBP": 75,
      "JPY": 10569,
      "EUR": 90]
    
    let data = manager.prepareDataForChart(rates)
    
    XCTAssertNotNil(data, "data should not be nil")
  }
}
