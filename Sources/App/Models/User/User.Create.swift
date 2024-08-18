// //	Created for . in 30/07/24

import Vapor

extension User {
  struct Create: Content {
    var username: String
    var email: String
    var phoneNumber: String
    var password: String
    var confirmPassword: String
  }
}

extension User.Create: Validatable {
  static func validations(_ validations: inout Vapor.Validations) {
    validations.add("username", as: String.self, is: !.empty)
    validations.add("email", as: String.self, is: .email)
    validations.add("phoneNumber", as: String.self, is: .count(8...13))
    validations.add("password", as: String.self, is: .count(8...))
  }
}
