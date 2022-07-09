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
    var pression = 0.0
    var weekDay = ""
    
    var text : WeatherText = .clear
    var icon: Icon = .cdnWeatherapiCOMWeather64X64Day113PNG
    
    var weatherDays = [WeatherDay]()
    
    //MARK: - Utils functions
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "fr_FR")
        let convertedDate = dateFormatter.date(from: date)

        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "E"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: convertedDate!)

        return timeStamp
    }
    
    func convert(forecastDay: [Forecastday]) -> [WeatherDay] {
        var finalWeatherDay: [WeatherDay] = []
        var dayDetails: WeatherDayDetails
        for day in forecastDay {
            dayDetails = WeatherDayDetails(maxtempC: day.day.maxtempC,
                                           mintempC: day.day.mintempC,
                                           textCondition: day.day.condition.text.rawValue,
                                           iconCondition: day.day.condition.icon.rawValue,
                                           codeCondition: day.day.condition.code)
            
            let finalDay = WeatherDay(date: convertDateFormatter(date: day.date), day: dayDetails)
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
