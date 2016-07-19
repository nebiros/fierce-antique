//
//  MockLatestCurrencyManager.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/18/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import Foundation
@testable import FierceAntique

class MockLatestCurrencyManagerImpl: LatestCurrencyManagerImpl {
  
  override func fetchData(path: String?, completion: (model: LatestCurrency?, error: ErrorType?) -> Void) {
    super.fetchData("/v2/578ce6d10f00009f00aebaa9", completion: completion)
  }
}
