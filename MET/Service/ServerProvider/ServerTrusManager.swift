//
//  ServerTrusManager.swift
//  MET
//
//  Created by Django on 3/2/22.
//

import Alamofire

/// ServerTrusManager
public final class ServerTrusManager: Alamofire.ServerTrustManager {
    init() {
        let allHostsMustBeEvaluated = false
        let evaluators = [String.emptyString: DisabledEvaluator()]
        super.init(allHostsMustBeEvaluated: allHostsMustBeEvaluated,
                   evaluators: evaluators)
    }
}
