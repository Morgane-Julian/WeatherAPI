//
//  NetworkError.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation

enum NetworkError: Error {
    case noData
    case invalidResponse
    case undecodableData
    case badURLConversion
    case noLocation
}
