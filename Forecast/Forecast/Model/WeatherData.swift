//
//  WeatherData.swift
//  Forecast
//
//  Created by jboro on 9/12/20.
//  Copyright © 2020 jboro. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon : String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

struct Main: Codable{
    let temp: Double
}
