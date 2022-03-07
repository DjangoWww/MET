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

    /// set ServerProvider.shouldUseStubClosure to mock the request,  notice that it won't work if it's not DEBUG
    public var sampleData: Data {
        let resString: String
        switch self {
        case .getObjects:
            resString =
            """
            {"total":6,"objectIDs":[437633,446281,441768,761570,441226,437010]}
            """
        case .getObject:
            resString =
            """
            {"objectID":544120,"isHighlight":false,"accessionNumber":"15.43.26","accessionYear":"1915","isPublicDomain":true,"primaryImage":"https://images.metmuseum.org/CRDImages/eg/original/15.43.26_rp.jpg","primaryImageSmall":"https://images.metmuseum.org/CRDImages/eg/web-large/15.43.26_rp.jpg","additionalImages":["https://images.metmuseum.org/CRDImages/eg/original/15.43.26_back.jpg","https://images.metmuseum.org/CRDImages/eg/original/15.43.26_lp.jpg","https://images.metmuseum.org/CRDImages/eg/original/15.43.26_front.jpg","https://images.metmuseum.org/CRDImages/eg/original/DP228708.jpg"],"constituents":null,"department":"Egyptian Art","objectName":"Amulet, Cat","title":"Cat amulet","culture":"","period":"Late Period","dynasty":"Dynasty 26–29","reign":"","portfolio":"","artistRole":"","artistPrefix":"","artistDisplayName":"","artistDisplayBio":"","artistSuffix":"","artistAlphaSort":"","artistNationality":"","artistBeginDate":"","artistEndDate":"","artistGender":"","artistWikidata_URL":"","artistULAN_URL":"","objectDate":"664–380 B.C.","objectBeginDate":-664,"objectEndDate":-712,"medium":"Faience","dimensions":"h. 2.3 cm (7/8 in)","measurements":[{"elementName":"Overall","elementDescription":null,"elementMeasurements":{"Height":2.3}}],"creditLine":"Bequest of Mary Anna Palmer Draper, 1915","geographyType":"From","city":"","state":"","county":"","country":"Egypt","region":"","subregion":"","locale":"","locus":"","excavation":"","river":"","classification":"","rightsAndReproduction":"","linkResource":"","metadataDate":"2020-12-13T04:47:59.42Z","repository":"Metropolitan Museum of Art, New York, NY","objectURL":"https://www.metmuseum.org/art/collection/search/544120","tags":[{"term":"Cats","AAT_URL":"http://vocab.getty.edu/page/aat/300265960","Wikidata_URL":"https://www.wikidata.org/wiki/Q146"}],"objectWikidata_URL":"","isTimelineWork":false,"GalleryNumber":"127"}
            """
        case .getDepartments:
            resString =
            """
            {"departments":[{"departmentId":1,"displayName":"American Decorative Arts"},{"departmentId":3,"displayName":"Ancient Near Eastern Art"},{"departmentId":4,"displayName":"Arms and Armor"},{"departmentId":5,"displayName":"Arts of Africa, Oceania, and the Americas"},{"departmentId":6,"displayName":"Asian Art"},{"departmentId":7,"displayName":"The Cloisters"},{"departmentId":8,"displayName":"The Costume Institute"},{"departmentId":9,"displayName":"Drawings and Prints"},{"departmentId":10,"displayName":"Egyptian Art"},{"departmentId":11,"displayName":"European Paintings"},{"departmentId":12,"displayName":"European Sculpture and Decorative Arts"},{"departmentId":13,"displayName":"Greek and Roman Art"},{"departmentId":14,"displayName":"Islamic Art"},{"departmentId":15,"displayName":"The Robert Lehman Collection"},{"departmentId":16,"displayName":"The Libraries"},{"departmentId":17,"displayName":"Medieval Art"},{"departmentId":18,"displayName":"Musical Instruments"},{"departmentId":19,"displayName":"Photographs"},{"departmentId":21,"displayName":"Modern Art"}]}
            """
        case .getSearch:
            resString =
            """
            {"total":6,"objectIDs":[437633,446281,441768,761570,441226,437010]}
            """
        }
        /// use it for unit test, set ServerProvider.shouldUseStubClosure to mock the request,  notice that it won't work if it's not DEBUG
        return resString.data(using: .utf8)!
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
