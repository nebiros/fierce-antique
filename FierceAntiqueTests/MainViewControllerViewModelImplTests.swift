//
//  MainViewControllerViewModelImplTests.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/17/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import XCTest
@testable import FierceAntique

class MainViewControllerViewModelImplTests: XCTestCase {
  
  var client: ApiClient!
  var manager: LatestCurrencyManager!
  var viewModel: MainViewControllerViewModel!
  
  override func setUp() {
    super.setUp()
    
    client = ApiClientImpl(apiUrl: "http://www.mocky.io")
    manager = MockLatestCurrencyManagerImpl(apiClient: client)
    viewModel = MainViewControllerViewModelImpl(manager: manager)
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testFetchLatestCurrencyData() {
    let expectation = expectationWithDescription("fetchLatestCurrencyData expectation")
    
    viewModel.fetchLatestCurrencyData { (model, error) in
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
}
