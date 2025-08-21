//
//  EmptyResponse.swift
//  Networking
//
//  Created by mohamed ramadan on 21/08/2025.
//

import Foundation
/// Empty response type for requests that don't return data
public struct EmptyResponse: Decodable {
    public init() {}
}
