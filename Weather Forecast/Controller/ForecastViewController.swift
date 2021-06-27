//
//  ForecastViewController.swift
//  Weather Forecast
//
//  Created by stavigor on 27.06.2021.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var weatherForecast = [ForecastWeatherStructure]()    
    var forecastWeatherManager = ForecastWeatherManager()
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locManager.delegate = self
        locManager.requestWhenInUseAuthorization()
        locManager.requestLocation()
        
        forecastWeatherManager.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}
//MARK: - WeatherManagerDelegate

extension ForecastViewController: ForecastWeatherManagerDelegate {
    func didUpdateForecastWeather(_ weatherManager: ForecastWeatherManager, weather: [ForecastWeatherStructure]) {
        weatherForecast = weather
        DispatchQueue.main.async {
            self.weatherForecast = weather
            self.tableView.reloadData()
        }
        
        print(weatherForecast)
    }
    
    func didFailForecastWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension ForecastViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            forecastWeatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - Create Table

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellModel
        
        cell.dateTime.text = weatherForecast[indexPath.row].dateTime
        cell.temperature.text = weatherForecast[indexPath.row].temperatureString
        cell.weatherImage.image = UIImage(systemName: weatherForecast[indexPath.row].conditionName)
        print(weatherForecast[indexPath.row].temperatureString)
        print(weatherForecast[indexPath.row].conditionName)
        return cell
    }
    
}
