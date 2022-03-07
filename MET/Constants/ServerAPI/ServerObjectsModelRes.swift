//
//  ServerObjectsModelRes.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import Foundation

/// the result for Objects request
/// - Parameters:
///   - total: The total number of publicly-available objects
///   - objectIDs: An array containing the object ID of publicly-available object
public struct ServerObjectsModelRes: ServerModelTypeRes {
    let total: Int
    let objectIDs: [Int]?
}

/*
 {
     "total": 1000,
     "objectIDs": [
         1,
         2,
         3,
         4,
         5,
         6,
         7,
         8,
         9,
         10
     ]
 }
 */
