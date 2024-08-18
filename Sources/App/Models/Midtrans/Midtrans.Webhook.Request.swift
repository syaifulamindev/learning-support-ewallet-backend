//
//  Midtrans.Webhook.Request.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Vapor

extension Midtrans.Webhook {
  struct Request: Content, Validatable {

    let orderId: UUID
    let statusCode: String
    let fraudStatus: String
    let grossAmount: String
    let signatureKey: String
    let transactionStatus: String

    enum CodingKeys: String, CodingKey {
      case orderId = "order_id"
      case statusCode = "status_code"
      case fraudStatus = "fraud_status"
      case grossAmount = "gross_amount"
      case signatureKey = "signature_key"
      case transactionStatus = "transaction_status"
    }

    static func validations(_ validations: inout Vapor.Validations) {
      validations.add("order_id", as: UUID.self, is: .valid)
      validations.add("status_code", as: String.self, is: !.empty)
      validations.add("fraud_status", as: String.self, is: !.empty)
      validations.add("gross_amount", as: String.self, is: !.empty)
      validations.add("signature_key", as: String.self, is: !.empty)
      validations.add("transaction_status", as: String.self, is: !.empty)
    }

  }
}
