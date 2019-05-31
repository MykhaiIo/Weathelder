//
//  WeathelderLogicTests.swift
//  WeathelderLogicTests
//
//  Created by Michel on 22/05/2019.
//  Copyright © 2019 PDL. All rights reserved.
//

import XCTest


@testable import SwiftyJSON
@testable import Weathelder

class WeathelderLogicTests: XCTestCase {

    private let owm = OpenWeatherMap()
//    private let ftvc = ForecastTableViewController()
//    private let wvc = WeatherViewController()
    
    func testConvertTemperature() {
        var temperature = owm.convertTemperature(country: "US", temp: 300)
        XCTAssertEqual(temperature, "61 °F", "should be equal")
        temperature = owm.convertTemperature(country: "UA", temp: 280)
        XCTAssertEqual(temperature, "7 °C", "should be equal")
    }
    
    func testIsDayTime() {
        var isDayTime = owm.isDayTime(icon: "04n")
        XCTAssertEqual(isDayTime, false, "should be equal")
        isDayTime = owm.isDayTime(icon: "50d")
        XCTAssertEqual(isDayTime, true, "should be equal")
    }
}


