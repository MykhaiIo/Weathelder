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
        
        if (label.waitForExistence(timeout: 4)) {
            XCTAssertEqual(label.exists, true, "should be shown")
        } else { XCTFail() }
    }
    
    func testNavigation() {
        let label = app.staticTexts["Description"]
        
        if (label.waitForExistence(timeout: 4)) {
            XCTAssertEqual(label.exists, true, "should be shown")
        } else { XCTFail() }
        
        let newScreen = app.tables.element(boundBy: 0)
        
        if (newScreen.waitForExistence(timeout: 4)) {
            
            let cell = app.tables.element(boundBy: 0).cells.element(boundBy: 0)
            
            let title = cell.staticTexts["DateTime"]
            let descr = cell.staticTexts["Description"]
            let imgView = cell.images.element(boundBy: 0)
            
            XCTAssertEqual(title.exists, true, "should be shown")
            XCTAssertEqual(descr.exists, true, "should be shown")
            XCTAssertEqual(imgView.exists, true, "should be shown")
            
        } else { XCTFail() }
    }

}
