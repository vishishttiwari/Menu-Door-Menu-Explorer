//
//  OptionsImageCell.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/24/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class is used to descrive the cell of the options view

import Foundation
import UIKit

internal class OptionsImageCell: UICollectionViewCell {
    
    // UI elements are declared
    internal let background = UIView()
    internal let icon = UIImageView()
    internal let title = UILabel()
    
    // Dimension variables are declared
    private var iconDimensions: CGFloat!
    private var titleHeight: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        iconDimensions = self.frame.width/2.5
        titleHeight = self.frame.width/2.5
        
        setupViews()
        
        background.addSubview(icon)
        background.addSubview(title)
        self.addSubview(background)
        
        setupInitialLayout()
    }
    
    // Sets the views UI
    private func setupViews() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        
        background.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        background.layer.cornerRadius = Catalog.cornerRadius
        background.clipsToBounds = true
        
        icon.backgroundColor = .clear
        icon.contentMode = .scaleAspectFill
        
        title.backgroundColor = .clear
        title.font = UIFont.systemFont(ofSize: Catalog.FontSize.normalButtonFontSize, weight: UIFont.Weight.light)
        title.textAlignment = .center
        title.textColor = .white
    }
    
    // Sets the contratints
    private func setupInitialLayout() {
        background.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        background.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self)).isActive = true
        background.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        background.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        background.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self)).isActive = true
        
        icon.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        icon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: iconDimensions).isActive = true
        icon.heightAnchor.constraint(equalToConstant: iconDimensions).isActive = true
        
        title.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        title.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        title.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self), constant: -Catalog.Layout.betweenElementsDistance).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
