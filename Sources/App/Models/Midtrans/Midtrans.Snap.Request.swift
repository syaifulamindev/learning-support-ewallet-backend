//
//  Midtrans.Snap.Request.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Vapor

extension Midtrans.Snap {
  struct Request: Content {
    let itemDetails: [ItemDetail]
    let transactionDetails: TransactionDetail
    let creditCard: CreditCard = .init(secure: true)

    enum CodingKeys: String, CodingKey {
      case itemDetails = "item_details"
      case transactionDetails = "transaction_details"
      case creditCard = "credit_card"
    }
  }
}

extension Midtrans.Snap.Request {

  struct TransactionDetail: Content {
    let orderId: UUID
    let grossAmount: Double

    enum CodingKeys: String, CodingKey {
      case orderId = "order_id"
      case grossAmount = "gross_amount"
    }
  }

  struct ItemDetail: Content {
    let id: String
    let price: Double?
    let quantity: Int?
    var name: String? = nil
    var brand: String? = nil
    var category: String? = nil
    var merchantName: String? = nil
    var url: String? = nil

    enum CodingKeys: String, CodingKey {
      case id
      case price
      case quantity
      case name
      case brand
      case category
      case merchantName = "merchant_name"
      case url
    }
  }

  struct CreditCard: Content {
    var secure: Bool = true
  }
}
