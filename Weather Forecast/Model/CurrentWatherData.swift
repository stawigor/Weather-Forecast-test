//
//  WatherData.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import Foundation

struct CurrentWeatherData: Codable {
    let data: [Datum]
}

struct Datum: Codable {
    let city_name: String
    let temp: Double
    let weather: Weather
}

struct Weather: Codable {
    let description: String
    let code: Int
}

