//
//  QRCode.swift
//
//
//  Created by Macbook on 18/08/24.
//

import Foundation
import QREncode
import Vapor

func qr(_ value: Codable, path: String, filename: String, req: Request) async throws -> String {

  //Make sure to initialice using the correct path for qrencode
#if os(macOS)
  let qrencodePath = "/opt/homebrew/bin/qrencode"
#elseif os(Linux)
  let qrencodePath = "/usr/bin/qrencode"
#endif
  let jsonEncoder = JSONEncoder()
  let data = try jsonEncoder.encode(value)
//  let jsonData = try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
  let text = data.base64EncodedString(options: .endLineWithCarriageReturn)


  let savedPath = "\(FileManager.default.currentDirectoryPath)/Public/\(path)"
  let fileNameWithExtension = "\(filename).png"
  let fullSavedPath = "\(savedPath)/\(fileNameWithExtension)"
  let qrencode = QREncode(text: text, fileName: fileNameWithExtension, size: .large, path: qrencodePath)


  guard let data = try await qrencode.generateQR(on: req.application.threadPool, eventLoop: req.eventLoop) else {
    throw GenericError("cann't generate qr code")
  }

  if !FileManager.default.fileExists(atPath: savedPath) {
    try FileManager.default.createDirectory(atPath: savedPath, withIntermediateDirectories: true, attributes: nil)
  }

  guard FileManager.default.createFile(atPath: fullSavedPath, contents: data, attributes: nil) else {
    throw GenericError("cann't generate qr code")
  }

  let address = "\(req.headers.addressString ?? req.application.serverAddress)/\(path)/\(fileNameWithExtension)"


  return address

}

extension HTTPHeaders {
  var addressString: String? {
    guard let host = self.first(name: "Host") ?? self.first(name: "X-Forwarded-Host") else { return nil }

    if let proto = self.first(name: "X-Forwarded-Proto") {
      return "\(proto)://\(host)"
    }
    return host
  }
}
