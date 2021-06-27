//
//  RealmWeather.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import Foundation
import RealmSwift

class RealmWeather: Object {
    
    
    @objc dynamic var conditionId: Int = 0
    @objc dynamic var cityName: String = ""
    @objc dynamic var temperature: Double = 0.0
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    @objc dynamic var temperatureTips: String {
        switch temperature {
        case ..<0:
            return "Today is frost"
        case 0...15:
            return "Today it's cool"
        default:
            return "Today it's warm"
        }
    }

    @objc dynamic var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }

    
}
