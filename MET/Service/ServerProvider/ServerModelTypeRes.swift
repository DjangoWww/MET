//
//  ServerModelTypeRes.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Foundation

public protocol ServerModelTypeRes: Codable { }
extension Optional: ServerModelTypeRes where Wrapped: ServerModelTypeRes { }
