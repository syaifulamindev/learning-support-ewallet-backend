//
//  Constants.swift
//
//
//  Created by Macbook on 16/08/24.
//

import Vapor

class Constants {
  static func serverKey() -> String  {
    Environment.process.SERVER_KEY ?? ""
  }
}
