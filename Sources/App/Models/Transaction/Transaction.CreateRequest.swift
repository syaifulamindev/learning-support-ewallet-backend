//
//  File.swift
//  
//
//  Created by Macbook on 19/08/24.
//

import Vapor

extension Transaction {
  struct CreateRequest: Content {
    var amount: Double
    var description: String?
    var generateQR: Bool = false

    enum CodingKeys: String, CodingKey {
      case amount
      case description
      case generateQR = "generate_qr"
    }
  }
}

extension Transaction.CreateRequest: Validatable {
  static func validations(_ validations: inout Vapor.Validations) {
    let minimumAmount: Double = 100
    validations.add("amount", as: Double.self, is: .range(minimumAmount...))
    validations.add("generate_qr", as: Bool.self, is: .valid)
  }
}
