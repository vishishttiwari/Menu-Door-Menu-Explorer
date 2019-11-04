//
//  OptionsViewController.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/24/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class is used to set the view of the options view

import Foundation
import UIKit

internal class OptionsView: UIView {
    
    // UI elements are declared
    private let background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    private var applicationLogo: UIImageView! = UIImageView()
    private var optionsCollectionView: UICollectionView!
    private let backButton: BackButton! = BackButton()
    
    // Constants of constraints are set
    private let x: [State: CGFloat]! = [State.HiddenState: -Catalog.screenSize.width, State.ShownState: 0]
    
    private let cellId = "cellId"
    private let cellWidth: CGFloat! = Catalog.screenSize.width/2.5
    private let cellHeight: CGFloat! = Catalog.screenSize.width/2.5
    private let options: [String] = ["How to use", "Feedback", "Disclaimer", "Website"]
    private let optionsImages: [String] = ["howTo.png", "feedback.png", "disclaimer.png", "website.png"]
    
    private let logoDimensions: CGFloat! = Catalog.screenSize.height/4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // This sets the horizaontal and vertical distance between the cells are same
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Catalog.screenSize.width - (2*cellWidth) - (2*Catalog.Layout.screenDistance)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight!)
        optionsCollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        
        // Sets the UI elemenst of the view
        setupViews()
        
        // Sets the collection view
        optionsCollectionView.register(OptionsImageCell.self, forCellWithReuseIdentifier: cellId)
        optionsCollectionView.dataSource = self
        optionsCollectionView.delegate = self
        
        // Sets the constraints
        setupInitialLayout()
        
        // Sets the function that is called when back button is pressed
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        // Sets the tap on the cells of options
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        optionsCollectionView.addGestureRecognizer(tap)
    }
    
    // Sets the UI of the view
    private func setupViews() {
        background.setupViews(view: self, isPopUp: false, addBlur: true, addDark: false)
        
        applicationLogo.image = UIImage.init(named: "applicationLogo")
        applicationLogo.contentMode = .scaleAspectFit
        applicationLogo.backgroundColor = .clear
        self.addSubview(applicationLogo)
        
        optionsCollectionView.backgroundColor = .clear
        optionsCollectionView.isScrollEnabled = true
        optionsCollectionView.bounces = false
        optionsCollectionView.showsHorizontalScrollIndicator = false
        optionsCollectionView.showsVerticalScrollIndicator = false
        optionsCollectionView.allowsSelection = true
        optionsCollectionView.isUserInteractionEnabled = true
        self.addSubview(optionsCollectionView)
        
        backButton.setupViews(view: self, titleColor: .white)
        self.addSubview(backButton)
    }
    
    // Sets the constraints of the view
    private func setupInitialLayout() {
        applicationLogo.translatesAutoresizingMaskIntoConstraints = false
        optionsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = x[State.HiddenState]!
        self.frame.origin.y = 0
        self.frame.size.width = self.frame.width
        self.frame.size.height = self.frame.height
        
        applicationLogo.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        applicationLogo.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        applicationLogo.widthAnchor.constraint(equalToConstant: logoDimensions).isActive = true
        applicationLogo.heightAnchor.constraint(equalToConstant: logoDimensions).isActive = true
        
        optionsCollectionView.topAnchor.constraint(equalTo: self.applicationLogo.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        optionsCollectionView.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        optionsCollectionView.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        optionsCollectionView.bottomAnchor.constraint(equalTo: self.backButton.topAnchor, constant: -Catalog.Layout.screenDistance).isActive = true
        
        backButton.setupLayout(view: self)
    }
    
    // This function is called whenever the view has to be presented
    internal func present() {
        DispatchQueue.main.async {
            self.background.resetViews(isPopUp: false)
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.x = self.x[State.ShownState]!
            })
        }
    }
    
    // This function is called whenever the view has to be hidden
    private func dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.x = self.x[State.HiddenState]!
            })
        }
    }
    
    // This function is called whenever the back button is pressed
    @objc func back() {
        backButton.clicked()
        dismiss()
    }
    
    // This function is called when any of the cells is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if let indexPath = optionsCollectionView.indexPathForItem(at: sender.location(in: optionsCollectionView)) {
            let cell = optionsCollectionView.cellForItem(at: indexPath) as! OptionsImageCell
            if sender.state == .ended {
                cell.background.backgroundColor = .white
                UIView.animate(withDuration: Catalog.animateTime, animations: {
                    cell.background.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
                })
                if (indexPath.row == 0) {
                    AnalyticsWrapper.Options.sendAnalytics(whichButton: AnalyticsWrapper.Options.Buttons.Onboarding)
                    
                    let controller = OnboardingViewController()
                    controller.startOnboarding = false
                    
                    controller.modalTransitionStyle = .coverVertical
                    controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                    
                    DispatchQueue.main.async {
                        Catalog.mainViewController!.present(controller, animated: true, completion: nil)
                    }
                }
                else if (indexPath.row == 1) {
                    AnalyticsWrapper.Options.sendAnalytics(whichButton: AnalyticsWrapper.Options.Buttons.Feedback)
                    
                    guard let mainViewController = Catalog.mainViewController else { return }
                    mainViewController.reportView.present()
                }
                else if (indexPath.row == 2) {
                    AnalyticsWrapper.Options.sendAnalytics(whichButton: AnalyticsWrapper.Options.Buttons.Disclaimer)
                    
                    guard let mainViewController = Catalog.mainViewController else { return }
                    mainViewController.disclaimerView.present()
                }
                else if (indexPath.row == 3) {
                    AnalyticsWrapper.Options.sendAnalytics(whichButton: AnalyticsWrapper.Options.Buttons.Website)
                    
                    guard let url = URL(string: "https://www.menudoor.org") else { return }
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// The following sets the options collection view
extension OptionsView: UICollectionViewDelegate, UICollectionViewDataSource {
    // Sets the total number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    // Sets each cell of the options collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OptionsImageCell
        
        cell.icon.image = UIImage.init(named: optionsImages[indexPath.row])
        cell.title.text = options[indexPath.row]
        
        return cell
    }
}
