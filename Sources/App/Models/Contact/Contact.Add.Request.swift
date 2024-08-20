//
//  File.swift
//
//
//  Created by Macbook on 20/08/24.
//

import Vapor
extension Contact { struct Add {} }

extension Contact.Add {
  struct Request: Content {
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
      case phoneNumber = "phone_number"
    }

  }
}
