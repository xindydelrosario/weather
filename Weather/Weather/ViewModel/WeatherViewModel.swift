//
//  WeatherViewModel.swift
//  Weather
//
//
//

import CoreLocation
import Foundation
import SwiftUI

enum LoadingState {
    case loading, success, failed, none
}

class WeatherViewModel: ObservableObject {
    
    @Published var myWeather: weatherResponse?
    @Published var loadingState: LoadingState = .none
    
    let webService = WebService()
    var city: String = "" {
        didSet {
            getForecastByCity(city: "")
        }
    }
    
    init(myWeather: weatherResponse? = nil) {
        self.myWeather = myWeather
    }
    
    let id = UUID()
    
    func getForecastByCity(city: String) {
        
        webService.getForecastByCity(city: city.trimmedAndEscaped()) { result in
            switch result {
            case .success(let myWeather):
                if let myWeather = myWeather {
                    DispatchQueue.main.async {
                        self.myWeather = myWeather
                        self.loadingState = .success
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.loadingState = .failed
            }
        }
    }
    
    var cityName: String {
        return myWeather!.city
    }
    
    
    var description: String {
        return myWeather!.desc0
    }
    
    // MARK: - Details

    var sunrise: Date {
        return myWeather!.sunrise
    }
    
    var sunset: Date {
        return myWeather!.sunset
    }
    
    var currentHumidity: String {
        return roundedOf(myWeather!.hum)
    }
    
    var currentWind: String {
        return roundedOf(myWeather!.speed)
    }
    
    var temp_Min: String {
        return roundedOf(myWeather!.temp_Min0)
    }
    
    var temp_Max: String {
        return roundedOf(myWeather!.temp_Max0)
    }

    //MARK: - 5-Day Forecast
    //MARK: - DATE
    
    var dailyDates: [Date] {
        return [ myWeather!.date0,
                 myWeather!.date1,
                 myWeather!.date2,
                 myWeather!.date3,
                 myWeather!.date4
        ]
    }
    
    //MARK: - Temperature
    
    func getTempByUnit(unit: TemperatureUnit) -> [String] {
        switch unit {
        case .celsius:
            return [ roundedOf(myWeather!.temp0),
                     roundedOf(myWeather!.temp1),
                     roundedOf(myWeather!.temp2),
                     roundedOf(myWeather!.temp3),
                     roundedOf(myWeather!.temp4)
            ]
        case .fahrenheit:
            return [ roundedOf(1.8 * (myWeather!.temp0) + 32),
                     roundedOf(1.8 * (myWeather!.temp1) + 32),
                     roundedOf(1.8 * (myWeather!.temp2) + 32),
                     roundedOf(1.8 * (myWeather!.temp3) + 32),
                     roundedOf(1.8 * (myWeather!.temp4) + 32)
            ]
        }
    }
    
    func roundedOf(_ roundOf: Double) -> String {
        return String(format: "%.0f", roundOf)
    }
    
    //MARK: - Weather Icon
    
    var dailyWeatherIcons: [String] {
        return [ myWeather!.icon0,
                 myWeather!.icon1,
                 myWeather!.icon2,
                 myWeather!.icon3,
                 myWeather!.icon4
        ]
    }

    func getIcon(main: String) -> Image {
        switch main {
        case "Thunderstorm":
            return Image(systemName: "cloud.bolt")
        case "Drizzle":
            return Image(systemName: "cloud.drizzle")
        case "Rain":
            return Image(systemName: "cloud.rain")
        case "Snow":
            return Image(systemName: "cloud.snow")
        case "Atmosphere":
            return Image(systemName: "cloud.fog")
        case "Clear":
            return Image(systemName: "cloud.sun")
        case "Clouds":
            return Image(systemName: "smoke")
            
        default:
            return Image(systemName: "cloud.sun")
        }
    }

    
    func getIconFor(icon: String) -> String {
        switch icon {
        case "01d":
            return String("sun")
        case "01n":
            return String("moon")
        case "02d":
            return String("fair")
        case "02n":
            return String("cloud-moon")
        case "03d":
            return String("cloud")
        case "03n":
            return String("cloud")
        case "04d":
            return String("cloud")
        case "04n":
            return String("cloud")
        case "09d":
            return String("shower")
        case "09n":
            return String("shower")
        case "10d":
            return String("rain")
        case "10n":
            return String("rain")
        case "11d":
            return String("storm")
        case "11n":
            return String("storm")
        case "13d":
            return String("snow")
        case "13n":
            return String("snow")
        case "50d":
            return String("tornado")
        case "50n":
            return String("tornado")
        default:
            return String("sun")
        }
    }
    
    func getSystemIcon(icon: String) -> String {
        switch icon {
        case "01d":
            return String("sun.min")
        case "01n":
            return String("moon")
        case "02d":
            return String("cloud.sun")
        case "02n":
            return String("cloud.moon")
        case "03d":
            return String("cloud")
        case "03n":
            return String("cloud")
        case "04d":
            return String("cloud")
        case "04n":
            return String("cloud")
        case "09d":
            return String("cloud.rain")
        case "09n":
            return String("cloud.rain")
        case "10d":
            return String("cloud.rain")
        case "10n":
            return String("cloud.rain")
        case "11d":
            return String("cloud.bolt.rain")
        case "11n":
            return String("cloud.bolt.rain")
        case "13d":
            return String("cloud.snow")
        case "13n":
            return String("cloud.snow")
        case "50d":
            return String("tornado.circle")
        case "50n":
            return String("tornado.circle")
        default:
            return String("sun.min")
        }
    }
}

