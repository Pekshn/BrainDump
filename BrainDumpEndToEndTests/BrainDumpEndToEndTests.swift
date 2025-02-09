//
//  BrainDumpEndToEndTests.swift
//  BrainDumpEndToEndTests
//
//  Created by Petar  on 8.2.25..
//

import XCTest

final class WhenAppIsLaunched: XCTestCase {
    
    //MARK: - Testing methods
    override class func setUp() {
        super.setUp()
        Springboard.deleteApp()
    }
    
    func testShouldNotDisplayAnyTasks() {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        let tasksList = app.collectionViews["brainTaskList"]
        XCTAssertEqual(0, tasksList.cells.count)
    }
    
    override func tearDown() {
        Springboard.deleteApp()
        super.tearDown()
    }
}

final class WhenUserSavesNewTask: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        Springboard.deleteApp()
    }
    
    func testShouldBeAbleToDisplayTaskSuccessfully() {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        let titleField = app.textFields["titleField"]
        titleField.tap()
        titleField.typeText("First Task")
        
        let submitButton = app.buttons["submitButton"]
        submitButton.tap()
        
        let brainTaskList = app.collectionViews["brainTaskList"]
        XCTAssertEqual(1, brainTaskList.cells.count)
    }
    
    func testShouldDisplayErrorMessageForDuplicateTitleTasks() {
        let app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        let titleField = app.textFields["titleField"]
        titleField.tap()
        titleField.typeText("Custom Task")
        
        let submitButton = app.buttons["submitButton"]
        submitButton.tap()
        
        titleField.tap()
        titleField.typeText("Custom Task")
        
        submitButton.tap()
        
        let brainTaskList = app.collectionViews["brainTaskList"]
        XCTAssertEqual(1, brainTaskList.cells.count)
        
        let messageText = app.staticTexts["messageText"]
        XCTAssertEqual(messageText.label, "Brain Task already exists")
    }
    
    override func tearDown() {
        Springboard.deleteApp()
        super.tearDown()
    }
}

class WhenUserDeletesNewTask: XCTestCase {
    
    private var app: XCUIApplication!
    
    override class func setUp() {
        super.setUp()
        Springboard.deleteApp()
    }
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        let titleField = app.textFields["titleField"]
        titleField.tap()
        titleField.typeText("Task To Delete")
        let submitButton = app.buttons["submitButton"]
        submitButton.tap()
    }
    
    func test_shoulDeleteTaskSuccessfully() {
        let cell = app.collectionViews["brainTaskList"].cells.firstMatch
        XCTAssertTrue(cell.staticTexts["Task To Delete"].exists)
        cell.swipeLeft()
        app.collectionViews["brainTaskList"].buttons["Delete"].tap()
        XCTAssertFalse(cell.exists)
    }
    
    override func tearDown() {
        Springboard.deleteApp()
        super.tearDown()
    }
}

class WhenUserMarksTaskAsFavorite: XCTestCase {
    
    private var app: XCUIApplication!
    
    override class func setUp() {
        super.setUp()
        Springboard.deleteApp()
    }
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
        
        let titleField = app.textFields["titleField"]
        titleField.tap()
        titleField.typeText("Task To Update")
        let submitButton = app.buttons["submitButton"]
        submitButton.tap()
    }
    
    func test_shoulDisplayUpdatedTaskOnScreenAsFavorite() {
        let cell = app.collectionViews["brainTaskList"].cells.firstMatch
        XCTAssertTrue(cell.staticTexts["Task To Update"].exists)
        cell.tap()
        app.images["favoriteImg"].tap()
        app.buttons["dismissButton"].tap()
        XCTAssertTrue(cell.images["heart.fill"].exists)
    }
    
    override func tearDown() {
        Springboard.deleteApp()
        super.tearDown()
    }
}
