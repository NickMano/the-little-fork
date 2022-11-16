//
//  Routable.swift
//  TheLittleFork
//
//  Created by nicolas.e.manograsso on 14/11/2022.
//

import Foundation

protocol Routable {
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod: HttpMethod { get }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}
