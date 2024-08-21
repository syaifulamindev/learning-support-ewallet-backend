//
//  CreateTransactionRequestResponse.swift
//
//
//  Created by Macbook on 19/08/24.
//

import Vapor

struct CreateTransactionRequestResponse: Content {
  var url: String?
  let amount: Double
  let description: String?
  let to: String
  let transactionId: String

  enum CodingKeys: String, CodingKey {
    case url
    case amount
    case description
    case to
    case transactionId = "transaction_id"
  }
}



