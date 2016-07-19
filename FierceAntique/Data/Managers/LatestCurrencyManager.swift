//
//  LatestCurrency.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/17/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import Foundation
import Charts

enum LatestCurrencyManagerError: ErrorType {
  case InavlidJson
  case Unknown
}

protocol LatestCurrencyManager {
  
  init(apiClient: ApiClient)
  
  func fetchData(path: String?, completion: (model: LatestCurrency?, error: ErrorType?) -> Void)
  func calculateRates(amount: Int, rates: [String: Double]) -> [String: Int]
  func prepareDataForChart(calculatedRates: [String: Int]) -> BarChartData
}

class LatestCurrencyManagerImpl: LatestCurrencyManager {
  
  let apiClient: ApiClient
  
  required init(apiClient: ApiClient) {
    self.apiClient = apiClient
  }
  
  func fetchData(path: String?, completion: (model: LatestCurrency?, error: ErrorType?) -> Void) {
    let path = path ?? "/latest"
    
    apiClient.requestAndSerializeResult(path,
      via: "GET",
      params: ["base": "USD", "symbols": "GBP,EUR,JPY,BRL"]) { (succeeded, result, error) in
        guard error == nil else {
          return completion(model: nil, error: error)
        }
        
        guard let result = result else {
          return completion(model: nil, error: LatestCurrencyManagerError.Unknown)
        }
        
        do {
          let model = try self.configureModel(result as! [String: AnyObject])
          return completion(model: model, error: nil)
        } catch LatestCurrencyManagerError.InavlidJson {
          return completion(model: nil, error: LatestCurrencyManagerError.InavlidJson)
        } catch {
          return completion(model: nil, error: LatestCurrencyManagerError.Unknown)
        }
    }
  }
  
  private func configureModel(result: [String: AnyObject?]) throws -> LatestCurrency {
    guard let base = result["base"] as? String,
      let date = result["date"] as? String,
      let rates = result["rates"] as? [String: Double]
    else {
      throw LatestCurrencyManagerError.InavlidJson
    }
    
    return LatestCurrency(base: base, date: date, rates: rates)
  }
  
  func calculateRates(amount: Int, rates: [String: Double]) -> [String: Int] {
    var calculated = [String: Int]()
    
    for (key, val) in rates {
      let rate = Double(amount) * val
      calculated[key] = Int(fabs(rate))
    }
    
    return calculated
  }
  
  func prepareDataForChart(calculatedRates: [String: Int]) -> BarChartData {
    var xVals = [String]()
    
    for key in calculatedRates.keys {
      xVals += [key]
    }
    
    var yVals = [BarChartDataEntry]()
    
    for (index, element) in calculatedRates.values.enumerate() {
      let entry = BarChartDataEntry(value: Double(element), xIndex: index)
      yVals += [entry]
    }
    
    let dataSet = BarChartDataSet(yVals: yVals, label: nil)
    dataSet.barSpace = 0.35
    dataSet.colors = ChartColorTemplates.joyful()
    
    let dataSets = [dataSet]
    
    return BarChartData(xVals: xVals, dataSets: dataSets)
  }
}
