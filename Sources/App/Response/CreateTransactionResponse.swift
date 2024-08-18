//
//  CreateTransactionResponse.swift
//
//
//  Created by Macbook on 19/08/24.
//

import Vapor

struct CreateTransactionResponse: Content {
  var url: String?
  var payload: Payload
}

extension CreateTransactionResponse {
  struct Payload: Content {
    let id: UUID
    let amount: Double
    let description: String?
  }
}


