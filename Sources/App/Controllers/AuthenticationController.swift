// //	Created for . in 29/07/24

import Vapor

struct AuthenticationController: RouteCollection {
  func boot(routes: RoutesBuilder) throws {
    let authRoute = routes
      .grouped("auth")

    let signInRoute = authRoute.grouped(
      User.authenticator()
    )

    signInRoute.post("signin", use: signIn)
    authRoute.post("signup", use: signUp)

  }

  @Sendable
  func signIn(_ req: Request) async throws -> SuccessResponse<ClientTokenResponse> {


    let user = try req.auth.require(User.self)
    guard let userId = user.id else {
      return SuccessResponse(success: false, message: "Can't get user ID, please contact the administrator!", data: nil)
    }

    let oneDayInterval: Double = 60 * 60 * 24
    let oneMonthInterval = oneDayInterval * 30
    let payload = SessionToken(
      subject: .init(value: user.username),
      expiration: .init(
        value: .now.addingTimeInterval(oneMonthInterval)
      ),
      userId: userId
    )

    let tokenValue = try await req.jwt.sign(payload)
    let token = UserToken(value: tokenValue, userID: try user.requireID())

    try await token.save(on: req.db)
    let data = ClientTokenResponse(token: token.value, user: UserResponse(user))
    return SuccessResponse(success: true, message: "Welcome back, \(user.username)! You have successfully signed in to your account.", data: data)
  }

  @Sendable
  func signUp(_ req: Request) async throws -> SuccessResponse<UserResponse> {
    try User.Create.validate(content: req)
    let create = try req.content.decode(User.Create.self)
    guard create.password == create.confirmPassword else {
      throw Abort(.badRequest, reason: "Passwords did not match")
    }

    let user = try User(
      username: create.username,
      email: create.email,
      phoneNumber: create.phoneNumber,
      passwordHash: Bcrypt.hash(create.password)
    )

    try await user.save(on: req.db)

    guard let userId = user.id else {
      throw TransactionError.other("can't create user id when signup")
    }
    
    let wallet = Wallet(amount: 0, userId: userId)
    try await wallet.save(on: req.db)

    let userResponse = UserResponse(user)

    return SuccessResponse(
      success: true,
      message: "Congratulations, \(user.username)! Your account has been successfully created. We're excited to have you on board.",
      data: userResponse
    )
  }

}

