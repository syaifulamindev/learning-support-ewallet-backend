//
//  TransactionError.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Foundation

enum TransactionError: Error, CustomStringConvertible {
  case statusCode(String)
  case fraudStatus(String)
  case transactionStatus(String)
  case signature
  case transactionNotProcessing
  case other(String)

  var description: String {
    switch self {
    case .fraudStatus(let value):
      return "Your fraud status is \(value). The transaction has not been accepted. Please review your account activity and contact support for assistance."
    case .transactionStatus(let value):
      return "Your transaction status is \(value). The transaction has not been completed. Please check your account for updates or contact support if you need further assistance."
    case .statusCode(let value):
      return "The request has resulted in a \(value) error. Please check your request and try again, or contact support if the issue persists."
    case .signature:
      return "We encountered an issue while processing your request. Please try again. If you continue to experience problems, contact support for assistance."
    case .other:
      return "An error occurred while processing your transaction. Please try again later or contact our support team if the issue persists."
    case .transactionNotProcessing:
      return "An error occurred while processing your transaction. Please try again later."
    }
  }

}
