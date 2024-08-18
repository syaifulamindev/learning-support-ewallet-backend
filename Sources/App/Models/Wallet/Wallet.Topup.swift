//
//  Wallet.Topup.swift
//
//
//  Created by Macbook on 17/08/24.
//

import Vapor

extension Wallet {
  struct Topup: Content {
    var amount: Double
  }
}

extension Wallet.Topup: Validatable {
  static func validations(_ validations: inout Vapor.Validations) {
    validations.add("amount", as: Double.self, is: .valid)
  }
}

