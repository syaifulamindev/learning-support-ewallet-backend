// //	Created for . in 02/08/24

import Vapor

public final class SuccessMiddleware: Middleware {
  /// Structure of `ErrorMiddleware` default response.
  
  
  internal struct SuccessResponse: Codable {
    /// Always `false` to indicate this is a non-typical JSON response.
    var success: Bool
    
    /// The reason for the error.
    var message: String
    
    //    ///response data
    var data: String?
  }
  
  /// Create a default `ErrorMiddleware`. Logs errors to a `Logger` based on `Environment`
  /// and converts `Error` to `Response` based on conformance to `AbortError` and `Debuggable`.
  ///
  /// - parameters:
  ///     - environment: The environment to respect when presenting errors.
  public static func `default`(environment: Environment) -> SuccessMiddleware {
    return .init { req, res in
      let status: HTTPResponseStatus = res.status
      let reason = res.body
      var headers: HTTPHeaders = res.headers
      
      
      // attempt to serialize the error to json
      let body: Response.Body
      do {
//        body = .init(
//          buffer: try JSONEncoder().encodeAsByteBuffer(
//            SuccessResponse(success: true, message: "reason"),
//            allocator: req.byteBufferAllocator),
//          byteBufferAllocator: req.byteBufferAllocator
//        )
        
        let resultData = try JSONEncoder().encode(
          SuccessResponse(success: true, message: "reason", data: res.body.string)
        )
        
        body = .init(data: resultData)
        headers.contentType = .json
      } catch {
        body = .init(string: "Oops: \(String(describing: error))\nWhile encoding error: \(reason)", byteBufferAllocator: req.byteBufferAllocator)
        headers.contentType = .plainText
      }
      
      // create a Response with appropriate status
      return Response(status: status, headers: headers, body: body)
    }
  }
  
  /// Success-handling closure.
  private let closure: @Sendable (Request, Response) -> (Response)
  
  /// Create a new `SuccessMiddleware`.
  ///
  /// - parameters:
  ///     - closure: Success-handling closure. Converts `Error` to `Response`.
  @preconcurrency public init(_ closure: @Sendable @escaping (Request, Response) -> (Response)) {
    self.closure = closure
  }
  
  public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
    //        next.respond(to: request).flatMapErrorThrowing { error in
    //            self.closure(request, error)
    //        }
    
    //    next.respond(to: request).flatMapErrorThrowing { error in
    //      self.closure(request, error)
    //    }
    
    next.respond(to: request)
      .flatMapThrowing { response in
        self.closure(request, response)
      }
    
    
  }
}
