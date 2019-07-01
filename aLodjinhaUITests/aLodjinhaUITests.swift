//
//  aLodjinhaUITests.swift
//  aLodjinhaUITests
//
//  Created by Ricardo Barros on 25/06/2019.
//  Copyright © 2019 Ricardo Barros. All rights reserved.
//

import XCTest

class aLodjinhaUITests: XCTestCase {

    private var appInTest: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        appInTest = XCUIApplication()
        appInTest.launch()
        XCUIApplication().launch()
    }
    func testAppShowHomeScreen() {
        let tab = XCUIApplication().tabBars
        XCTAssertTrue(tab.buttons["Home"].isSelected)
        XCTAssertFalse(tab.buttons["Sobre"].isSelected)
    }
    
    func testAppShowAboutScreen() {
        let tab = XCUIApplication().tabBars
        tab.buttons["Sobre"].tap()
        
        XCTAssert(appInTest.navigationBars["Sobre"].exists)
        XCTAssertTrue(appInTest.staticTexts[" Ricardo Silva de Barros"].exists)
        XCTAssertTrue(appInTest.staticTexts["01 de Julho de 2019"].exists)
    }
    
    func testAppHomeBannerReallyRotateToRight() {
        
        let banner = appInTest.images["rotateBanner"]
        let screenshotBefore = banner.screenshot()
        
        let button = appInTest.otherElements.containing(.navigationBar, identifier:"aLodjinha.UITabBarView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element

        button.swipeRight()
        
        let screenshotAfter = banner.screenshot()
        
        XCTAssertNotEqual(screenshotBefore.image, screenshotAfter.image)
    }
    
    func testAppHomeTapCategoriesShowProductList() {
        
        let element = XCUIApplication().scrollViews.children(matching: .other).element
        element.swipeLeft()
        element.children(matching: .other).element(boundBy: 5).children(matching: .button).element.tap()
    }
}
