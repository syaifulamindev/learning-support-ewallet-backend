// //	Created for . in 30/07/24

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
  static let schema = "users"
  
  @ID(key: .id)
  var id: UUID?
  
  @Field(key: "username")
  var username: String
  
  @Field(key: "email")
  var email: String
  
  @Field(key: "phone_number")
  var phoneNumber: String
  
  @Field(key: "password_hash")
  var passwordHash: String

  @Siblings(through: Contact.self, from: \.$user, to: \.$contact)
  var contacts: [User]

  init(id: UUID? = nil, username: String, email: String, phoneNumber: String, passwordHash: String) {
    self.id = id
    self.username = username
    self.email = email
    self.phoneNumber = phoneNumber
    self.passwordHash = passwordHash
  }
  
  init() {}
}

extension User: ModelAuthenticatable {
  static let usernameKey = \User.$email
  
  static let passwordHashKey = \User.$passwordHash
  
  func verify(password: String) throws -> Bool {
    try Bcrypt.verify(password, created: self.passwordHash)
  }
  
}
