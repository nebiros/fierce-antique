//
//  MainViewController.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/14/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import UIKit
import Charts

class MainViewController: UIViewController {
  
  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var convertButton: UIButton!
  @IBOutlet private weak var barChartView: BarChartView!
  
  var viewModel: MainViewControllerViewModel? {
    didSet {
      viewModel?.delegate = self
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    barChartView.delegate? = self
    barChartView.infoTextColor = viewModel?.chartInfoTextColor
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func convertButtonTapped(sender: UIButton) {
    viewModel?.convertButtonTapped(textField.text)
  }
}

extension MainViewController: MainViewControllerViewModelDelegate {
  
  func showError(error: ErrorType?) {
    guard error == nil else { return }
    
    print("ERROR: \(error)")
  }
  
  func reloadChart(data: BarChartData?) {
    guard let data = data else { return }
    
    barChartView.data = data
    barChartView.data?.notifyDataChanged()
    barChartView.notifyDataSetChanged()
    
    dispatch_async(dispatch_get_main_queue()) {
      self.textField.endEditing(true)
    }
  }
}

extension MainViewController: ChartViewDelegate {
}
