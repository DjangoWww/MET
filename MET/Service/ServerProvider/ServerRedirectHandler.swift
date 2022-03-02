//
//  ServerRedirectHandler.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Alamofire

/// ServerRedirectHandler
public struct ServerRedirectHandler: RedirectHandler {
    public func task(
        _ task: URLSessionTask,
        willBeRedirectedTo request: URLRequest,
        for response: HTTPURLResponse,
        completion: @escaping (URLRequest?) -> Void
    ) {
        var redirectedRequest = request
        if let originalRequest = task.originalRequest,
            let headers = originalRequest.allHTTPHeaderFields,
            let authorizationHeaderValue = headers["Authorization"] {
            redirectedRequest.setValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
        }
        completion(redirectedRequest)
    }
    
}
