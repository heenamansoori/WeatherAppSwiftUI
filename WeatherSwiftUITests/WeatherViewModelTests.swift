//
//  WeatherViewModelTests.swift
//  WeatherSwiftUI
//
//  Created by Heena Mansoori on 9/24/24.
//

import XCTest
import Combine
@testable import WeatherSwiftUI



class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        viewModel = WeatherViewModel()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        cancellables = nil
    }
    
    func testFetchWeatherByCity() {
        // Given
        let expectation = XCTestExpectation(description: "Weather is loaded")
        let mockWeather = Weather(temperature: 25.0, description: "Sunny", cityName: "London", icon: "01d")
        
        // When
        viewModel.city = "London"
    
        
        
        // Simulate network request delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            XCTAssertEqual(self.viewModel.weather?.cityName, "London")
                XCTAssertNotNil(self.viewModel.weather)
                XCTAssertEqual(self.viewModel.weather?.cityName, mockWeather.cityName)
                expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testIsNightUpdatedCorrectly() {
        // Given
        let mockNightIcon = "01n"
        let mockDayIcon = "01d"
        
        // When: Simulate night icon
        viewModel.dayOrNight(mockNightIcon)
        
        // Then: Check isNight flag
        XCTAssertTrue(viewModel.isNight)
        
        // When: Simulate day icon
        viewModel.dayOrNight(mockDayIcon)
        
        // Then: Check isNight flag
        XCTAssertFalse(viewModel.isNight)
    }
}
