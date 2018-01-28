//
//  Extensions.swift
//  CookieCrunch
//
//  Created by Razeware on 13/04/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

extension Dictionary {
  
  // Loads a JSON file from the app bundle into a new dictionary
  static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
    var dataOK: Data
    var dictionaryOK: NSDictionary = NSDictionary()
    if let path = Bundle.main.path(forResource: filename, ofType: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
        dataOK = data!
      }
      catch {
        print("Could not load level file: \(filename), error: \(error)")
        return nil
      }
      do {
        let dictionary = try JSONSerialization.jsonObject(with: dataOK, options: JSONSerialization.ReadingOptions()) as AnyObject!
        dictionaryOK = (dictionary as! NSDictionary as? Dictionary<String, AnyObject>)! as NSDictionary
      }
      catch {
        print("Level file '\(filename)' is not valid JSON: \(error)")
        return nil
      }
    }
    return dictionaryOK as? Dictionary<String, AnyObject>
  }
  
}
