//
//  DisclaimerCell.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/24/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Describes each cell on the table view

import Foundation
import UIKit

internal class DisclaimerCell: UITableViewCell {
    internal let disclaimer: UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        setupInitialLayout()
    }
    
    // Sets the views
    private func setupViews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        disclaimer.backgroundColor = .clear
        disclaimer.numberOfLines = 0
        disclaimer.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        disclaimer.textAlignment = .left
        disclaimer.textColor = .white
        self.addSubview(disclaimer)
    }
    
    // Sets the constraints
    private func setupInitialLayout() {
        disclaimer.translatesAutoresizingMaskIntoConstraints = false
        
        disclaimer.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self)).isActive = true
        disclaimer.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        disclaimer.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        disclaimer.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
