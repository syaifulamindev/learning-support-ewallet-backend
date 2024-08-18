//
//  File.swift
//  
//
//  Created by Macbook on 16/08/24.
//

import Vapor

struct MidtransWebhookController: RouteCollection {

  private let serverKey = Constants.serverKey()

  func boot(routes: any Vapor.RoutesBuilder) throws {
    routes
      .grouped("midtrans")
      .post("notifications", use: notifications)
  }

  @Sendable
  func notifications(_ req: Request) async throws -> String {
    
    try Midtrans.Webhook.Request.validate(content: req)
    let webhookRequest = try req.content.decode(Midtrans.Webhook.Request.self)

    try validateTransaction(webhookRequest)

    guard 
      let transaction = try await Transaction.query(on: req.db)
        .filter(\.$from, .equal, webhookRequest.orderId)
        .first(),
      let from = transaction.from,
      let wallet = try await Wallet.query(on: req.db)
        .with(\.$user)
        .filter(\Wallet.$user.$id, .equal, from)
        .first() else {
      throw TransactionError.other("can't get transaction")
    }

    guard transaction.status == .processing else {
      throw TransactionError.transactionNotProcessing
    }

    wallet.amount = wallet.amount + transaction.amount
    try await wallet.save(on: req.db)

    transaction.status = .completed
    try await transaction.save(on: req.db)

    return ""
  }

  func validateTransaction(_ req: Midtrans.Webhook.Request) throws {
    if req.fraudStatus.lowercased() != "accept" {
      throw TransactionError.fraudStatus(req.fraudStatus)
    }

    let transactionStatus = req.transactionStatus.lowercased()
    if  transactionStatus != "settlement" && transactionStatus != "capture" {
      throw TransactionError.transactionStatus(req.transactionStatus)
    }

    if req.statusCode != "200" {
      throw TransactionError.statusCode(req.statusCode)
    }
    
    let combinedHashedData = "\(req.orderId)\(req.statusCode)\(req.grossAmount)\(serverKey)".data(using: .utf8)
    let combinedHashed = combinedHashedData?.hash(using: SHA512.self)
    let isVerified = req.signatureKey == combinedHashed

    if !isVerified {
      throw TransactionError.signature
    }
  }

}
