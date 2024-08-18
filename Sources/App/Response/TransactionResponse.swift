//
//  TransactionResponse.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Vapor

struct TransactionResponse: Content {
  var id: UUID?
  var from: UUID?
  var to: UUID?
  var amount: Double
  var status: Transaction.Status
  var createdDate: Date
  var updatedDate: Date
  var description: String?
  var url: String?
  var type: Transaction.Kind?

  init(_ transaction: Transaction) {
    id = transaction.id
    from = transaction.from
    to = transaction.to
    amount = transaction.amount
    status = transaction.status
    createdDate = transaction.createdDate
    updatedDate = transaction.updatedDate
    description = transaction.description
    url = transaction.url
    type = transaction.type
  }
}
