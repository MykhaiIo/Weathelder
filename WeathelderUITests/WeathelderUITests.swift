//
//  WeathelderUITests.swift
//  WeathelderUITests
//
//  Created by Michel on 22/05/2019.
//  Copyright © 2019 PDL. All rights reserved.
//

import XCTest
import SwiftyJSON
@testable import Weathelder

class WeathelderUITests: XCTestCase {
    
    var app : XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testLabelExists() {
        
        
        let label = app.staticTexts["Description"]
        
        if (label.waitForExistence(timeout: 2)) {
            XCTAssertEqual(label.exists, true, "should be shown")
        } else { XCTFail() }
    }
    
    func testNavigationWithUndefinedLocation() {
        let forecast = app.navigationBars.buttons["Forecast"]
        
        if (forecast.waitForExistence(timeout: 2)) {
            forecast.tap()
        } else { XCTFail() }
        
        app.alerts.textFields.element.typeText("Kharkiv")
        app.alerts.buttons["OK"].tap()
        
        if (forecast.waitForExistence(timeout: 2)) {
            forecast.tap()
        } else { XCTFail() }
        
        let cell = app.tables.element(boundBy: 0).cells.element(boundBy: 0)
        
        if cell.waitForExistence(timeout: 2) {

            let datetime    = cell.staticTexts["2019-05-23 18:00:00"]
            let description = cell.staticTexts["scattered clouds"]
            let imaegView   = cell.images.element(boundBy: 0)

            XCTAssertEqual(datetime.exists, true, "should be shown")
            XCTAssertEqual(description.exists, true, "should be shown")
            XCTAssertEqual(imaegView.exists, true, "should be shown")
        } else {
            XCTFail()
        }
    }
    
    func testNavigationWithSpecifiedLocation() {
        let location = app.buttons["City, Country"]
        
        if (location.waitForExistence(timeout: 2)) {
            location.tap()
        } else { XCTFail() }
        
        app.alerts.textFields.element.typeText("Kharkiv")
        app.alerts.buttons["OK"].tap()
        
        let forecast = app.navigationBars.buttons["Forecast"]
        
        if (forecast.waitForExistence(timeout: 2)) {
            forecast.tap()
        } else { XCTFail() }
        
        let cell = app.tables.element(boundBy: 0).cells.element(boundBy: 0)
        
        if cell.waitForExistence(timeout: 2) {
            
            let datetime    = cell.staticTexts["2019-05-23 18:00:00"]
            let description = cell.staticTexts["scattered clouds"]
            let imaegView   = cell.images.element(boundBy: 0)
            
            XCTAssertEqual(datetime.exists, true, "should be shown")
            XCTAssertEqual(description.exists, true, "should be shown")
            XCTAssertEqual(imaegView.exists, true, "should be shown")
        } else {
            XCTFail()
        }
    }
    
    func testNavigationWithFictiveLocation() {
        let location = app.buttons["City, Country"]
        
        if (location.waitForExistence(timeout: 2)) {
            location.tap()
        } else { XCTFail() }
        
        app.alerts.textFields.element.typeText("jkbf ytfytuyddfdst")
        app.alerts.buttons["OK"].tap()
        
        let forecast = app.navigationBars.buttons["Forecast"]
        
        if (forecast.waitForExistence(timeout: 2)) {
            forecast.tap()
        } else { XCTFail() }
        
        let back = app.navigationBars.buttons["Back"]
        
        if (back.waitForExistence(timeout: 2)) {
            back.tap()
        } else { XCTFail() }
        
        let label = app.staticTexts["Temp"]
        
        if (label.waitForExistence(timeout: 2)) {
            XCTAssertEqual(label.exists, true, "should be shown")
        } else { XCTFail() }
    }
}
