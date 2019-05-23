//
//  ForecastTableTableViewController.swift
//  Weathelder
//
//  Created by Michel on 05/05/2019.
//  Copyright © 2019 PDL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MBProgressHUD

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lDateTime: UILabel!
    @IBOutlet weak var lDescription: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lTempMax: UILabel!
    @IBOutlet weak var lTempMin: UILabel!
}

class ForecastTableViewController: UITableViewController, OpenWeatherMapDelegate, CLLocationManagerDelegate {
    
    let openWeather = OpenWeatherMap()
    let locManager  = CLLocationManager()
    let hud         = MBProgressHUD()
    
    var cityName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        DispatchQueue.main.async {
//            self.tableView.delegate = self
//            self.tableView.dataSource = self
//        }
        
        self.openWeather.delegate  = self
        locManager.delegate        = self
        self.activityIndicator()

        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
        
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //self.openWeather.getForecastFor(city: self.openWeather.cityName!)
        
        openWeather.getForecastFor(city: self.cityName)
    }
    
    func activityIndicator() {
        hud.label.text = "Loading..."
        hud.dimBackground = true
        self.view.addSubview(hud)
        hud.show(animated: true)
    }
    
    
   
    func updateWeatherInfo(weatherJson: JSON) {

        hud.hide(animated: true)
        for index in 0...35 {
            if weatherJson["list"][index]["main"]["temp"].float != nil {
                let country              = weatherJson["city"]["country"].stringValue

                let city                 = weatherJson["city"]["name"].stringValue
                
                let location = "\(city), \(country)"
                // get convenient temperature
                let minTemp              = weatherJson["list"][index]["main"]["temp_min"].floatValue

                let minTempConverted     = openWeather.convertTemperature(country: country, temp: minTemp)

                let maxTemp              = weatherJson["list"][index]["main"]["temp_max"].floatValue

                let maxTempConverted     = openWeather.convertTemperature(country: country, temp: maxTemp)

                // get forecast time
                let forecastTime         = weatherJson["list"][index]["dt_txt"].stringValue
                print(forecastTime)

                let description          = weatherJson["list"][index]["weather"][0]["description"].stringValue

                let cond                 = weatherJson["list"][index]["weather"][0]["id"].intValue

                let strIcon              = weatherJson["list"][index]["weather"][0]["icon"].stringValue

                let dayTime              = openWeather.isDayTime(icon: strIcon)

                let icon                 = openWeather.getWeatherIcon(cond: cond, dayTime: dayTime, index: index)

                openWeather.forecastData += [(forecastTime, description, location, icon, maxTempConverted, minTempConverted)] as [(datetime: String, descr: String, location: String, icon: UIImage, maxTemp: String, minTemp: String)]
                tableView.reloadData()
            }
        }
    }
    
    func failure() {
        let networkController = UIAlertController(title: "Error", message: "Can't load weather data", preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        networkController.addAction(ok)
        self.present(networkController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return openWeather.forecastData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell               = tableView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier", for: indexPath) as! ForecastTableViewCell
        let forecastCell       = openWeather.forecastData[indexPath.row]

        cell.lDescription.text = forecastCell.descr
        cell.lTempMax.text     = forecastCell.maxTemp
        cell.lTempMin.text     = forecastCell.minTemp
        cell.lDateTime.text    = forecastCell.datetime
        cell.icon.image        = forecastCell.icon

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - CLLocation
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(manager.location!)
        
        self.activityIndicator()
        
        let curLocation = locations.last as! CLLocation
        
        if(curLocation.horizontalAccuracy > 0) {
            // stop location atualisation to save battery charge
            locManager.startUpdatingLocation()
            
            let coords = CLLocationCoordinate2DMake(curLocation.coordinate.latitude, curLocation.coordinate.longitude)
            openWeather.getForecastFor(location: coords)
            print(coords)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("Can't get your location")
    }
    
}
