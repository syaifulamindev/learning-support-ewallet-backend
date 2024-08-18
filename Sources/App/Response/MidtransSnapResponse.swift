//
//  File.swift
//  
//
//  Created by Macbook on 16/08/24.
//

import Vapor

struct MidtransSnapResponse: Content {
  let token: String
  let redirectUrl: String
  enum CodingKeys: String, CodingKey {
    case token = "token"
    case redirectUrl = "redirect_url"
  }
}
