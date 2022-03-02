//
//  Print.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Foundation
import UIKit

#if DEBUG
public func printDebug(
    _ items: Any...,
    separator: String = .spaceString,
    terminator: String = "\n",
    assertMessage: String? = nil,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line
) {
    if let msg = assertMessage {
        assertionFailure(msg, file: file, line: line)
    }
    let gFormatter = DateFormatter()
    gFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = gFormatter.string(from: Date())
    let queue = Thread.isMainThread ? "UI" : "BG"
    let fileURL = URL(string: "\(file)")?.lastPathComponent ?? "Unknown file"
    Swift.print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]: ")
    var idx = items.startIndex
    let endIdx = items.endIndex
    repeat {
        Swift.print(items[idx],
                    separator: separator,
                    terminator: idx == (endIdx - 1) ? terminator : separator)
        idx += 1
    } while idx < endIdx
}

public func printDebug<Target>(
    _ items: Any...,
    separator: String = .spaceString,
    terminator: String = "\n",
    assertMessage: String? = nil,
    to output: inout Target,
    file: StaticString = #file,
    function: String = #function,
    line: UInt = #line
) where Target : TextOutputStream {
    if let msg = assertMessage {
        assertionFailure(msg, file: file, line: line)
    }
    let gFormatter = DateFormatter()
    gFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = gFormatter.string(from: Date())
    let queue = Thread.isMainThread ? "UI" : "BG"
    let fileURL = URL(string: "\(file)")?.lastPathComponent ?? "Unknown file"
    var idx = items.startIndex
    let endIdx = items.endIndex
    var resString: String = .emptyString
    repeat {
        var temString: String = .emptyString
        Swift.print(items[idx],
                    separator: separator,
                    terminator: idx == (endIdx - 1) ? terminator : separator,
                    to: &temString)
        resString.append(temString)
        idx += 1
    } while idx < endIdx
    if let res = resString as? Target {
        output = res
    }
    Swift.print("✅ \(timestamp) {\(queue)} \(fileURL) > \(function)[\(line)]:")
    Swift.print(resString)
}
#else
public func printDebug(
    _ items: Any...,
    separator: String = .spaceString,
    terminator: String = "\n",
    assertMessage: String? = nil
) {
}

public func printDebug<Target>(
    _ items: Any...,
    separator: String = .spaceString,
    terminator: String = "\n",
    assertMessage: String? = nil,
    to output: inout Target
) {
}
#endif
