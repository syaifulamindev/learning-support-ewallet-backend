// //	Created for . in 02/08/24

import Vapor

struct UserResponse: Content {
  let id: UUID?
  let username: String
  let email: String
  let phoneNumber: String


  init(_ user: User) {
    self.id = user.id
    self.username = user.username
    self.email = user.email
    self.phoneNumber = user.phoneNumber

  }
}
