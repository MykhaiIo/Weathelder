//
//  ViewController.swift
//  Weathelder
//
//  Created by Michel on 19/04/2019.
//  Copyright © 2019 PDL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation

class WeatherViewController: UIViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {

    let openWeather            = OpenWeatherMap()
    let hud                    = MBProgressHUD()
    let locManager             = CLLocationManager()

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var lLocation: UIButton!
    @IBOutlet weak var lPressure: UILabel!
    @IBOutlet weak var lHumidity: UILabel!
    @IBOutlet weak var lWeatherDescr: UILabel!
    @IBOutlet weak var lTemperature: UILabel!
    
    @IBAction func bRefresh(_ sender: UIButton) {
        if (self.cityName != nil) {
            self.openWeather.getWeatherFor(city: cityName)
        }
    }
    
    @IBAction func bLocationTapped(_ sender: UIButton) {
        displayCity()
    }

    var cityName : String!

    override func viewDidLoad() {
        super.viewDidLoad()

    self.openWeather.delegate  = self

    locManager.delegate        = self

    locManager.desiredAccuracy = kCLLocationAccuracyBest
    locManager.requestWhenInUseAuthorization()
    locManager.startUpdatingLocation()
}
    
    func displayCity() {

        let alertController = UIAlertController(title: "City", message: "Enter city name", preferredStyle: UIAlertController.Style.alert)

        let cancelAction    = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)

        alertController.addAction(cancelAction)

        let okAction        = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (action) -> Void in

        let  cityField      = alertController.textFields![0]
//            let countryField = alertController.textFields![1]

            if cityField == alertController.textFields?.first as UITextField? /*&& countryField == alertController.textFields?.first as UITextField? */ {
                self.activityIndicator()
                self.cityName = cityField.text
                self.openWeather.getWeatherFor(city: cityField.text!)
            }
        }
        
        alertController.addAction(okAction)
        
        alertController.addTextField { (cityField) -> Void in
            cityField.placeholder = "City name"
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        hud.dimBackground = true
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    // MARK: OWMDelegates
    
    func updateWeatherInfo(weatherJson: JSON) {
        hud.hide(animated: true)
        if let tempResult      = weatherJson["main"]["temp"].float {
            // get country

        let country            = weatherJson["sys"]["country"].stringValue

            // get time

        let time               = weatherJson["dt"].intValue
        let timeToStr          = openWeather.getTimeFromUnix(unxTime: Int(time))

            // get convenient temperature

        let temp               = openWeather.convertTemperature(country: country, temp: tempResult)
        self.lTemperature.text = "\(temp)"

            // get city name

        let cityName           = weatherJson["name"].stringValue
        self.cityName = cityName
            print(self.cityName!)
            print(cityName)
        self.lLocation.setTitle("\(cityName), \(country)", for: UIControl.State.normal)
            let location = "\(cityName), \(country)"

            // get pressure
        let weather            = weatherJson["weather"][0]
        let pressure           = openWeather.convertPressure(pres: weatherJson["main"]["pressure"].floatValue)
        self.lPressure.text    = pressure

            // get humidity

        let humidity           = weatherJson["main"]["humidity"].intValue
        self.lHumidity.text    = String(humidity) + " %"

            // get icon


        let cond               = weather["id"].intValue
        let strIcon            = weather["icon"].stringValue
        let dayTime            = openWeather.isDayTime(icon: strIcon)
        let icon               = openWeather.getWeatherIcon(cond: cond, dayTime: dayTime)
        self.weatherIcon.image  = icon

            // get description

        let description         = weather["description"].stringValue
        self.lWeatherDescr.text = "\(description)"
            
          openWeather.weatherData = (description, location, icon, temp, pressure, String(humidity)) as (descr : String, location: String, icon : UIImage, temp : String, pressure : String, humidity : String)
            
            

        } else {
            print("Unable to load weather info")
        }
    }
    
    func failure() {
        // no internet connection
        hud.hide(animated: true)
        let networkController = UIAlertController(title: "Error", message: "Can't load weather data", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        networkController.addAction(ok)
        self.present(networkController, animated: true, completion: nil)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location!)

        self.activityIndicator()

        let curLocation = locations.last as! CLLocation

        if(curLocation.horizontalAccuracy > 0) {
            // stop location atualisation to save battery charge
            locManager.startUpdatingLocation()

            let coords = CLLocationCoordinate2DMake(curLocation.coordinate.latitude, curLocation.coordinate.longitude)
            self.openWeather.getWeatherFor(location: coords)
            print(coords)
        }

    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showForecastTable" {
            hud.hide(animated: true)
            let forecastController = segue.destination as! ForecastTableViewController
            if self.cityName != nil {
                forecastController.cityName = self.cityName
            } else {
                let networkController = UIAlertController(title: "Error", message: "You should enter city name", preferredStyle: UIAlertController.Style.alert)
                let okAction        = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    (action) -> Void in
                    
                    let  cityField      = networkController.textFields![0]
                    //            let countryField = alertController.textFields![1]
                    
                    if cityField == networkController.textFields?.first as UITextField? /*&& countryField == alertController.textFields?.first as UITextField? */ {
                        self.activityIndicator()
                        self.cityName = cityField.text
                        self.openWeather.getWeatherFor(city: cityField.text!)
                    }
                }
                
                networkController.addAction(okAction)
                
                networkController.addTextField { (cityField) -> Void in
                    cityField.placeholder = "City name"
                }
                
                self.present(networkController, animated: true, completion: nil)
            }
        }
    }
}
