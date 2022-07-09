//
//  WeatherModel.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation

struct WeatherModel {
    
    var city = "Tokyo"
    var days = 7
    
    var temperature = 0.0
    var humidity = 0
    var cloud = 0
    var feelsLikeC = 0.0
    var visKM = 0.0
    
    var text : WeatherText = .clear
    var icon: Icon = .cdnWeatherapiCOMWeather64X64Day113PNG
    
    var weatherDays = [WeatherDay]()
    
    func convert(forecastDay: [Forecastday]) -> [WeatherDay] {
        var finalWeatherDay: [WeatherDay] = []
        var dayDetails: WeatherDayDetails
        for day in forecastDay {
            dayDetails = WeatherDayDetails(maxtempC: day.day.maxtempC,
                                           mintempC: day.day.mintempC,
                                           textCondition: day.day.condition.text.rawValue,
                                           iconCondition: day.day.condition.icon.rawValue,
                                           codeCondition: day.day.condition.code)
            
            let finalDay = WeatherDay(date: day.date, day: dayDetails)
            finalWeatherDay.append(finalDay)
        }
        return finalWeatherDay
    }
}

struct WeatherDay {
    var id = UUID()
    var date: String
    var day: WeatherDayDetails
}

struct WeatherDayDetails {
    var maxtempC: Double
    var mintempC: Double
    var textCondition: String
    var iconCondition: String
    var codeCondition: Int
}
