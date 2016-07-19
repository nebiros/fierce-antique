//
//  MainViewControllerViewModel.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/15/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import Foundation
import Charts

protocol MainViewControllerViewModelDelegate: class {
  
  func showError(error: ErrorType?)
  func reloadChart(data: BarChartData?)
}

protocol MainViewControllerViewModel {
  
  weak var delegate: MainViewControllerViewModelDelegate? { get set }
  var chartInfoTextColor: UIColor? { get }
  var model: LatestCurrency? { get }
  var calculatedRates: [String: Int]? { get }
  var chartData: BarChartData? { get }
  
  func convertButtonTapped(amount: String?)
  func fetchLatestCurrencyData(completion: (model: LatestCurrency?, error: ErrorType?) -> Void)
}

class MainViewControllerViewModelImpl: MainViewControllerViewModel {
  
  let manager: LatestCurrencyManager?
  
  weak var delegate: MainViewControllerViewModelDelegate?
  var chartInfoTextColor: UIColor? {
    return UIColor.magentaColor()
  }
  var model: LatestCurrency?
  var calculatedRates: [String: Int]?
  var chartData: BarChartData?
  
  init(manager: LatestCurrencyManager) {
    self.manager = manager
  }
  
  func convertButtonTapped(amount: String?) {
    guard let amount = amount where amount.characters.count > 0 else { return }
    
    fetchLatestCurrencyData { (model, error) in
      guard error == nil else {
        self.delegate?.showError(error); return
      }
      
      self.model = model
      
      if let amount = Int(amount), let rates = self.model?.rates {
        self.calculatedRates = self.manager?.calculateRates(amount, rates: rates)
        
        if let calculatedRates = self.calculatedRates {
          self.chartData = self.manager?.prepareDataForChart(calculatedRates)
          
          if let chartData = self.chartData {
            self.delegate?.reloadChart(chartData)
          }
        }
      }
    }
  }
  
  func fetchLatestCurrencyData(completion: (model: LatestCurrency?, error: ErrorType?) -> Void) {
    manager?.fetchData(nil, completion: completion)
  }
}
