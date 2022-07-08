//
//  Item.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation

struct Item: Identifiable {
    var id: Int
    var weatherText: String
    var image: String
    var temperature: Double
}
