// //	Created for . in 01/08/24

import Vapor
import JWTKit

struct SessionToken: Content, Authenticatable, JWTPayload {
  // Maps the longer Swift property names to the
  // shortened keys used in the JWT payload.
  enum CodingKeys: String, CodingKey {
    case subject = "sub"
    case expiration = "exp"
    case userId = "id"
  }
  
  var subject: SubjectClaim
  var expiration: ExpirationClaim
  var userId: UUID

  // Run any additional verification logic beyond
  // signature verification here.
  // Since we have an ExpirationClaim, we will
  // call its verify method.
  func verify(using algorithm: some JWTAlgorithm) async throws {
    try self.expiration.verifyNotExpired()
  }
}
