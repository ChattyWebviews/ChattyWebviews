//
//  HTTPResponseHandler.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 20.03.23.
//

import Foundation

protocol HTTPRequestHandler {
    func handleResponse(result: HTTPClientProtocol.ResponseResult, handler: @escaping (Result<Void, Error>) -> Void)
    func handleResponse<T: Decodable>(of type: T.Type, result: HTTPClientProtocol.ResponseResult, handler: @escaping (Result<T, Error>) -> Void)
    static func parse<T: Decodable>(type: T.Type, data: Data) -> T?
    static func parseError(data: Data) -> String? //TODO: remove this once error format is unified
    
}

extension HTTPRequestHandler {
    
    
    func handleResponse(result: HTTPClientProtocol.ResponseResult, handler: @escaping (Result<Void, Error>) -> Void) {
        switch result {
        case .success( _):
            handler(.success(()))
                
            case .failure(let error):
                if let err = error as? URLSessionHTTPClientError {

                } else {
            
                }
                
            }
    }
    
    
    func handleResponse<T: Decodable>(of type: T.Type = T.self, result: HTTPClientProtocol.ResponseResult, handler: @escaping (Result<T, Error>) -> Void) {
        
        switch result {
            case .success(let data):
                if let dto = Self.parse(type: T.self, data: data) {
                    handler(.success(dto))
                } else {
                    //handler(.failure(.errorResponse("Parsing data failed")))
                }
            
            
        case .failure(let error):
            if let err = error as? URLSessionHTTPClientError {
              
            } else {
              //  handler(.failure(.errorResponse(error.localizedDescription)))
            }
                
            
                
            }
    }
    
    static func parse<T: Decodable>(type: T.Type, data: Data) -> T? {
        if let result = try? JSONDecoder().decode(T.self, from: data) {
            return result
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            print(json)
            return nil
        } catch {
            return nil
        }
    }
    

    static func parseError(data: Data) -> String? {
        
        if let err = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            return err.msg
        }
        
        return nil
        
        
        
    }
    
}

