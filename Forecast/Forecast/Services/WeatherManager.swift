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
            let sessionTask = urlSession.dataTask(with: url,
                    completionHandler: handler(data:urlResponse:error:))
            sessionTask.resume()

        }

    }

    func handler(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if error != nil{
            print(error)
            return
        }

        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        }
    }
}
