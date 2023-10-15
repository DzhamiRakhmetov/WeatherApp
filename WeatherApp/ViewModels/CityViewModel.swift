//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Dzhami on 03.10.2023.
//

import SwiftUI
import CoreLocation

final class CityViewModel: NSObject, ObservableObject {

     let locationManager = CLLocationManager()
    
    @Published var weather = WeatherResponse.empty()
    @Published var city: String = "Новосибирск" {
        didSet {
             getLocation()
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        return formatter
    }()
    
   override init() {
       super.init()
       setupLocation()
       getLocation()
    }
    
    var date: String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.dt)))
    }
    
    var weatherIcon: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].icon
        }
        return "sun.max.fill"
    }
    
    var temperature: String {
        return getTemperatureFor(temp: weather.current.temp)
    }
    
    var conditions: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].icon
        }
        return ""
    }
    
    var windSpeed: String {
        return String(format: "%0.1f", weather.current.wind_speed)
    }
    
    var humidity: String {
        return String(format: "%d%%", weather.current.humidity)
    }
    
    var rainChances: String {
        return String(format: "%0.0f%%", weather.current.dew_point)
    }
    
    // MARK: - Funcs
    
    func getTemperatureFor(temp: Double) -> String {
        return String(format: "%0.1f", temp)
    }
    
    func getTimeFor(timeStamp: Int) -> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    func getDayFor(timeStamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
     func getLocation() {
        CLGeocoder().geocodeAddressString(city) { placeMarks, error in
            if let places = placeMarks, let place = places.first {
                self.getWeather(coordinates: place.location?.coordinate)
            }
        }
    }

     private func getWeather(coordinates: CLLocationCoordinate2D?) {
         if let coordinates = coordinates {
            let urlString = API.getURLFor(lat: coordinates.latitude, lon: coordinates.longitude)
             print(coordinates)
             getWeatherInternal(city: city, for: urlString)
         } else {
             let urlString = API.getURLFor(lat: 37.5485, lon: -121.9886)
             getWeatherInternal(city: city, for: urlString)
           
         }
    }
    
    private func getWeatherInternal(city: String, for urlString: String) {
        NetworkManager<WeatherResponse>.fetch(for: URL(string: urlString)!) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather = response
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeatherIconFor(icon: String) -> Image {
        switch icon {
        case "01d":
            return Image (systemName: "sun.max.fill") //"clear_sky_day"
        case "01n":
            return Image (systemName: "moon.fill") //"clear_sky_night"
        case "02d":
            return Image (systemName: "cloud.sun.fill") //"few_clouds_day"
        case "02n":
            return Image (systemName: "cloud.moon.fill") //"few_clouds_night"
        case "03d":
            return Image (systemName: "cloud.fill") //"scattered_clouds"
        case "03n":
            return Image(systemName: "cloud.fill") //"scattered_clouds"
        case "04d":
            return Image(systemName: "cloud.fill") //"broken_clouds"
        case "04n":
            return Image(systemName: "cloud.fill") //"broken_clouds"
        case "09d":
            return Image (systemName: "cloud.drizzle.fill") //"shower_rain"
        case "09n":
            return Image(systemName: "cloud.drizzle.fi]l") //"shower_rain"
        case "10d":
            return Image(systemName: "cloud.heavyrain.fill")//"rain_day"
        case "10n":
            return Image(systemName: "cloud.heavyrain.fill") //"rain_night"
        case "11d":
            return Image (systemName: "cloud.bolt.fill") //"thunderstorm_day"
        case "11n":
            return Image (systemName: "cloud.bolt.fill") //"thunderstorm_night"
        case "13d":
            return Image (systemName: "cloud.snow.fill") //"snow"
        case "13n":
            return Image(systemName: "cloud.snow.fill") //"snow"
        case "50d":
            return Image (systemName: "cloud.fog.fill") //"mist"
        case "50n":
            return Image (systemName: "cloud.fog.fill") //"mist"
        default:
            return Image (systemName: "sun.max.fill")
        }
    }
}

extension CityViewModel: CLLocationManagerDelegate {
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               manager.stopUpdatingLocation()
               getWeather(coordinates: location.coordinate)
           }
       }
}

