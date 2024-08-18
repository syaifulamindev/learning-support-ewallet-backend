//
//  Data + Extension.swift
//  
//
//  Created by Macbook on 16/08/24.
//

import Foundation
import CryptoKit

extension Data {
  var jsonObject: Any? {
    try? JSONSerialization.jsonObject(with: self, options: [])
  }

  var prettyPrintedJSONString: String? {
    guard let jsonObject,
          let data = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: [.prettyPrinted]),
          let prettyJSON = String(data: data, encoding: .utf8) else {
      return nil
    }

    return prettyJSON
  }
}

extension Data {
  func hash(using
            hashFunction: any HashFunction.Type) -> String {
      let digest = hashFunction.hash(data: self)
      let hashString = digest
          .compactMap { String(format: "%02x", $0) }
          .joined()
      return hashString
  }
}
