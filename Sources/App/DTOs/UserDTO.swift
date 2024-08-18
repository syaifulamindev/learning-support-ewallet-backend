// //	Created for . in 29/07/24

import Fluent
import Vapor

struct UserDTO: Content {
  var id: UUID?
  var name: String?
  var email: String?
  var passwordHash: String?
  
//  func toModel() -> User {
//    let model = User()
//    
//    model.id = self.id
//    if let name  {
//      model.name = name
//    }
//    
//    if let email {
//      model.email = email
//    }
//    
//    if let passwordHash {
//      model.passwordHash = passwordHash
//    }
//    
//    return model
//  }
}
