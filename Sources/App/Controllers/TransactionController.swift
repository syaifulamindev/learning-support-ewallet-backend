//
//  TransactionController.swift
//
//
//  Created by Macbook on 18/08/24.
//
import Fluent
import Vapor

struct TransactionController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let todos = routes.grouped("transaction")

    todos.get(use: self.index)
    todos.post("request",use: self.createRequest)
    todos.post("pay",use: self.pay)

  }

  @Sendable
  func index(req: Request) async throws -> SuccessResponse<[TransactionResponse]> {
    let payload = try await req.jwt.verify(as: SessionToken.self)

    let transactions = try await Transaction.query(on: req.db)
      .filter(\.$from, .equal, payload.userId)
      .all()
      .map { TransactionResponse($0) }

    return SuccessResponse(
      success: true,
      message: "Transaction histories",
      data: transactions)
  }

  @Sendable
  func createRequest(req: Request) async throws -> SuccessResponse<CreateTransactionRequestResponse> {
    let payload = try await req.jwt.verify(as: SessionToken.self)
    guard let user = try await User.query(on: req.db)
      .filter(\.$id, .equal, payload.userId)
      .first() else {
      throw GenericError("Can't get user")
    }
    try Transaction.CreateRequest.validate(content: req)
    let createRequest = try req.content.decode(Transaction.CreateRequest.self)

    let transaction = Transaction(
      from: nil,
      to: payload.userId,
      amount: createRequest.amount,
      status: .failed,
      description: createRequest.description,
      url: nil,
      type: .income
    )


    try await transaction.save(on: req.db)
    guard let transactionId = transaction.id else {
      throw GenericError("Can't create request right now, please try again later.")
    }

    var createTransactionResponse = CreateTransactionRequestResponse(
      amount: createRequest.amount,
      description: createRequest.description,
      to: user.username,
      transactionId: transactionId.uuidString
    )

    if createRequest.generateQR {
      let url = try await qr(createTransactionResponse.transactionId, path: "temp/transaction", filename: transactionId.uuidString, req: req)
      createTransactionResponse.url = url
    }

    transaction.status = .processing
    try await transaction.save(on: req.db)

    return SuccessResponse(
      success: true,
      message: "Create Transaction",
      data: createTransactionResponse)
  }

  @Sendable
  func pay(req: Request) async throws -> SuccessResponse<NoValue> {
    let payload = try await req.jwt.verify(as: SessionToken.self)
    let payRequest = try req.content.decode(Transaction.Pay.Request.self)
    guard
      let transaction = try await Transaction.query(on: req.db)
        .filter(\.$id, .equal, payRequest.transactionId)
        .first(),
      let receiver = transaction.to else {
      throw GenericError("Transaction Not Found")
    }

    guard transaction.status == .processing else {
      throw GenericError("Transaction status is \(transaction.status), can't continue the process.")
    }

    guard
      let senderWallet = try await Wallet.query(on: req.db)
      .with(\.$user)
      .filter(\.$user.$id, .equal, payload.userId)
      .first(),
      let receiverWallet = try await Wallet.query(on: req.db)
      .with(\.$user)
      .filter(\.$user.$id, .equal, receiver)
      .first() else {
      throw GenericError("Sender or Receiver not found")
    }

    guard let receiverUser = try await User.query(on: req.db)
      .filter(\.$id, .equal, receiver)
      .first() else {
      throw GenericError("Can't get receiver user")
    }



    if payload.userId == receiverUser.id {
      throw GenericError("Can't pay to your self")
    }

    if (senderWallet.amount - transaction.amount) < 0 {
      throw GenericError("Your balance is insufficient")
    }

    let transactionAmomunt = transaction.amount

    transaction.from = payload.userId
    transaction.status = .completed
    senderWallet.amount -= transactionAmomunt
    receiverWallet.amount += transactionAmomunt

    try await req.db.withConnection { db in
      try await transaction.save(on: db)
      try await senderWallet.save(on: db)
      try await receiverWallet.save(on: db)
    }

    /*

     //should use this, but somehow got error:
     //Given transaction number 2 does not match any in-progress transactions. The active transaction number is -1
     try await req.db.transaction { database in
       try await transaction.save(on: database)
       try await senderWallet.save(on: database)
       try await receiverWallet.save(on: database)
     }
     */

    return SuccessResponse(
      success: true,
      message: "Your payment to \(receiverUser.username) for \(Formatter.toIDR(transactionAmomunt)) is Succeeded",
      data: nil)
  }

}

