//
//  MyService.swift
//  SideApps
//
//  Created by Nguyen Duc Tho on 8/31/20.
//  Copyright © 2020 Nguyen Duc Tho. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case zen
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id: Int, firstName: String, lastName: String)
    case showAccounts
}

extension MyService: TargetType {
    var baseURL: URL { return URL(string: "https://api.myservice.com")! }
    var path: String {
        switch self {
            case .zen:
                return "/zen"
            case .showUser(let id), .updateUser(let id, _, _):
                return "/users/\(id)"
            case .createUser(_, _):
                return "/users"
            case .showAccounts:
                return "/accounts"
        }
    }
    var method: Moya.Method {
        switch self {
            case .zen, .showUser, .showAccounts:
                return .get
            case .createUser, .updateUser:
                return .post
        }
    }
    var task: Task {
        switch self {
            case .zen, .showUser, .showAccounts: // Send no parameters
                return .requestPlain
            case let .updateUser(_, firstName, lastName):  // Always sends parameters in URL, regardless of which HTTP method is used
                return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: URLEncoding.queryString)
            case let .createUser(firstName, lastName): // Always send parameters as JSON in request body
                return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        switch self {
            case .zen:
                return "Half measures are as bad as nothing at all.".utf8Encoded
            case .showUser(let id):
                return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
            case .createUser(let firstName, let lastName):
                return "{\"id\": 100, \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
            case .updateUser(let id, let firstName, let lastName):
                return "{\"id\": \(id), \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
            case .showAccounts:
                // Provided you have a file named accounts.json in your bundle.
                guard let url = Bundle.main.url(forResource: "accounts", withExtension: "json"),
                    let data = try? Data(contentsOf: url) else {
                        return Data()
                }
                return data
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
