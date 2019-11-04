//
//  IngredientsCell.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/28/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This sets the ingredient cell in the table view that shows ingredients

import Foundation
import UIKit

internal class IngredientsCell: UITableViewCell {
    internal let ingredient: UILabel! = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        
        setupInitialLayout()
    }
    
    // Sets the views of the ui
    private func setupViews() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = false
        
        ingredient.backgroundColor = .clear
        ingredient.numberOfLines = 1
        ingredient.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize + 5, weight: UIFont.Weight.light)
        ingredient.textAlignment = .left
        ingredient.textColor = .white
        self.addSubview(ingredient)
    }
    
    // Sets the constraints
    private func setupInitialLayout() {
        ingredient.translatesAutoresizingMaskIntoConstraints = false
        
        ingredient.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self)).isActive = true
        ingredient.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        ingredient.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        ingredient.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self)).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
