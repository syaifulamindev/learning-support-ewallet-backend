//
//  Contact.swift
//
//
//  Created by Macbook on 20/08/24.
//

import Vapor
import Fluent

final class Contact: Model, Content, @unchecked Sendable {

  static let schema: String = "contacts"
  @ID(key: .id)
  var id: UUID?

  @Parent(key: "user_id")
  var user: User

  @Parent(key: "contact_id")
  var contact: User

  init() {}


}
