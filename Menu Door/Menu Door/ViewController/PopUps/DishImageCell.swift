//
//  DishImageCell.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/23/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Class used for setting up the horizontal scrolling images

import Foundation
import UIKit

internal class DishImageCell: UICollectionViewCell {
    internal let image = UIImageView()
    internal let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        setupInitialLayout()
    }
    
    // Set the display of all the elements
    private func setupViews() {
        self.backgroundColor = UIColor.white.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        self.layer.cornerRadius = Catalog.cornerRadius
        self.isUserInteractionEnabled = false
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        
        image.backgroundColor = .clear
        image.layer.cornerRadius = Catalog.cornerRadius
        image.clipsToBounds = true
        image.contentMode = .scaleToFill
        self.addSubview(image)
    }
    
    // Sets the contraints
    private func setupInitialLayout() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self)).isActive = true
        activityIndicator.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        activityIndicator.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self)).isActive = true
        
        image.frame.origin.x = 0
        image.frame.origin.y = 0
        image.frame.size.width = self.frame.width
        image.frame.size.height = self.frame.height
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
