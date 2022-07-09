//
//  ContentViewModel.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation

final class ContentViewModel: ObservableObject {
    @Published var snappedItem = 0.0
    @Published var draggingItem = 0.0
    @Published var weatherDays = [WeatherDay]()
    @Published var weather = WeatherModel()
    let weatherService = WeatherService()
    let days = 7
    var items = [Forecastday]()
    
    //MARK: - Weather functions
    func getWeather(city: String) {
        weatherService.getWeather(city: city, days: self.days) { weatherResult in
            DispatchQueue.main.async {
                switch weatherResult {
                case .success(let weatherResponse):

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
                break
                }
            }
        }
    }
    
    //MARK: - Carousel functions

    func distance(_ item: Int) -> Double {
        let double = (draggingItem - Double(item)).remainder(dividingBy: Double(self.items.count))
        return double
    }
    
    func myXOffset(_ item: Int) -> Double {
        let angle = Double.pi * 2 / Double(self.items.count) * distance(item)
        return sin(angle) * 200
    }
}
