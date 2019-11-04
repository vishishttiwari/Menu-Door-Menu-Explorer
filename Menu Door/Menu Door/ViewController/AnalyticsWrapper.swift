//
//  AnalyticsWrapper.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 6/11/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Analytics wrapper for google analytics

import Foundation
import Firebase

internal class AnalyticsWrapper {
    
    // Analytics for in which screen the app opens
    struct AppOpen {
        static let key: String = "App_Open"
        enum Screen: String {
            case Main_Screen
            case Onboarding
        }
        
        static func sendAnalytics(screen: Screen) {
            Analytics.logEvent(AnalyticsEventAppOpen, parameters: [key: screen.rawValue])
        }
    }
    
    // Analytics for which button is pressed
    struct Button {
        static let name: String = "Button_Pressed"
        static let key: String = "Which_Button"
        static let key_Dish: String = "Dish"
        enum Buttons: String {
            case Search
            case Options
            case Flash
            case Speak
            case Ingredients
            case Google
        }
        
        static func sendAnalytics(button: Buttons, dish: String) {
            Analytics.logEvent(name, parameters: [key: button.rawValue, key_Dish: dish])
        }
    }
    
    // Analytics for which Dish is searched
    struct DishSearch {
        static let name: String = "Dish_Search"
        static let key: String = "Dish_Search"
        static let value_DishRecognized: String = "Dish_Recognized"
        
        static func sendAnalytics(dish: String, dishRecognized: Bool) {
            Analytics.logEvent(name, parameters: [key: dish, value_DishRecognized: dishRecognized])
        }
    }
    
    // Analytics for which Dish is tapped in menu
    struct DishTapped {
        static let name: String = "Dish_Tapped"
        static let key: String = "Dish_Tapped"
        
        static func sendAnalytics(dish: String) {
            Analytics.logEvent(name, parameters: [key: dish])
        }
    }
    
    // Analytics for whether camera permission is allowed
    struct CameraPemissions {
        static let nameViewController: String = "View_Controller_For_Camera_Perm"
        static let nameSettings: String = "Taken_To_Settings_For_Camera_Perm"
        
        static func sendAnalyticsAllowPermissionPage() {
            Analytics.logEvent(nameViewController, parameters: nil)
        }
        
        static func sendAnalyticsButtonClicked() {
            Analytics.logEvent(nameSettings, parameters: nil)
        }
    }
    
    // Analytics for whether onboarding is skipped or not
    struct Onboarding {
        static let nameMethod: String = "Onboarding_View_Controller_Method"
        static let nameGetStartedButton: String = "Onboarding_Get_Started_Button_Click"
        static let nameSkipButton: String = "Onboarding_Skip_Button_Click"
        static let keyMethod: String = "Method"
        
        enum StartOnboardingMethod: String {
            case Start
            case Options
        }
        
        static func sendAnalyticsWhichMethodForOnboarding(method: StartOnboardingMethod) {
            Analytics.logEvent(nameMethod, parameters: [keyMethod: method.rawValue])
        }
        
        static func sendAnalyticsGetStartedButtonClicked(method: StartOnboardingMethod) {
            Analytics.logEvent(nameGetStartedButton, parameters: [keyMethod: method.rawValue])
        }
        
        static func sendAnalyticsSkipButtonClicked(method: StartOnboardingMethod) {
            Analytics.logEvent(nameSkipButton, parameters: [keyMethod: method.rawValue])
        }
    }
    
    // Analytics for which Option is selected in Options View Controller
    struct Options {
        static let name: String = "Options_Button_Pressed"
        static let key: String = "Which_Button"
        
        enum Buttons: String {
            case Onboarding
            case Feedback
            case Disclaimer
            case Website
        }
        static func sendAnalytics(whichButton: Buttons) {
            Analytics.logEvent(name, parameters: [key: whichButton.rawValue])
        }
    }
    
    // Analytics for what user wants to report
    struct Report {
        static let name: String = "Report_Action"
        static let keyInfo: String = "Info"
        static let keyButtons: String = "Buttons"
        static let keyReportPressed: String = "Report_Pressed"
        static let keyCancelPressed: String = "Cancel_Pressed"

        static func sendAnalytics(info: String, whichButton: [ReportButtons], reportPressed: Bool, cancelPressed: Bool) {
            var buttons: String = ""
            for but in whichButton {
                buttons += but.rawValue + " "
            }
            Analytics.logEvent(name, parameters: [keyInfo: String(info.prefix(39)), keyButtons: buttons, keyReportPressed: reportPressed, keyCancelPressed: cancelPressed])
        }
    }
    
    // Analytics for which Speech is used. Apple or Google.
    struct Speech {
        static let name: String = "Speak_Used"
        static let keyMethod: String = "Method"
        static let keySuccess: String = "Successful"
        static let keyGoogleTried: String = "Google_Tried_First"
        
        enum Method: String {
            case Apple
            case Google
        }
        
        static func sendAnalytics(method: Method, success: Bool, googleTried: Bool) {
            Analytics.logEvent(name, parameters: [keyMethod: method.rawValue, keySuccess: success, keyGoogleTried: googleTried])
        }
    }
    
    // Analytics for alert view controller
    struct Alert {
        static let name: String = "Alert_View_Controller_Was_Raised"
        static let keyTitle: String = "Title"
        static let keyDescription: String = "Description"
        
        static func sendAnalytics(title: String, description: String) {
            Analytics.logEvent(name, parameters: [keyTitle: title, keyDescription: description])
        }
    }
    
    // Analytics for if user googles dishes that are not found
    struct DishNotFoundAlert {
        static let name: String = "Dish_Not_Found_Was_Raised"
        static let keyDish: String = "Dish"
        static let keyGoogle: String = "Google_Pressed"
        static let keyCancel: String = "Cancel_Pressed"
        
        static func sendAnalytics(dish: String, googlePressed: Bool, cancelPressed: Bool) {
            Analytics.logEvent(name, parameters: [keyDish: dish, keyGoogle: googlePressed, keyCancel: cancelPressed])
        }
    }
}
