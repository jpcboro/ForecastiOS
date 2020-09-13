//
//  WeatherModel.swift
//  Forecast
//
//  Created by jboro on 9/12/20.
//  Copyright © 2020 jboro. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var conditionName: String{
        return getWeatherDescription(weatherId: conditionId)
    }
    
    var temperatureInCelsius: String{
        let convertedKtoCTemp = temperature - 273.15
        return String(format: "%.1f C", convertedKtoCTemp)
    }
    
    func getWeatherDescription(weatherId: Int) -> String {
           switch weatherId {
           case 200...232:
               return "cloud.bolt"
           case 300...321:
               return "cloud.drizzle"
           case 500...531:
               return "cloud.rain"
           case 600...622:
               return "cloud.snow"
           case 701...781:
               return "cloud.fog"
               case 800:
               return "sun.max"
           case 801...804:
               return "cloud.bolt"
           default:
               return "sun.max"
           }
       }
       
}
