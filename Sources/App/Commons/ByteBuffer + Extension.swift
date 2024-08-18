//
//  File.swift
//  
//
//  Created by Macbook on 18/08/24.
//
import Vapor
extension ByteBuffer {
  var string: String? {
    String(data: Data(buffer: self), encoding: .utf8)
  }
}
