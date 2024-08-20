import NIOSSL
import Fluent
import FluentMongoDriver
import Vapor


public func configure(_ app: Application) async throws {

  app.middleware = .init()
  app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  app.middleware.use(RouteLoggingMiddleware(logLevel: .info))
  app.middleware.use(ErrorMiddleware.default(environment: app.environment))
  
  try app.databases.use(DatabaseConfigurationFactory.mongo(
    connectionString: Environment.get("DATABASE_URL") ?? "mongodb://localhost:27017/vapor_database"
  ), as: .mongo)
  
  app.migrations.add(CreateTodo())
  app.migrations.add(User.Migration())
  app.migrations.add(UserToken.Migration())
  app.migrations.add(Transaction.Migration())

  await app.jwt.keys.add(hmac: "secret2", digestAlgorithm: .sha256)
  // Set hostname from environment variable if it exists
   if let hostname = Environment.get("SERVER_HOSTNAME") {
     app.http.server.configuration.hostname = hostname
   }

  // register routes
  try routes(app)
  
}
