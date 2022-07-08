//
//  ContentViewModel.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation

final class ContentViewModel: ObservableObject {
    
    @Published var weather = WeatherModel()
    let weatherService = WeatherService()
    let days = 15
    
    func getWeather(city: String) {
        weatherService.getWeather(city: city, days: self.days) { weatherResult in
            DispatchQueue.main.async {
                switch weatherResult {
                case .success(let weatherResponse):
                    print(weatherResponse)
                    self.weather.cloud = weatherResponse.current.cloud
                    self.weather.feelsLikeC = weatherResponse.current.feelslikeC
                    self.weather.humidity = weatherResponse.current.humidity
                    self.weather.icon = weatherResponse.current.condition.icon
                    self.weather.temperature = weatherResponse.current.tempC
                    self.weather.text = weatherResponse.current.condition.text
                    self.weather.visKM = weatherResponse.current.visKM
                    print("Super on a reussi")
            case .failure(let errorMessage):
                // afficher une popup d'erreur à l'utilisateur
                    print("NOPE")
                }
            }
        }
    }
}
