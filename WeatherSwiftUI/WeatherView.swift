//
//  WeatherView.swift
//  WeatherSwiftUI
//
//  Created by Heena Mansoori on 8/31/24.
//


import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: $viewModel.isNight)
            VStack(spacing: 40) {
                HStack{
                    TextField("Enter city name", text: $viewModel.city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onSubmit {
                            saveToUserDefaults(input: $viewModel.city.wrappedValue)
                        }
                    Button(action: {
                        locationManager.getLocation()
                        if let location = locationManager.location {
                            viewModel.city = ""
                            viewModel.fetchWeather(for: location)
                            
                        }
                    }) {
                        Image(systemName: "location.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                }
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let weather = viewModel.weather {
                    VStack {
                        if let iconURL = URL(string: viewModel.iconImageURL){
                            AsyncImage(url: iconURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)
                                        .clipped()    
                                } placeholder: {
                                    ProgressView()
                                }
                        }
                        Text("\(weather.cityName)")
                            .font(.system(size: 30))
                        Text("\(weather.temperature, specifier: "%.0f")°C")
                            .font(.system(size: 70))
                        Text(weather.description.capitalized)
                            .font(.system(size: 20))
                    }
                    .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
            loadFromUserDefaults()
            
        }
    }
    private func saveToUserDefaults(input: String) {
        UserDefaults.standard.set(input, forKey: "lastSearchedText")
    }
    
    private func loadFromUserDefaults() {
        if let savedInput = UserDefaults.standard.string(forKey: "lastSearchedText") {
            viewModel.fetchWeather(cityName: savedInput)
        }else {
            viewModel.fetchWeather(cityName: "New York")
        }
    }
    }
    
    struct BackgroundView: View {
        @Binding var isNight: Bool
        
        var body: some View {
            LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray : .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    

