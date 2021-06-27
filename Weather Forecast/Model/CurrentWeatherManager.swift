//
//  WeatherManager.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import Foundation
import CoreLocation
import RealmSwift

protocol CurrentWeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: CurrentWeatherManager, weather: CurrentWeatherStructure)
    func didFailWithError(error: Error)
}

struct CurrentWeatherManager {
    let weatherURL = "https://api.weatherbit.io/v2.0/current?key=eff53ef238f04179af48d63638579cee"
    
    
    var delegate: CurrentWeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&city=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
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
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> CurrentWeatherStructure? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode( CurrentWeatherData.self, from: weatherData)
            let id = decodedData.data[0].weather.code
            let temp = decodedData.data[0].temp
            let name = decodedData.data[0].city_name
            let weather = CurrentWeatherStructure(conditionId: id, cityName: name, temperature: temp)
            print(weather)
            let realm = try! Realm()
            let newNote = RealmWeather()
            self.addObjects(note: newNote, weather: weather)
            realm.beginWrite()
            realm.delete(realm.objects(RealmWeather.self))
            realm.add(newNote)
            try! realm.commitWrite()
            let lists = realm.objects(RealmWeather.self)
            print(newNote)
            print(lists)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)            
            return nil
        }
    }
    
    func addObjects(note: RealmWeather, weather: CurrentWeatherStructure) {
        note.conditionId = weather.conditionId
        note.cityName = weather.cityName
        note.temperature = weather.temperature
    }
}
