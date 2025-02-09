//
//  Springboard.swift
//  BrainDump
//
//  Created by Petar  on 8.2.25..
//

import Foundation
import XCTest

class Springboard {
    
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    class func deleteApp() {
        XCUIApplication().terminate()
        springboard.activate()
        if springboard.icons.matching(identifier: "BrainDump").firstMatch.exists {
            let appIcon = springboard.icons.matching(identifier: "BrainDump").firstMatch
            appIcon.press(forDuration: 1.3)
            let _ = springboard.alerts.buttons["Remove App"].waitForExistence(timeout: 1)
            springboard.buttons["Remove App"].tap()
            
            let deleteAppButton = springboard.alerts.buttons["Delete App"].firstMatch
            if deleteAppButton.waitForExistence(timeout: 2) {
                deleteAppButton.tap()
                let secondDeleteButton = springboard.alerts.buttons["Delete"].firstMatch
                if secondDeleteButton.waitForExistence(timeout: 2) {
                    secondDeleteButton.tap()
                }
            }
        }
    }
}
