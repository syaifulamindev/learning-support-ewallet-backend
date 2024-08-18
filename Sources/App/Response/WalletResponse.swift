//
//  WalletResponse.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Vapor

struct WalletResponse: Content {
  let id: UUID?
  let amount: Double
  let currency: String
  let userId: UUID?

  init(_ wallet: Wallet) {
    self.id = wallet.id
    self.amount = wallet.amount
    self.currency = wallet.currency
    self.userId = wallet.user.id
  }
}
