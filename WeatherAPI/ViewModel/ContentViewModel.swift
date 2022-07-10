//
//  ContentViewModel.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation
import CoreLocation

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var weatherDays = [WeatherDay]()
    @Published var weather = WeatherModel()
    
    
    private let locationManager = CLLocationManager()
    private let weatherService = WeatherService()
    private var city = ""
    private let days = 7
    var items = [Forecastday]()
    @Published var code = Int()
    
    //MARK: - Weather functions
    func getWeather(city: String) async {
        do {
            let result = try await weatherService.getWeather(city: city, days: self.days)
            DispatchQueue.main.async {
                self.items.removeAll()
                self.weather.city = result.location.name
                self.weather.cloud = result.current.cloud
                self.weather.feelsLikeC = result.current.feelslikeC
                self.weather.humidity = result.current.humidity
                self.weather.temperature = result.current.tempC
                self.weather.text = result.current.condition.text
                self.weather.visKM = result.current.visKM
                self.weather.pression = result.current.pressureMB
                self.weather.icon = result.current.condition.icon.rawValue
                self.code = result.current.condition.code
                
                for item in result.forecast.forecastday {
                    self.items.append(item)
                }
                self.weatherDays = self.weather.convert(forecastDay: self.items)
            }
           
        } catch {
            print(error)
        }
    }
    
    //MARK: User Location
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func lookUpCurrentLocation() async throws -> CLPlacemark? {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.reverseGeocodeLocation(lastLocation)
            return placemarks[0]
        } else {
            requestLocation()
            throw NetworkError.noLocation
        }
    }

    func getLocationAndCallApiWeather() async throws {
        do {
            let location = try await self.lookUpCurrentLocation()
            if let locality = location?.locality {
                self.city = locality
                await self.getWeather(city: self.city)
            }
        } catch {
            throw NetworkError.noLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task {
         try await self.getLocationAndCallApiWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    //MARK: - Utils functions
    func weatherImageWithIcon(icon: Int) -> WeatherImage {
        if weather.iconFog.contains(icon) {
            return .fog
        } else if weather.iconSun.contains(icon) {
            return .sun
        } else if weather.iconRain.contains(icon) {
            return .rain
        } else if weather.iconSnow.contains(icon) {
            return .snow
        } else if weather.iconCloud.contains(icon) {
            return .cloud
        } else if weather.iconCloudAndRain.contains(icon) {
            return .cloudSun
        }
        return .cloudSun
    }
}
