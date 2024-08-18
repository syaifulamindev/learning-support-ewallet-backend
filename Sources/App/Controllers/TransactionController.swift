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
    todos.post("pay",use: self.createRequest)
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
  func createRequest(req: Request) async throws -> SuccessResponse<CreateTransactionResponse> {
    let payload = try await req.jwt.verify(as: SessionToken.self)

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

    var createTransactionResponse = CreateTransactionResponse(
      payload: CreateTransactionResponse.Payload(
        id: transactionId,
        amount: createRequest.amount,
        description: createRequest.description
        )
    )


    if createRequest.generateQR {
      let url = try await qr(createTransactionResponse, path: "temp/transaction", filename: transactionId.uuidString, req: req)
      createTransactionResponse.url = url
    }

    transaction.status = .processing
    try await transaction.save(on: req.db)

    return SuccessResponse(
      success: true,
      message: "Create Transaction",
      data: createTransactionResponse)
  }

}

