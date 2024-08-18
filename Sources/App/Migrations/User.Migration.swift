// //	Created for . in 30/07/24

import Fluent
import Vapor

extension User {
  struct Migration: AsyncMigration {
//    var name: String { "CreateUser" }
    
    func prepare(on database: Database) async throws {
      try await database.schema("users")
        .id()
        .field("username", .string, .required)
        .field("email", .string, .required)
        .field("phone_number", .string, .required)
        .field("password_hash", .string, .required)
        .unique(on: "email", name: "unique_email")
        .unique(on: "username", name: "unique_username")
        .unique(on: "phone_number", name: "unique_phone_number")
        .create()
    }
    
    func revert(on database: Database) async throws {
      try await database.schema("users").delete()
    }
  }
}
