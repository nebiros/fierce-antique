//
//  ApiClient.swift
//  FierceAntique
//
//  Created by Juan Felipe Alvarez Saldarriaga on 7/14/16.
//  Copyright © 2016 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

import Foundation
import RequestUtils

protocol ApiClient {
  
  var apiUrl: String { get }
  var URL: NSURL { get }
  
  func request(path: String,
    via: String,
    params: [String: AnyObject]?,
    completion: (req: NSURLRequest?, res: NSURLResponse?, data: NSData?, error: ErrorType?) -> Void)
  
  func requestAndSerializeResult(path: String,
    via: String,
    params: [String: AnyObject]?,
    completion: (succeeded: Bool?, result: AnyObject?, error: ErrorType?) -> Void)
}

class ApiClientImpl: ApiClient {
  
  var apiUrl: String
  var URL: NSURL
  
  required init(apiUrl: String = "http://api.fixer.io") {
    self.apiUrl = apiUrl
    self.URL = NSURL(string: apiUrl)!
  }
  
  func request(path: String,
    via: String,
    params: [String: AnyObject]?,
    completion: (req: NSURLRequest?, res: NSURLResponse?, data: NSData?, error: ErrorType?) -> Void) {
      let finalURL = URL.URLByAppendingPathComponent(path)
      let URLRequest = NSURLRequest.HTTPRequestWithURL(finalURL, method: via, parameters: params)
      let URLSession = NSURLSession.sharedSession()
      let task = URLSession.dataTaskWithRequest(URLRequest) { (data, res, error) in
        return completion(req: URLRequest, res: res, data: data, error: error)
      }
      task.resume()
  }
  
  func requestAndSerializeResult(path: String,
    via: String,
    params: [String: AnyObject]?,
    completion: (succeeded: Bool?, result: AnyObject?, error: ErrorType?) -> Void) {
      request(path, via: via, params: params) { (req, res, data, error) in
        guard let data = data else {
          return completion(succeeded: false, result: nil, error: error)
        }
        
        var json: [String: AnyObject]?
        
        do {
          json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject]
        } catch let error as NSError {
          return completion(succeeded: false, result: nil, error: error)
        }
        
        return completion(succeeded: true, result: json, error: nil)
      }
  }
}
