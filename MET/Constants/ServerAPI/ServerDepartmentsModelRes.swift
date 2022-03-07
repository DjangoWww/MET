//
//  ServerDepartmentsModelRes.swift
//  MET
//
//  Created by Django on 3/7/22.
//

import Foundation

/// the result for Departments request
/// - Parameters:
///   - departments: An array containing the JSON objects that contain each department's departmentId and display name. The departmentId is to be used as a query parameter on the `/objects` endpoint
public struct ServerDepartmentsModelRes: ServerModelTypeRes {
    let departments: [DepartmentModel]
}

extension ServerDepartmentsModelRes {
    /// - Parameters:
    ///   - departmentId: Department ID as an integer. The departmentId is to be used as a query parameter on the `/objects` endpoint
    ///   - displayName: Display name for a department
    public struct DepartmentModel: Codable {
        let departmentId: Int
        let displayName: String
    }
}

/*
 {
     "departments":[
         {
             "departmentId":1,
             "displayName":"American Decorative Arts"
         },
         {
             "departmentId":3,
             "displayName":"Ancient Near Eastern Art"
         },
         {
             "departmentId":4,
             "displayName":"Arms and Armor"
         },
         {
             "departmentId":5,
             "displayName":"Arts of Africa, Oceania, and the Americas"
         },
         {
             "departmentId":6,
             "displayName":"Asian Art"
         },
         {
             "departmentId":7,
             "displayName":"The Cloisters"
         },
         {
             "departmentId":8,
             "displayName":"The Costume Institute"
         },
         {
             "departmentId":9,
             "displayName":"Drawings and Prints"
         },
         {
             "departmentId":10,
             "displayName":"Egyptian Art"
         },
         {
             "departmentId":11,
             "displayName":"European Paintings"
         },
         {
             "departmentId":12,
             "displayName":"European Sculpture and Decorative Arts"
         },
         {
             "departmentId":13,
             "displayName":"Greek and Roman Art"
         },
         {
             "departmentId":14,
             "displayName":"Islamic Art"
         },
         {
             "departmentId":15,
             "displayName":"The Robert Lehman Collection"
         },
         {
             "departmentId":16,
             "displayName":"The Libraries"
         },
         {
             "departmentId":17,
             "displayName":"Medieval Art"
         },
         {
             "departmentId":18,
             "displayName":"Musical Instruments"
         },
         {
             "departmentId":19,
             "displayName":"Photographs"
         },
         {
             "departmentId":21,
             "displayName":"Modern Art"
         }
     ]
 }
 */
