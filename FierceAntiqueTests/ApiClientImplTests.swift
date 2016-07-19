//
//  ApiClientImplTests.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/15/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import XCTest
@testable import FierceAntique

class ApiClientImplTests: XCTestCase {
  
  var client: ApiClient!
  
  override func setUp() {
    super.setUp()
    
    client = ApiClientImpl(apiUrl: "http://www.mocky.io")
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testRequestLatest() {
    let expectation = expectationWithDescription("/latest request expectation")
    
    client.request("/v2/57894f85280000990924578d", via: "GET", params: nil) { (req, res, data, error) in
      XCTAssertNil(error, "error should be nil")
      XCTAssertNotNil(data, "data should not be nil")
      
      expectation.fulfill()
    }
    
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
  
  func testRequestLatestBaseUsdSymbolsGbpEurJpyBrl() {
    let expectation = expectationWithDescription("/latest?base=USD&symbols=GBP,EUR,JPY,BRL request expectation")
    
    client.request("/v2/578ce6d10f00009f00aebaa9", via: "GET", params: nil) { (req, res, data, error) in
      XCTAssertNil(error, "error should be nil")
      XCTAssertNotNil(data, "data should not be nil")
      
      expectation.fulfill()
    }
    
    waitForExpectationsWithTimeout(5.0, handler: nil)
  }
}
