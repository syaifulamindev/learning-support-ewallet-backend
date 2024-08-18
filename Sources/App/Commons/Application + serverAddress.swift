//
//  File.swift
//  
//
//  Created by Macbook on 19/08/24.
//

import Vapor

extension Application {
  var serverAddress: String {
    http.server.configuration.addressString
  }
}

extension HTTPServer.Configuration {
  var addressString: String {
      let scheme = tlsConfiguration == nil ? "http" : "https"
      switch address {
      case .hostname(let hostname, let port):
          return "\(scheme)://\(hostname ?? Self.defaultHostname):\(port ?? Self.defaultPort)"
      case .unixDomainSocket(let socketPath):
          return "\(scheme)+unix: \(socketPath)"
      }
  }
}



