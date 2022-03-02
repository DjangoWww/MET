//
//  ServerAPI.swift
//  CarSelect
//
//  Created by Django on 3/2/22.
//

import Moya

/// Server API
public enum ServerAPI {
    /// getTest
    case getTest
}

// MARK: - TargetType
extension ServerAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }

    public var baseURL: URL {
        return "https://google.com".urlValue!
    }

    public var path: String {
        switch self {
        case .getTest:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getTest:
            return .get
        }
    }

    public var sampleData: Data {
        /// use it for unit test or you can just fire a request instead
        return "{}".data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case .getTest:
            return .requestPlain
        }
    }
}
