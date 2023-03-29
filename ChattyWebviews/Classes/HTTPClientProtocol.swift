//
//  HTTPClientProtocol.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 16.03.23.
//

import Foundation

enum CWError: Error {
    case errorResponse(String)
}

public protocol HTTPClientProtocol {
    
    typealias ResponseResult = Result<Data, Error>
    
    func get(_ url: URL, responseHandler: @escaping (ResponseResult) -> Void)
    func post(_ url: URL, body: Encodable, responseHandler: @escaping (ResponseResult) -> Void)
    func put(_ url: URL, body: Encodable, responseHandler: @escaping (ResponseResult) -> Void)
    func patch(_ url: URL, body: Encodable, responseHandler: @escaping (ResponseResult) -> Void)
}
