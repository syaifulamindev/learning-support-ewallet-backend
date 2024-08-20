import Fluent
import Vapor
import JWT

func routes(_ app: Application) throws {
  app.get { req async throws in
    "It works!"
    
  }

  try app.register(collection: AuthenticationController())
  try app.register(collection: WalletController())
  try app.register(collection: MidtransWebhookController())
  try app.register(collection: TransactionController())
  try app.register(collection: ContactController())

  let tokenProtected = app.grouped(
    UserToken.authenticator(),
    UserToken.guardMiddleware()
  )

  tokenProtected.get("me") { req async throws -> SessionToken in
    let payload = try await req.jwt.verify(as: SessionToken.self)
    return payload
  }

}
