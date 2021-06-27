//
//  ForecastWeatherData.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import Foundation

struct ForecastWeatherData: Codable {
    let data: [DatumForecast]
    let city_name: String
}

struct DatumForecast: Codable {
    let weather: WeatherForecast
    let datetime: String
    let temp: Double
}

struct WeatherForecast: Codable {
    let description: String
    let code: Int
}

