//
//  ContentViewModel.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation
import CoreLocation

final class ContentViewModel: ObservableObject {
    
    @Published var weatherDays = [WeatherDay]()
    @Published var weather = WeatherModel()
   
    private let weatherService = WeatherService()
    private let days = 7
    var items = [Forecastday]()
    
    //MARK: - Weather functions
    func getWeather(city: String) {
        weatherService.getWeather(city: city, days: self.days) { weatherResult in
            DispatchQueue.main.async {
                switch weatherResult {
                case .success(let weatherResponse):
                    self.items.removeAll()
                    self.weather.cloud = weatherResponse.current.cloud
                    self.weather.feelsLikeC = weatherResponse.current.feelslikeC
                    self.weather.humidity = weatherResponse.current.humidity
                    self.weather.icon = weatherResponse.current.condition.icon
                    self.weather.temperature = weatherResponse.current.tempC
                    self.weather.text = weatherResponse.current.condition.text
                    self.weather.visKM = weatherResponse.current.visKM
                    
                    for item in weatherResponse.forecast.forecastday {
                        self.items.append(item)
                    }
                    
                    self.weatherDays = self.weather.convert(forecastDay: self.items)
                    
            case .failure:
                    //TODO: Mettre en place des logs
                break
                }
            }
        }
    }
    
    //MARK: User Location
    
    
    
}
