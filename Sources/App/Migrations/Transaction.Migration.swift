//
//  Transaction.Migration.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Vapor
import Fluent

extension Transaction {
  struct Migration: AsyncMigration {
//    var name: String { "CreateTransaction" }

    func prepare(on database: Database) async throws {
      try await database.schema("transactions")
        .id()
        .field("user_id", .uuid, .required, .references("users", "id"))
        .field("amount", .double, .required)
        .field("status", .string, .required)
        .field("created_date", .date, .required)
        .field("updated_date", .date, .required)
        .field("description", .string, .required)
        .field("url", .string, .required)
//        .unique(on: "phone_number", name: "unique_phone_number")
        .create()
    }

    func revert(on database: Database) async throws {
      try await database.schema("transactions").delete()
    }
  }
}

