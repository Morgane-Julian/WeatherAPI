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
    var icon = ""
    
    var text : WeatherText = .clear
    
    var weatherDays = [WeatherDay]()
    var iconSun = [1000]
    var iconCloudAndRain = [1003]
    var iconCloud = [1006,1009,1030]
    var iconRain = [1063, 1069, 1072, 1087, 1150, 1153, 1168, 1171, 1180, 1183, 1186, 1189, 1192, 1195, 1198, 1201, 1240, 1243, 1246, 1249, 1252, 1255, 1276, 1279, 1282]
    var iconSnow = [1066, 1114, 1117, 1204, 1207, 1210, 1213, 1216, 1219, 1222, 1225, 1237, 1255, 1258, 1261, 1264]
    var iconFog = [1135, 1147]
    
    
    
    //MARK: - Utils functions
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "en_EN")
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

enum WeatherImage : String {
    case sun = "background_sun"
    case cloudSun = "background_sun_cloud"
    case cloud = "background_cloudy"
    case rain = "background_rain"
    case snow = "background_snow"
    case fog = "background_fog"
}
