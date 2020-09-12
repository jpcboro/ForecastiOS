//
// Created by jboro on 9/12/20.
// Copyright (c) 2020 jboro. All rights reserved.
//

import Foundation

struct WeatherManager {
    let weatherAPIUrl =
    "https://api.openweathermap.org/data/2.5/weather?appid=7c62f7c2c487cf6d4dc16145c9819ab2"
    
    func getWeather(cityName: String){
        let urlString = "\(weatherAPIUrl)&q=\(cityName)"
        getWeatherRequestFromUrl(urlString)
    }
    
    
    private func getWeatherRequestFromUrl(_ urlString:String) {
        if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: URLSessionConfiguration.default)
            let sessionTask = urlSession.dataTask(with: url, completionHandler:{ (data, urlResponse, error) in
                if error != nil{
                    print(error!)
                    return
                }
                if let safeData = data{
                    self.jsonParser(weatherData: safeData)

                }
            });
            sessionTask.resume()
        }
    }
    
    func jsonParser(weatherData: Data){
        let jsonDecoder = JSONDecoder()
        do{
            
               let decoded = try jsonDecoder.decode(WeatherData.self, from: weatherData)
                print(decoded.name)
            let convToCelsius = decoded.main.temp - 273.15
            print("Temp: \(convToCelsius) C")
            getWeatherDescription(weatherId: decoded.weather[0].id)
            
        }catch{
            print(error)
        }
       
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
