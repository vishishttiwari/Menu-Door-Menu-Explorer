//
//  WordFound.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/14/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Thie class is used to descrive WordFound which is used to set rectangles in camera

import Foundation
import UIKit

internal struct WordFound {
    var text: String!
    var rectangle: CGRect!
    var rectangleImage: UIImageView!
    
    init(text: String, rectangle: CGRect, rectangleImage: UIImageView) {
        self.rectangle = rectangle
        self.text = text
        self.rectangleImage = rectangleImage
    }
}
