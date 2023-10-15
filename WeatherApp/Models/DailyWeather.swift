//
//  DailyWeather.swift
//  WeatherApp
//
//  Created by Dzhami on 03.10.2023.
//

import Foundation

struct DailyWeather: Codable, Identifiable {
    var dt: Int
    var temp: Temperature
    var weather: [WeatherDetail]
    
    enum CodingKey: String {
        case dt
        case temp
        case wether
    }
    
    init() {
        dt = 0
        temp = Temperature(min: 0, max: 0)
        weather = [WeatherDetail(icon: "", main: "", description: "")]
    }
}

extension DailyWeather {
    var id: UUID {
        return UUID()
    }
}
