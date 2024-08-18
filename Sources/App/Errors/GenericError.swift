//
//  File.swift
//  
//
//  Created by Macbook on 18/08/24.
//

import Foundation

struct GenericError: Error, CustomStringConvertible {
  let message: String
  init(_ message: String) {
    self.message = message
  }

  var description: String {
    message
  }
}
