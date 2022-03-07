//
//  ServerObjectsModelReq.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import Foundation

/// the request model for Objects
/// - Parameters:
///   - metadataDate: datetime e.g. YYYY-MM-DD
///   - departmentIds: integers that correspond to department IDs e.g. 1 or 3|9|12, delimited with the | character
public struct ServerObjectsModelReq: Codable {
    let metadataDate: String?
    let departmentIds: [Int]

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // filter the key if unnecessary
        if let metadataDateT = metadataDate {
            try container.encode(metadataDateT, forKey: .metadataDate)
        }
        // mapping to the special form when firing the request
        if departmentIds.count > 0 {
            try container.encode(
                departmentIds.map { $0.stringValue }.joined(separator: "|"),
                forKey: .departmentIds
            )
        }
    }
}
