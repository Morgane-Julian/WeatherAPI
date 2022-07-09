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
    
    //MARK: - Weather functions
    func getWeather(city: String) {
        weatherService.getWeather(city: city, days: self.days) { weatherResult in
            DispatchQueue.main.async {
                switch weatherResult {
                case .success(let weatherResponse):
                    self.items.removeAll()
                    self.weather.city = weatherResponse.location.name
                    self.weather.cloud = weatherResponse.current.cloud
                    self.weather.feelsLikeC = weatherResponse.current.feelslikeC
                    self.weather.humidity = weatherResponse.current.humidity
                    self.weather.icon = weatherResponse.current.condition.icon
                    self.weather.temperature = weatherResponse.current.tempC
                    self.weather.text = weatherResponse.current.condition.text
                    self.weather.visKM = weatherResponse.current.visKM
                    self.weather.pression = weatherResponse.current.pressureMB
                    
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
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    completionHandler(nil)
                    print("Impossible to convert the location")
                }
            })
        }
        else {
            completionHandler(nil)
            print("Location disable, verify your settings")
            requestLocation()
        }
    }
    
    func getLocationAndCallApiWeather() {
        self.lookUpCurrentLocation() { location in
            if let locality = location?.locality {
                self.city = locality
            }
            self.getWeather(city: self.city)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.getLocationAndCallApiWeather()
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            //TODO: handle the error
        }
    
}
