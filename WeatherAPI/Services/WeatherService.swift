//
//  WeatherService.swift
//  WeatherAPI
//
//  Created by Morgane Julian on 08/07/2022.
//

import Foundation

final class WeatherService {
    
    private let session: URLSession
    private let weatherURL = "https://api.weatherapi.com/v1/forecast.json"
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func getWeather(city: String, days: Int, callback: @escaping (Result<CurrentWeatherResponse, NetworkError>) -> Void) {
        
        guard var urlComponents = URLComponents(string: "\(weatherURL)") else { return }
        urlComponents.queryItems = [URLQueryItem(name: "key", value: ApiUtils.weatherKey), URLQueryItem(name: "q", value: city), URLQueryItem(name: "days", value: String(days))]
        
        guard let url: URL = urlComponents.url else { return }
        
        let dataTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            guard let data = data else {
                callback(.failure(.noData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(CurrentWeatherResponse.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        })
        dataTask.resume()
    }
}
