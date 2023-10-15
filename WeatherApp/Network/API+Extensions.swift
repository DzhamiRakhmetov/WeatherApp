//
//  API+Extensions.swift
//  WeatherApp
//
//  Created by Dzhami on 02.10.2023.
//

import Foundation

extension API {
    static let baseURLString = "https://api.openweathermap.org/data/2.5/"
    
    static func getURLFor(lat: Double, lon: Double) -> String {
        return "\(baseURLString)onecall?lat=\(lat)&lon=\(lat)&exclude=minutely&appid=\(key)&units=metric"
    }
}
