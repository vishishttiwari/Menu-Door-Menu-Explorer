//
//  DisclaimerView.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/24/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class sets the disclaimer view

import Foundation
import UIKit

internal class DisclaimerView: UIView {
    private let background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    private let tableView: UITableView! = UITableView()
    private let reportLabel: UILabel! = UILabel()
    private let backButton: BackButton = BackButton()
    
    private let y: [State: CGFloat]! = [State.HiddenState: Catalog.screenSize.height, State.ShownState: 0]
    
    private let disclaimers: [String] = ["The nutrition content may vary.", "The common ingredients may vary depending on restaurants.", "The images shown are derived from google and are indicative of dishes. Actual dishes may vary.", "The dish summary is derived from wikipedia and may not produce accurate results."]
    private let cellId = "cellId"
    
    private let tableViewHeight: CGFloat! = 3*Catalog.screenSize.height/8
    private let tableRowHeight: CGFloat! = 70
    private let reportLabelHeight: CGFloat! = 2*Catalog.screenSize.height/8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        tableView.register(DisclaimerCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
        setupInitialLayout()
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    // The UI element are set in this function
    private func setupViews() {
        background.setupViews(view: self, isPopUp: false, addBlur: true, addDark: false)
        
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
        tableView.rowHeight = tableRowHeight
        self.addSubview(tableView)
        
        reportLabel.text = "If you have a problem with any of the information displayed in this app then please provide us feedback through the 'Feedback' option. Thank you for your cooperation :)"
        reportLabel.backgroundColor = .clear
        reportLabel.numberOfLines = 0
        reportLabel.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        reportLabel.textAlignment = .center
        reportLabel.textColor = .white
        self.addSubview(reportLabel)
        
        backButton.setupViews(view: self, titleColor: .black)
        self.addSubview(backButton)
    }
    
    // This function sets the constraints
    private func setupInitialLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        reportLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = 0
        self.frame.origin.y = y[State.HiddenState]!
        self.frame.size.width = self.frame.width
        self.frame.size.height = self.frame.height
        
        tableView.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        tableView.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        tableView.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: tableViewHeight).isActive = true
        
        reportLabel.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        reportLabel.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        reportLabel.heightAnchor.constraint(equalToConstant: reportLabelHeight).isActive = true
        reportLabel.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -Catalog.Layout.betweenElementsDistance).isActive = true
        
        backButton.setupLayout(view: self)
    }
    
    // This function is called whenever the view has to be presented
    internal func present() {
        background.resetViews(isPopUp: false)
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[State.ShownState]!
            })
        }
    }
    
    // This function is called whenever the view has to be dismissed
    private func dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[State.HiddenState]!
            })
        }
    }
    
    // This function is called whenever the back button is pressed
    @objc func back() {
        backButton.clicked()
        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// The following is used to describe the table view in view
extension DisclaimerView: UITableViewDataSource, UITableViewDelegate {
    
    // This sets the total number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return disclaimers.count
    }
    
    // This sets each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DisclaimerCell
        
        cell.disclaimer.text = disclaimers[indexPath.row]
        
        return cell
    }
}
