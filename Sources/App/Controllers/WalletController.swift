//
//  WalletController.swift
//
//
//  Created by Macbook on 15/08/24.
//

import Vapor

struct WalletController : RouteCollection {
  private let serverKey = Constants.serverKey()

  func boot(routes: any Vapor.RoutesBuilder) throws {
    let walletRoute = routes
      .grouped(
        UserToken.authenticator(),
        UserToken.guardMiddleware()
      )
      .grouped("wallet")
    walletRoute.get(use: index)
    walletRoute.post("topup", use: topup)
  }

  @Sendable
  func index(_ req: Request) async throws -> SuccessResponse<WalletResponse> {
    let payload = try await req.jwt.verify(as: SessionToken.self)

    guard let wallet = try await Wallet.query(on: req.db)
      .with(\.$user)
      .filter(\Wallet.$user.$id, .equal, payload.userId)
      .first() else {
      throw GenericError("An error occurred while processing wallet information. Please try again later or contact our support team if the issue persists.")
    }
    let walletResponse = WalletResponse(wallet)
    return SuccessResponse(
      success: true,
      message: "Wallet information",
      data: walletResponse
    )
  }

  @Sendable
  func topup(_ req: Request) async throws -> SuccessResponse<MidtransSnapResponse> {
    //    let user = try req.auth.require(User.self)
    let payload = try await req.jwt.verify(as: SessionToken.self)

    try Wallet.Topup.validate(content: req)
    let topup = try req.content.decode(Wallet.Topup.self)

    let transaction = Transaction(from: payload.userId, amount: topup.amount, status: .failed, type: .income)
    try await transaction.save(on: req.db)
    guard let transactionId = transaction.id else {
      throw TransactionError.other("can't get transaction id")
    }

    let response: ClientResponse = try await req.client.post("https://app.sandbox.midtrans.com/snap/v1/transactions", headers: .init()) { req in
      let newId = UUID().uuidString
      let requestObject = Midtrans.Snap.Request(
        itemDetails: [
          Midtrans.Snap.Request.ItemDetail(
            id: newId, price: topup.amount, quantity: 1, name: "Topup", brand: "My Brand"
          )
        ],
        transactionDetails: Midtrans.Snap.Request.TransactionDetail(orderId: transactionId, grossAmount: topup.amount)
      )

      try req.content.encode(requestObject)

      let auth = BasicAuthorization(username: serverKey, password: "")
      req.headers.basicAuthorization = auth
    }

    let snapResponse = try response.content.decode(MidtransSnapResponse.self)

    transaction.status = .processing
    transaction.url = snapResponse.redirectUrl
    transaction.updatedDate = .now

    try await transaction.update(on: req.db)

    return SuccessResponse(
      success: true,
      message: "Thank you for your top-up request. To complete the process, please proceed with the payment. Once the payment is successful, your wallet balance will be updated shortly. Let me know if you have any other questions!",
      data: snapResponse
    )
  }

}
