//
//  ForecastWeatheerManager.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import Foundation
import CoreLocation

protocol ForecastWeatherManagerDelegate {
    func didUpdateForecastWeather(_ weatherManager: ForecastWeatherManager, weather: [ForecastWeatherStructure])
    func didFailForecastWithError(error: Error)
}

struct ForecastWeatherManager {
    let weatherURL = "https://api.weatherbit.io/v2.0/forecast/daily?key=eff53ef238f04179af48d63638579cee"
    
    var delegate: ForecastWeatherManagerDelegate?
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailForecastWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateForecastWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> [ForecastWeatherStructure]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode( ForecastWeatherData.self, from: weatherData)
            var weatherForecast = [ForecastWeatherStructure]()
            for day in 0...15 {
                let id = decodedData.data[day].weather.code
                let temp = decodedData.data[day].temp
                let name = decodedData.city_name
                let date = decodedData.data[day].datetime
                let weather = ForecastWeatherStructure(conditionId: id, cityName: name, temperature: temp, dateTime: date)
                weatherForecast.append(weather)
            }
            return weatherForecast
        } catch {
            delegate?.didFailForecastWithError(error: error)
            return nil
        }
    }
}
