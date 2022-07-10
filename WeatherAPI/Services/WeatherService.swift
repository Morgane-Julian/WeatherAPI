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
    
    func getWeather(city: String, days: Int) async throws -> CurrentWeatherResponse {
        
        guard var urlComponents = URLComponents(string: "\(weatherURL)") else { throw NetworkError.badURLConversion }
        urlComponents.queryItems = [URLQueryItem(name: "key", value: ApiUtils.weatherKey), URLQueryItem(name: "q", value: city), URLQueryItem(name: "days", value: String(days))]
        guard let url: URL = urlComponents.url else { throw NetworkError.badURLConversion }
        
        let request = URLRequest.init(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...209).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        guard let dataDecoded = try? JSONDecoder().decode(CurrentWeatherResponse.self, from: data) else {
            throw NetworkError.undecodableData
        }
        return dataDecoded
    }
}
