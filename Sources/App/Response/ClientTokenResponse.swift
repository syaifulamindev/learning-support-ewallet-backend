// //	Created for . in 01/08/24

import Vapor

struct ClientTokenResponse: Content {
  let token: String
  let user: UserResponse
  init(token: String, user: UserResponse) {
    self.token = token
    self.user = user
  }
}
