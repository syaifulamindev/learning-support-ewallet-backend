//
//  Transaction.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Vapor
import Fluent

final class Transaction: Model, Content, @unchecked Sendable {

  static let schema: String = "transactions"
  @ID(key: .id)
  var id: UUID?

  @Field(key: "from")
  var from: UUID?

  @Field(key: "to")
  var to: UUID?

  @Field(key: "amount")
  var amount: Double

  @Field(key: "status")
  var status: Status

  @Field(key: "created_date")
  var createdDate: Date

  @Field(key: "updated_date")
  var updatedDate: Date

  @Field(key: "description")
  var description: String?

  @Field(key: "url")
  var url: String?

  @Field(key: "type")
  var type: Kind?

  init() {}
  
  init(from: UUID? = nil, to: UUID? = nil, amount: Double, status: Status, description: String? = nil, url: String? = nil, type: Kind) {
    self.from = from
    self.to = to
    self.amount = amount
    self.status = status
    self.createdDate = .now
    self.updatedDate = self.createdDate
    self.description = description
    self.url = url
    self.type = type
  }

}

extension Transaction {
  enum Status: String, Codable {
    case processing, completed, failed, cancelled
  }

  enum Kind: String, Codable {
    case income, expense
  }
}
