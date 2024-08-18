//
//  Wallet.swift
//
//
//  Created by Macbook on 17/08/24.
//

import Vapor
import Fluent

final class Wallet: Model, Content, @unchecked Sendable {
  
  static let schema: String = "wallets"
  @ID(key: .id)
  var id: UUID?

  @Field(key: "amount")
  var amount: Double

  @Field(key: "currency")
  var currency: String

  @Parent(key: "user_id")
  var user: User

  init() {}

  init(id: UUID? = nil, amount: Double, userId: User.IDValue) {
    self.id = id
    self.amount = amount
    self.$user.id = userId
    self.currency = "IDR"
  }

}
