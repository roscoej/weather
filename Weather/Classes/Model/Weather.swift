//
//  Weather.swift
//  Weather
//
//  Created by Jacob Roscoe on 2020/7/1.
//  Copyright © 2020 ColorTV. All rights reserved.
//

import UIKit

enum Units: String {
    case metric, imperal
}

class Weather {
    private let lat: Double
    private let lon: Double
    public let main: String
    public let description: String
    public let icon: String
    public let temperature: Double
    public let pressure: Double
    public let humidity: Double
    public let windSpeed: Double
    public let windDeg: Double
    
    
    init(lat: Double, lon: Double,
         main: String, description: String, icon: String,
         temperature: Double, pressure: Double, humidity: Double,
         windSpeed: Double, windDeg: Double) {
        
        self.lat = lat
        self.lon = lon
        self.main = main
        self.description = description
        self.icon = icon
        self.temperature = temperature
        self.pressure = pressure
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDeg = windDeg
    }
    
    // MARK: - Methods
    public func getIconURL() -> String {
        return "http://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    public func saveToUserDefaults() {
        
        let lat = round(self.lat * 10) / 10
        let lon = round(self.lon * 10) / 10
        
        if var weatherArr = UserDefaults.standard.array(forKey: Constants.UserDefautls_Weathers) as? [[String: Any]] {
            
            if let index = weatherArr.firstIndex(where: { (weatherDic) -> Bool in
                return (weatherDic["lat"] as? Double) == lat && (weatherDic["lon"] as? Double) == lon
            }) {
                weatherArr[index] = [
                    "lat": lat,
                    "lon": lon,
                    "main": self.main,
                    "description": self.description,
                    "icon": self.icon,
                    "temperature": self.temperature,
                    "pressure": self.pressure,
                    "humidity": self.humidity,
                    "windSpeed": self.windSpeed,
                    "windDeg": self.windDeg
                ]
                
                UserDefaults.standard.set(weatherArr, forKey: Constants.UserDefautls_Weathers)
                UserDefaults.standard.synchronize()
            } else {
                
                weatherArr.append([
                    "lat": lat,
                    "lon": lon,
                    "main": self.main,
                    "description": self.description,
                    "icon": self.icon,
                    "temperature": self.temperature,
                    "pressure": self.pressure,
                    "humidity": self.humidity,
                    "windSpeed": self.windSpeed,
                    "windDeg": self.windDeg
                ])
                
                UserDefaults.standard.set(weatherArr, forKey: Constants.UserDefautls_Weathers)
                UserDefaults.standard.synchronize()
            }
            
        } else {
            
            let weatherDic: [String: Any] = [
                "lat": lat,
                "lon": lon,
                "main": self.main,
                "description": self.description,
                "icon": self.icon,
                "temperature": self.temperature,
                "pressure": self.pressure,
                "humidity": self.humidity,
                "windSpeed": self.windSpeed,
                "windDeg": self.windDeg
            ]
            
            UserDefaults.standard.set([weatherDic], forKey: Constants.UserDefautls_Weathers)
            UserDefaults.standard.synchronize()
        }
    }
    
    class func loadFromUserDefaults(for lat: Double, lon: Double) -> Weather? {
        
        let lat = round(lat * 10) / 10
        let lon = round(lon * 10) / 10
        
        if let weatherArr = UserDefaults.standard.array(forKey: Constants.UserDefautls_Weathers) as? [[String: Any]] {
            
            if let weatherDic = weatherArr.first(where: { (weatherDic) -> Bool in
                return (weatherDic["lat"] as? Double) == lat && (weatherDic["lon"] as? Double) == lon
            }) {
                
                return Weather(
                    lat: lat, lon: lon,
                    main: weatherDic["main"] as! String, description: weatherDic["description"] as! String, icon: weatherDic["icon"] as! String,
                    temperature: weatherDic["temperature"] as! Double, pressure: weatherDic["pressure"] as! Double, humidity: weatherDic["humidity"] as! Double,
                    windSpeed: weatherDic["windSpeed"] as! Double, windDeg: weatherDic["windDeg"] as! Double
                )
            } else {
                
                return nil
            }
            
        } else {
            
            return nil
        }
    }
}
