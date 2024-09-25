//
//  WeatherModel.swift
//  WeatherSwiftUI
//
//  Created by Heena Mansoori on 8/10/24.
//

import Foundation

struct Weather: Codable {
    let temperature: Double
    let description: String
    let cityName: String
    let icon: String
  
}

struct WeatherResponse: Codable {
    let main: Main
    let weather: [WeatherDetail]
    let name: String
    
    struct Main: Codable {
        let temp: Double
    }
    
    struct WeatherDetail: Codable {
        let description: String
        let icon: String
        let id: Int
    }
}
