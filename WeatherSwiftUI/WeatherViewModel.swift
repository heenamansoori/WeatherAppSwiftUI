//
//  WeatherViewModel.swift
//  WeatherSwiftUI
//
//  Created by Heena Mansoori on 8/10/24.
//

import SwiftUI
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var weather: Weather?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var image: Image? = nil
    @Published var isNight: Bool = false
    @Published var iconImageURL: String = ""
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = ""

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Existing city observation
        $city
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] city in
                self?.fetchWeather(cityName: city)
            }
            .store(in: &cancellables)
    }
    
    //fetch by cityName
    func fetchWeather(cityName: String) {
        guard !cityName.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        let cityEncoded = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let urlString = "\(weatherURL)?q=\(cityEncoded)&appid=\(apiKey)&units=metric"
        performRequest(for: urlString)
    }
    
    //fetch by location
    func fetchWeather(for location: CLLocation) {
        let urlString = "\(weatherURL)?appid=\(apiKey)&units=metric&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)"
        performRequest(for: urlString)
    }
    
    func performRequest(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { Weather(temperature: $0.main.temp, description: $0.weather.first?.description ?? "", cityName: $0.name, icon: $0.weather.first?.icon ?? "") }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "Could not load weather: \(error.localizedDescription)"
                }
                self?.isLoading = false
            }, receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.dayOrNight(weather.icon)
                self?.iconImageURL = "https://openweathermap.org/img/wn/"+"\(weather.icon)"+"@2x.png"
            })
            .store(in: &cancellables)
        
    }
    
    func dayOrNight(_ value: String){
        if value.contains("n") {
            isNight = true
        } else { isNight = false }
    }
}
