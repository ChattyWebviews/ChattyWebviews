//
//  UpdateCheckRequest.swift
//  ChattyWebviews
//
//  Created by Teodor Dermendzhiev on 20.03.23.
//

import Foundation

struct UpdateCheckRequest: Encodable {
    let email: String
    let appId: String
    let moduleName: String
    let currentMd5: String?
}

struct UpdateCheckResponse: Decodable {
    let hasUpdate: Bool
    let update: UpdateData
}

struct UpdateData: Decodable {
    let modulePath: String
    let md5: String
}

struct ErrorResponse: Decodable {
    let msg: String
}
