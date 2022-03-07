//
//  ServerSearchModelReq.swift
//  MET
//
//  Created by Django on 3/7/22.
//

/// the request model for Search
/// - Parameters:
///   - q    Search term e.g. sunflowers    Returns a listing of all Object IDs for objects that contain the search query within the object’s data
///   - isHighlight    Boolean, true or false. Case sensitive.    Returns objects that match the query and are designated as highlights. Highlights are selected works of art from The Met Museum’s permanent collection representing different cultures and time periods.
///   - title    Boolean, true or false. Case sensitive.    Returns objects that match the query, specifically searching against the title field for objects.
///   - tags    Boolean, true or false. Case sensitive.    Returns objects that match the query, specifically searching against the subject keyword tags field for objects.
///   - departmentId    Integer    Returns objects that are a part of a specific department. For a list of departments and department IDs, refer to our /department endpoint: https://collectionapi.metmuseum.org/public/collection/v1/departments
///   - isOnView    Boolean, true or false. Case Sensitive.    Returns objects that match the query and are on view in the museum.
///   - artistOrCulture    Boolean, true or false. Case Sensitive.    Returns objects that match the query, specifically searching against the artist name or culture field for objects.
///   - medium    String, with multiple values separated by the | operator. Case Sensitive.    Returns objects that match the query and are of the specified medium or object type. Examples include: "Ceramics", "Furniture", "Paintings", "Sculpture", "Textiles", etc.
///   - hasImages    Boolean, true or false. Case sensitive.    Returns objects that match the query and have images.
///   - geoLocation    String, with multiple values separated by the | operator. Case Sensitive.    Returns objects that match the query and the specified geographic location. Examples include: "Europe", "France", "Paris", "China", "New York", etc.
///   - dateBegin    Integer. You must use both dateBegin and dateEnd    Returns objects that match the query and fall between the dateBegin and dateEnd parameters. Examples include: dateBegin=1700&dateEnd=1800 for objects from 1700 A.D. to 1800 A.D., dateBegin=-100&dateEnd=100 for objects between 100 B.C. to 100 A.D.
///   - dateEnd    Integer. You must use both dateBegin and dateEnd    Returns objects that match the query and fall between the dateBegin and dateEnd parameters. Examples include: dateBegin=1700&dateEnd=1800 for objects from 1700 A.D. to 1800 A.D., dateBegin=-100&dateEnd=100 for objects between 100 B.C. to 100 A.D.
public struct ServerSearchModelReq: Codable {
    let q: String
    let isHighlight: Bool?
    let title: Bool?
    let tags: Bool?
    let departmentId: Int?
    let isOnView: Bool?
    let artistOrCulture: Bool?
    let medium: String?
    let hasImages: Bool?
    let geoLocation: String?
    let dateBegin: String?
    let dateEnd: String?

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(q, forKey: .q)
        // filter the keys if unnecessary
        if let isHighlightT = isHighlight {
            try container.encode(isHighlightT, forKey: .isHighlight)
        }
        if let titleT = title {
            try container.encode(titleT, forKey: .title)
        }
        if let tagsT = tags {
            try container.encode(tagsT, forKey: .tags)
        }
        if let departmentIdT = departmentId {
            try container.encode(departmentIdT, forKey: .departmentId)
        }
        if let isOnViewT = isOnView {
            try container.encode(isOnViewT, forKey: .isOnView)
        }
        if let artistOrCultureT = artistOrCulture {
            try container.encode(artistOrCultureT, forKey: .artistOrCulture)
        }
        if let mediumT = medium {
            try container.encode(mediumT, forKey: .medium)
        }
        if let hasImagesT = hasImages {
            try container.encode(hasImagesT, forKey: .hasImages)
        }
        if let geoLocationT = geoLocation {
            try container.encode(geoLocationT, forKey: .geoLocation)
        }
        if let dateBeginT = dateBegin {
            try container.encode(dateBeginT, forKey: .dateBegin)
        }
        if let dateEndT = dateEnd {
            try container.encode(dateEndT, forKey: .dateEnd)
        }
    }
}
