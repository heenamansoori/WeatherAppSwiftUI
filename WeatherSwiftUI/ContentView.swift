//
//  ContentView.swift
//  WeatherSwiftUI
//
//  Created by Heena Mansoori on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: WeatherViewModel
    @State private var city: String = ""
    @State private var weatherDescription: String = "Enter a city to get the weather"
    @State private var weatherImage: String = "cloud.sun.fill"
    
        init(viewModel: WeatherViewModel) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    
    var body: some View {
        VStack {
            if let weather = viewModel.weather {
                TextField("Enter city", text: $city, onCommit: {
                    viewModel.fetchWeather(for: city)
                })
                
                Image(systemName: weatherImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding()
                
                Text(weatherDescription)
                    .font(.title)
                    .padding()
            }
        }
        //            if let weather = viewModel.weather {
        //                Text("Temperature: \(weather.main.temp)°C")
        //                Text("Condition: \(weather.weather.first?.description ?? "")")
        //            } else if let errorMessage = viewModel.errorMessage {
        //                Text("Error: \(errorMessage)")
        //            } else {
        //                Text("Loading...")
        //            }
    }
    //        .onAppear {
    //            viewModel.fetchWeather(for: "New York")
    //        }
    
    func fetchWeather(for city: String) {
        // Simulate a network call to fetch weather data
        // Update weatherDescription and weatherImage based on the fetched data
        weatherDescription = "Sunny 75°F" // Example
        weatherImage = "sun.max.fill" // Example
    }
}





