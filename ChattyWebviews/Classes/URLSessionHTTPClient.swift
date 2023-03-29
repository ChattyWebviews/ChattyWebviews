//
//  URLSessionHTTPClient.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 16.03.23.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap {
            $0 as? [String: Any]
        }
    }
}

public enum URLSessionHTTPClientError: Error {
    
    case error(Data?, URLResponse?, Error)
    case unknown(Data?, URLResponse?)
  
}

public final class URLSessionHTTPClient: HTTPClientProtocol {
  private let session: URLSession

  public init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
    public func get(_ url: URL, responseHandler: @escaping (ResponseResult) -> Void) {
    
      let request = buildRequest(url: url, method: "GET")

    session.dataTask(with: request) { [weak self] data, response, error in
   
        self?.handleResponse(data, response, error, responseHandler)
    }.resume()
  }
    
    public func post(_ url: URL, body: Encodable, responseHandler: @escaping (ResponseResult) -> Void) {
        sendBody(body: body, url: url, method: "POST", responseHandler: responseHandler)
    }
    
    public func put(_ url: URL, body: Encodable, responseHandler: @escaping (ResponseResult) -> Void) {
        sendBody(body: body, url: url, method: "PUT", responseHandler: responseHandler)
    }
    
    public func patch(_ url: URL, body: Encodable, responseHandler: @escaping (ResponseResult) -> Void) {
        sendBody(body: body, url: url, method: "PATCH", responseHandler: responseHandler)
    }
    
    private func sendBody(body: Encodable, url: URL, method: String, responseHandler: @escaping (ResponseResult) -> Void) {
        let parameterDictionary = body.dictionary
        
        var request = buildRequest(url: url, method: method)
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary as Any,  options: []) else {
             return
        }
        
        let convertedString = String(data: httpBody, encoding: String.Encoding.utf8)
        
        request.httpBody = httpBody
         
        session.dataTask(with: request) { [weak self] data, response, error in
            self?.handleResponse(data, response, error, responseHandler)
        }.resume()
    }
    
    private func handleResponse(_ data: Data?, _ response: URLResponse?, _ error: Error?, _ responseHandler: @escaping (ResponseResult) -> Void) {
        let handledResponse = Self.handle(data: data, error: error, response: response)
        switch handledResponse {
        case .success(let _data):
          responseHandler(.success(_data))
        case .failure(let _error):
          responseHandler(.failure(_error))
        }
    }
    
    private func buildRequest(url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        if (auth) {
//            request.setValue("Bearer \(Storage.shared.getToken())", forHTTPHeaderField: "Authorization")
//        }
        return request
    }
}

extension URLSessionHTTPClient {

  internal static func handle(data: Data?, error: Error?, response: URLResponse?) -> Result<Data,URLSessionHTTPClientError> {
    if let _data = data,
       error == nil,
       let _response = response,
       let _res = _response as? HTTPURLResponse
    {
        switch _res.statusCode {
        case 200, 201, 202, 203, 204, 205:
            return .success(_data)
        default:
            print (_res.statusCode)
            break
        }
        
    }
      
      if let _error = error {
        return .failure(.error(data, response, _error))
      }
      
      return .failure(.unknown(data, response))
      
  }
}

