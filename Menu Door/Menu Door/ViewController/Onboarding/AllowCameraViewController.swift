//
//  AllowCameraViewController.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 6/5/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Class used up for setting up the screen that will show up if camera permissions is not allowed

import AVFoundation
import UIKit

internal class AllowCameraViewController: UIViewController {
    
    // UI Elements declared
    private let noCamera: UIImageView! = UIImageView()
    private let titleLabel: UILabel! = UILabel()
    private let descriptionLabel: UILabel! = UILabel()
    private let settingsButton: UIButton! = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sends analytics whenever this page is called
        AnalyticsWrapper.CameraPemissions.sendAnalyticsAllowPermissionPage()
        
        setupViews()
        
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Set the display of all the elements
    private func setupViews() {
        self.view.backgroundColor = UIColor.white
        
        noCamera.image = UIImage.init(named: "noCamera")
        noCamera.contentMode = .scaleAspectFit
        self.view.addSubview(noCamera)
        
        titleLabel.text = "Camera is turned off"
        titleLabel.font = UIFont.systemFont(ofSize: Catalog.FontSize.titleFontSize, weight: UIFont.Weight.light)
        titleLabel.textColor = Catalog.themeColor
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        descriptionLabel.text = "Menu Door can't see the restaurant menus. To fix this, please allow Menu Door to access the camera"
        descriptionLabel.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        self.view.addSubview(descriptionLabel)
        
        settingsButton.setTitle("Go to Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.backButtonFontSize, weight: UIFont.Weight.light)
        settingsButton.backgroundColor = Catalog.themeColor
        settingsButton.setTitleColor(UIColor.white, for: .normal)
        settingsButton.layer.cornerRadius = Catalog.cornerRadius
        settingsButton.clipsToBounds = true
        settingsButton.addTarget(self, action: #selector(settings), for: .touchUpInside)
        self.view.addSubview(settingsButton)
    }
    
    // Sets the contraints
    private func setupLayout() {
        noCamera.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        
        noCamera.centerXAnchor.constraint(equalTo: Catalog.Contraints.getCenterXAnchor(view: self.view)).isActive = true
        noCamera.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self.view), constant: Catalog.Layout.screenDistance).isActive = true
        noCamera.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noCamera.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: noCamera.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self.view), constant: Catalog.Layout.screenDistance).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self.view), constant: -Catalog.Layout.screenDistance).isActive = true
        
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self.view), constant: Catalog.Layout.screenDistance).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self.view), constant: -Catalog.Layout.screenDistance).isActive = true
        
        settingsButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        settingsButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self.view), constant: Catalog.Layout.screenDistance).isActive = true
        settingsButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self.view), constant: -Catalog.Layout.screenDistance).isActive = true
    }
    
    // Button to go directly to the setting of this app
    @objc func settings() {
        AnalyticsWrapper.CameraPemissions.sendAnalyticsButtonClicked()
        
        settingsButton.backgroundColor = .white
        UIView.animate(withDuration: Catalog.animateTime, animations: {
            self.settingsButton.backgroundColor = UIColor.init(red: 197/255, green: 10/255, blue: 9/255, alpha: 1)
        })
        if let bundleId = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
