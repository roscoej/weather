//
//  APIManager.swift
//  Weather
//
//  Created by Jacob Roscoe on 2020/7/1.
//  Copyright © 2020 ColorTV. All rights reserved.
//

import Alamofire
import SwiftyJSON

final class APIManager {
    
    static let shared = APIManager()
    
    // Get Weather from latitude and longitude
    func getWeather(lat: Double, lon: Double, units: Units = .metric, completion: @escaping ((_ weather: Weather?, _ err: String?) -> Void)) {
        
        let url = URL(string: "\(Constants.baseURL)?lat=\(lat)&lon=\(lon)&APPID=\(Constants.OWM_AppId)&units=\(units.rawValue)")!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.timeoutInterval = TimeInterval(30)
        
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        AF.request(URLRequest(url: url))
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    if json["message"].exists() {
                        completion(nil, json["message"].string)
                    } else {
                        
                        guard let mainObj = json["weather"].arrayValue.first else { 
                            completion(nil, "Unknown Error!")
                            return
                        }
                        
                        completion(
                            Weather(
                                lat: json["coord"]["lat"].double ?? lat, lon: json["coord"]["lon"].double ?? lon,
                                main: mainObj["main"].stringValue, description: mainObj["description"].stringValue, icon: mainObj["icon"].stringValue,
                                temperature: json["main"]["temp"].doubleValue, pressure: json["main"]["pressure"].doubleValue, humidity: json["main"]["humidity"].doubleValue,
                                windSpeed: json["wind"]["speed"].doubleValue, windDeg: json["wind"]["deg"].doubleValue)
                            , nil
                        )
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(nil, error.localizedDescription)
                }
        }
    }
}
