//
//  RecommendationCell.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 6/6/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This cell sets the recommendation table cells

import Foundation
import UIKit

internal class RecommendationCell: UITableViewCell {
    internal let recommendation: UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        setupInitialLayout()
    }
    
    // Set the display of all the elements
    private func setupViews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        recommendation.backgroundColor = .clear
        recommendation.numberOfLines = 1
        recommendation.font = UIFont.systemFont(ofSize: Catalog.FontSize.normalButtonFontSize, weight: UIFont.Weight.light)
        recommendation.textAlignment = .left
        recommendation.textColor = .white
        self.addSubview(recommendation)
    }
    
    // Sets the contraints
    private func setupInitialLayout() {
        recommendation.translatesAutoresizingMaskIntoConstraints = false
        
        recommendation.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self)).isActive = true
        recommendation.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.betweenElementsDistance).isActive = true
        recommendation.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.betweenElementsDistance).isActive = true
        recommendation.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
