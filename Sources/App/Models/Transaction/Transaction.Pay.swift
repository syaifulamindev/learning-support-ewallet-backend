//
//  Transaction.Pay.swift
//
//
//  Created by Macbook on 22/08/24.
//

import Vapor

extension Transaction {
  struct Pay { }
}

extension Transaction.Pay {
  struct Request: Content {
    var transactionId: UUID

    enum CodingKeys: String, CodingKey {
      case transactionId = "transaction_id"
    }

  }
}
