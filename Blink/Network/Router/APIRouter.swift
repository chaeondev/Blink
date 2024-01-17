//
//  APIRouter.swift
//  Blink
//
//  Created by Chaewon on 1/4/24.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var header: HTTPHeaders { get }
    var method: HTTPMethod { get }
    var query: [String: String] { get }
    var multipart: MultipartFormData { get }
    func asURLRequest() throws -> URLRequest
}

enum BaseURL: String {
    case user = "/v1/users"
    case workspace = "/v1/workspaces"
}
