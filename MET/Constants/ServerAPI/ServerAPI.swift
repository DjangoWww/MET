//
//  ServerAPI.swift
//  CarSelect
//
//  Created by Django on 3/2/22.
//

import Moya

/// Server API
public enum ServerAPI {
    /// returns a listing of all valid Object IDs available to use
    case getObjects(model: ServerObjectsModelReq?)
    ///  returns a record for an object, containing all open access data about that object, including its image (if the image is available under Open Access)
    case getObject(id: Int)
    /// returns a listing of all departments
    case getDepartments
    /// returns a listing of all Object IDs for objects that contain the search query within the object’s data
    case getSearch(model: ServerSearchModelReq)
}

// MARK: - TargetType
extension ServerAPI: TargetType {
    public var headers: [String : String]? {
        return nil
    }

    public var baseURL: URL {
        return "https://collectionapi.metmuseum.org".urlValue!
    }

    public var path: String {
        switch self {
        case .getObjects:
            return "public/collection/v1/objects"
        case .getObject(let id):
            return "public/collection/v1/objects/\(id)"
        case .getDepartments:
            return "public/collection/v1/departments"
        case .getSearch:
            return "public/collection/v1/search"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getObjects,
                .getObject,
                .getDepartments,
                .getSearch:
            return .get
        }
    }

    public var sampleData: Data {
        /// use it for unit test or you can just fire a request instead
        return "{}".data(using: .utf8)!
    }

    public var task: Task {
        switch self {
        case .getObjects(let model):
            guard let modelT = model else {
                return .requestPlain
            }
            return .requestParameters(
                parameters: modelT.dictValue() ?? [:],
                encoding: URLEncoding.queryString
            )
        case .getObject:
            return .requestPlain
        case .getDepartments:
            return .requestPlain
        case .getSearch(let model):
            return .requestParameters(
                parameters: model.dictValue() ?? [:],
                encoding: URLEncoding.queryString
            )
        }
    }
}
