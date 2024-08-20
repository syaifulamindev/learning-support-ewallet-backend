//
//  File.swift
//  
//
//  Created by Macbook on 20/08/24.
//

import Vapor

struct ContactController : RouteCollection {
  private let serverKey = Constants.serverKey()

  func boot(routes: any Vapor.RoutesBuilder) throws {
    let walletRoute = routes
      .grouped(
        UserToken.authenticator(),
        UserToken.guardMiddleware()
      )
      .grouped("contact")
    walletRoute.get(use: index)
    walletRoute.post("add", use: add)
  }

  @Sendable
  func index(_ req: Request) async throws -> SuccessResponse<[ContactResponse]> {
    let payload = try await req.jwt.verify(as: SessionToken.self)
    let contacts = try await Contact.query(on: req.db)
      .with(\.$user)
      .with(\.$contact)
      .filter(\.$user.$id, .equal, payload.userId)
      .all()

    let contactsResponse = contacts
      .map {
        ContactResponse($0.contact)
      }

    return SuccessResponse(
      success: true,
      message: "User's contacts fetched",
      data: contactsResponse
    )
  }

  @Sendable
  func add(_ req: Request) async throws -> SuccessResponse<NoValue> {
    let payload = try await req.jwt.verify(as: SessionToken.self)
    let addRequest = try req.content.decode(Contact.Add.Request.self)
    guard
      let friendUser = try await User.query(on: req.db)
        .filter(\.$phoneNumber, .equal, addRequest.phoneNumber)
        .first(),
      let user = try await User.query(on: req.db)
        .filter(\.$id, .equal, payload.userId)
        .first() else {
      throw GenericError("Can't get user by phone: \(addRequest.phoneNumber)")
    }

    try await user.$contacts.attach(friendUser, on: req.db)

    return SuccessResponse(
      success: true,
      message: "Success Add Contact",
      data: .none
    )
  }

}
