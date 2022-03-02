//
//  URL+Extension.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Foundation

// MARK: - Protocol related
extension URL {
    public enum DomianProtocol: String {
        case http
        case https
    }

    public func switchProtocol(
        _ domainProtocol: DomianProtocol = .https,
        _ prefixSchemeIfNotFound: Bool = true
    ) -> URL? {
        let oldUrlString = absoluteString
        guard let oldProtocolString = scheme,
              let oldProtocolRange = oldUrlString.range(
                of: oldProtocolString
              ) else {
                  if prefixSchemeIfNotFound {
                      return (domainProtocol.rawValue + "://" + oldUrlString).urlValue
                  } else {
                      return nil
                  }
              }
        let newString = oldUrlString.replacingOccurrences(
            of: oldProtocolString,
            with: domainProtocol.rawValue,
            range: oldProtocolRange
        )
        return newString.urlValue
    }

    public func getBaseUrl() -> URL? {
        guard let schemeT = scheme, let hostT = host else { return nil }
        return (schemeT + "://" + hostT).urlValue
    }

    public func replaceBaseUrl(
        with urlString: String
    ) -> URL? {
        guard let baseUrlStr = getBaseUrl()?.absoluteString else { return self }
        let absoluteStr = absoluteString
        return absoluteStr
            .replacingOccurrenceOnce(
                of: baseUrlStr,
                with: urlString,
                option: .forwards
            )
            .urlValue
    }
}

// MARK: - requestValue
extension URL {
    public var requestValue: URLRequest {
        return URLRequest(url: self)
    }
}
