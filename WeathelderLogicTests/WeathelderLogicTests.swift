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
    
    func testWeatherForCity() {
        owm.getWeatherFor(city: "Kharkiv")
        XCTAssertEqual(owm.weatherData!.location, "Kharkiv, UA", "should be equal")
    }
    
    func testForecastForCity() {
        owm.getForecastFor(city: "Kharkiv")
        XCTAssertEqual(owm.forecastData[0].location, "Kharkiv, UA", "should be equal")
    }
}


