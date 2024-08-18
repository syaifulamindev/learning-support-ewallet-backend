// //	Created for . in 08/08/24

import Vapor


struct SuccessResponse<Data: Codable>: Content {
  let success: Bool
  let message: String
  let data: Data?
}
