//
//  OnboardingViewController.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 6/4/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Class is used to set up the view controller for onboardings

import Foundation
import UIKit
import paper_onboarding

internal class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    // Declare the UI elements
    private let onboardingView: OnboardingView! = OnboardingView()
    private let skipButton: UIButton! = UIButton()
    private var skipText: String! = "SKIP"
    private let startButton: UIButton! = UIButton()
    private var startText: String! = "GET STARTED"
    internal var startOnboarding: Bool! = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if startOnboarding {
            AnalyticsWrapper.Onboarding.sendAnalyticsWhichMethodForOnboarding(method: AnalyticsWrapper.Onboarding.StartOnboardingMethod.Start)
            
            startText = "GET STARTED"
            skipText = "SKIP"
        }
        else {
            AnalyticsWrapper.Onboarding.sendAnalyticsWhichMethodForOnboarding(method: AnalyticsWrapper.Onboarding.StartOnboardingMethod.Options)
            
            startText = "BACK"
            skipText = "BACK"
        }
        
        setupOnboardingView()
        
        onboardingView.delegate = self
        onboardingView.dataSource = self
        
        setupButtons()
        Catalog.askCameraPermission(viewController: self)
    }
    
    // Hides the status bar on top that shows time and all
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Sets up the view of onboarding views
    private func setupOnboardingView() {
        self.view.addSubview(onboardingView)
        
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        
        onboardingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        onboardingView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        onboardingView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        onboardingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    // Sets the buttons like skip and start
    private func setupButtons() {
        self.view.addSubview(startButton)
        startButton.setTitle(startText, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 30)
        startButton.setTitleColor(Catalog.themeColor, for: .normal)
        startButton.backgroundColor = UIColor.white
        startButton.layer.cornerRadius = Catalog.cornerRadius
        startButton.alpha = 0
        startButton.isEnabled = true
        startButton.isUserInteractionEnabled = true
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: Catalog.Contraints.getCenterXAnchor(view: self.view)).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        startButton.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self.view), constant: -100).isActive = true
        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)
        
        self.view.addSubview(skipButton)
        skipButton.setTitle(skipText, for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.alpha = 1
        skipButton.isEnabled = true
        skipButton.isUserInteractionEnabled = true
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self.view), constant: -5).isActive = true
        skipButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        skipButton.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self.view), constant: 5).isActive = true
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)
    }
    
    // Total count of onboarding views
    func onboardingItemsCount() -> Int {
        return 5
    }
    
    // Onboarding item of every screen. Used as multiple arrays
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundImageOne = UIImage.init(named: "onboarding1")
        let backgroundImageTwo = UIImage.init(named: "onboarding2")
        let backgroundImageThree = UIImage.init(named: "onboarding3")
        let backgroundImageFour = UIImage.init(named: "onboarding4")
        let backgroundImageFive = UIImage.init(named: "applicationName")
        let backgroundImage = [backgroundImageOne, backgroundImageTwo, backgroundImageThree, backgroundImageFour, backgroundImageFive]
        
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        let backgroundColorLast = Catalog.themeColor
        let backgroundColor = [backgroundColorOne, backgroundColorTwo, backgroundColorThree, backgroundColorTwo, backgroundColorLast]
        let white = UIColor.white
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)
        let title = ["Point camera to read the menu", "Learn more about each dish", "Discover the ingredients", "Find out more about each ingredient", ""]
        let description = ["Point the camera at the menu to read it. The camera will highlight the dishes. Tap the dishes to know more.", "Learn about the nutritional content, ingredients and how each dish looks.", "Get to know the common ingredients for each dish.", "Learn more about each ingredient including nutritional value.", ""]
        
        return OnboardingItemInfo.init(informationImage: backgroundImage[index]!, title: title[index], description: description[index], pageIcon: UIImage.init(named: "circle")!, color: backgroundColor[index]!, titleColor: white, descriptionColor: white, titleFont: titleFont, descriptionFont: descriptionFont!)
    }
    
    // Configuring the image heights in each views of onboarding
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index _: Int) {
        if Catalog.screenSize.height < 500 {
            item.informationImageWidthConstraint?.constant = view.frame.width
            item.informationImageHeightConstraint?.constant = view.frame.height/3
        } else {
            item.informationImageWidthConstraint?.constant = view.frame.width
            item.informationImageHeightConstraint?.constant = view.frame.height/2
        }
        
        item.setNeedsUpdateConstraints()
    }

    // WHat happens on every page of the onbaording.
    // Last page shows the get started button
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 0 {
            Catalog.askCameraPermission(viewController: self)
        }
        else if index == 4 {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.startButton.alpha = 1
                self.skipButton.alpha = 0
            })
        }
    }

    func onboardingWillTransitonToIndex(_ index: Int) {
        if index != 4 {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                if self.startButton.alpha == 1 {
                    self.startButton.alpha = 0
                    self.skipButton.alpha = 1
                }
            })
        }
    }
    
    // If start button is pressed
    @objc func start() {
        if startButton.backgroundColor == .white {
            startButton.backgroundColor = .black
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.startButton.backgroundColor = UIColor.white
            })
        }
        if startOnboarding {
            AnalyticsWrapper.Onboarding.sendAnalyticsGetStartedButtonClicked(method: AnalyticsWrapper.Onboarding.StartOnboardingMethod.Start)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "onboardingComplete")
            userDefaults.synchronize()
            
            let controller = MainViewController()
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
        }
        else {
            AnalyticsWrapper.Onboarding.sendAnalyticsGetStartedButtonClicked(method: AnalyticsWrapper.Onboarding.StartOnboardingMethod.Options)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // If skip button is pressed then skip from any screen
    @objc func skip() {
        if startOnboarding {
            AnalyticsWrapper.Onboarding.sendAnalyticsSkipButtonClicked(method: AnalyticsWrapper.Onboarding.StartOnboardingMethod.Start)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "onboardingComplete")
            userDefaults.synchronize()
            
            let controller = MainViewController()
            controller.modalTransitionStyle = .coverVertical
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            DispatchQueue.main.async {
                self.present(controller, animated: true, completion: nil)
            }
        }
        else {
            AnalyticsWrapper.Onboarding.sendAnalyticsSkipButtonClicked(method: AnalyticsWrapper.Onboarding.StartOnboardingMethod.Options)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
