//
//  OpenWeatherMap.swift
//  Weathelder
//
//  Created by Michel on 15/04/2019.
//  Copyright © 2019 PDL. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation


protocol OpenWeatherMapDelegate {
    func updateWeatherInfo(weatherJson: JSON)
    func failure()
}

struct Weather : Codable {
    var id: String
    var descr: String
    var location: String
    var temp: String
    var pressure: String
    var humidity: String
    var imageName: String
}

struct Forecast : Codable {
    var id: String
    var datetime: String
    var descr: String
    var location: String
    var maxTemp: String
    var minTemp: String
    var imgName: String
}

var forData: Array<Forecast>=[]

class OpenWeatherMap {
    var forecastData: Array<(datetime : String, descr : String, location : String, icon : UIImage, maxTemp : String, minTemp : String)> = []
    
    var weatherData: (descr : String, location: String, icon : UIImage, temp : String, pressure : String, humidity : String)? = nil


    let weatherSourceURL  = "https://api.openweathermap.org/data/2.5/weather"
    let forecastSourceURL = "https://api.openweathermap.org/data/2.5/forecast"
    let APPID             = "3c7152c7fb4d359a403a121ed849729f"


    var delegate: OpenWeatherMapDelegate!

    func setRequest(sourceURL : URLConvertible) {
        request(sourceURL).responseJSON {
            (response) in

            if response.data != nil {
                do {
                    let weatherJSON = try JSON(data: response.data!)
                    DispatchQueue.main.async {
                        self.delegate.updateWeatherInfo(weatherJson: weatherJSON)
                        var weatherData = try? JSONDecoder().decode([Weather].self, from: response.data!)
                    }
                } catch let error {
                    self.delegate.failure()
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
        
    func getWeatherFor(city: String) {
        let URL   = "\(weatherSourceURL)?q=\(city)&APPID=\(APPID)"
        setRequest(sourceURL: URL)
    }
    
    func getForecastFor(city: String) {
        let URL   = "\(forecastSourceURL)?q=\(city)&APPID=\(APPID)"
        setRequest(sourceURL: URL)
    }
    
    func getWeatherFor(location: CLLocationCoordinate2D) {
        let URL   = "\(weatherSourceURL)?lat=\(location.latitude)&lon=\(location.longitude)&APPID=\(APPID)"
        setRequest(sourceURL: URL)
    }
    
    func getForecastFor(location: CLLocationCoordinate2D) {
        let URL   = "\(forecastSourceURL)?lat=\(location.latitude)&lon=\(location.longitude)&APPID=\(APPID)"
        setRequest(sourceURL: URL)
    }

    func getTimeFromUnix(unxTime: Int) -> String {
        let timeInSeconds        = TimeInterval(unxTime)
        let weatherDate          = Date(timeIntervalSince1970: timeInSeconds)

        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"

        return dateFormatter.string(from: weatherDate)
    }

    func getWeatherIcon(cond: Int, dayTime: Bool) -> UIImage {
        var imgName: String
        switch (cond, dayTime) {
        // thunderstorm
        case let (x,y) where x < 300 && y == true:  imgName  = "11d"
        case let (x,y) where x < 300 && y == false: imgName  = "11n"

        // drizzle
        case let (x,y) where x < 500 && y == true:  imgName  = "09d"
        case let (x,y) where x < 500 && y == false: imgName  = "09n"

        // rain
        case let (x,y) where x <= 504 && y == true:  imgName = "10d"
        case let (x,y) where x <= 504 && y == false: imgName = "10n"

        case let (x,y) where x == 511 && y == true:  imgName = "13d"
        case let (x,y) where x == 511 && y == false: imgName = "13n"

        case let (x,y) where x < 600 && y == true:  imgName  = "09d"
        case let (x,y) where x < 600 && y == false: imgName  = "09n"
        // snow
        case let (x,y) where x < 700 && y == true:  imgName  = "13d"
        case let (x,y) where x < 700 && y == false: imgName  = "13n"

        // atmosphere
        case let (x,y) where x < 800 && y == true:  imgName  = "50d"
        case let (x,y) where x < 800 && y == false: imgName  = "50n"

        // clear
        case let (x,y) where x == 800 && y == true:  imgName = "01d"
        case let (x,y) where x == 800 && y == false: imgName = "01n"

        // clouds
        case let (x,y) where x == 801 && y == true:  imgName = "02d"
        case let (x,y) where x == 801 && y == false: imgName = "02n"

        case let (x,y) where x == 802 && y == true:  imgName = "03d"
        case let (x,y) where x == 802 && y == false: imgName = "03n"

        case let (x,y) where x == 803 && y == true:  imgName = "04d"
        case let (x,y) where x == 803 && y == false: imgName = "04n"

        case let (x,y) where x == 804 && y == true:  imgName = "04d"
        case let (x,y) where x == 804 && y == false: imgName = "04n"

        // additional
        case let (x,y) where x < 1000 && y == true:  imgName = "11d"
        case let (x,y) where x < 1000 && y == false: imgName = "11n"

        default:
        imgName                                              = "unknown"
        }
        
        
        let iconImage = UIImage(named: imgName)

        return iconImage!
    }
    
    
    func convertPressure(pres: Float) -> String {
        return String(Int(pres/1.333)) + " mmhg"
    }
    
    
    func convertTemperature(country: String, temp: Float) -> String {
        if (country == "US") {
            //convert to Farenheit
            return String(Int(roundf((temp - 273.15) * 1.8 + 32))) + " °F"
        } else {
            //convert to Celsium
            return String(Int(roundf(temp - 273.15))) + " °C"
        }
    }
    
    
    func isDayTime(icon: String) -> Bool {
        return icon.range(of: "d") != nil
    }
}

