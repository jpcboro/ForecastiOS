//
// Created by jboro on 9/12/20.
// Copyright (c) 2020 jboro. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func updateWeather(weather: WeatherModel)
}

struct WeatherManager {
    let weatherAPIUrl =
    "https://api.openweathermap.org/data/2.5/weather?appid=7c62f7c2c487cf6d4dc16145c9819ab2"

    var delegate : WeatherManagerDelegate?

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
                    if let weatherModel = self.jsonParser(weatherData: safeData){
                        self.delegate?.updateWeather(weather: weatherModel)
                        
                    }


                }
            });
            sessionTask.resume()
        }
    }
    
    func jsonParser(weatherData: Data) -> WeatherModel?{
        let jsonDecoder = JSONDecoder()
        do{
            
            let decoded = try jsonDecoder.decode(WeatherData.self, from: weatherData)
//            let convToCelsius = decoded.main.temp - 273.15
            let id = decoded.weather[0].id
            let cityName = decoded.name
            let temp = decoded.main.temp
            
            let weatherModel = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weatherModel
        }catch{
            print(error)
            return nil
        }
       
    }
    
   
    
}
