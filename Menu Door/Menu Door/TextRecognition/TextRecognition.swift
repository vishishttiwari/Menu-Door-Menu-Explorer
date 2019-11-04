//
//  TextRecognition.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/5/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class is used to read text, see if any text is dish and if it is then retirn with rectangle of that word

import Foundation
import Firebase

internal class TextRecognition {
    
    // Optional Closures
    internal var textRecognized: ((_ texts: [String], _ rects: [CGRect]) -> ())?
    
    // initialize text recognizer from ML Kit
    private var textRecognizer: VisionTextRecognizer!
    private var yCenter: CGFloat
    private var yThreshold: CGFloat
    
    init() {
        yCenter = 0
        yThreshold = 30
        
        // instantiate text recognizer as on device text recognizer
        let vision = Vision.vision()
        textRecognizer = vision.onDeviceTextRecognizer()
    }
    
    // This runs text recognition on the image provided by converting
    // it into a VisionImage
    internal func runTextRecognition(with image: UIImage) {
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        yCenter = image.size.height/2
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { (features, error) in
            let (chosenString, rect) = self.processResult(from: features, error: error)
            self.textRecognized?(chosenString, rect)
        }
    }
    
    // This examines the VisionText object. VisionText has two parts,
    // a string of all text found in the image and array of VisionTextBlocks.
    // A VisionTextBlock is a text block recognized in an image. It also
    // contains, string of the text, frame, rectangel points, language
    // and confidence in the text.
    private func processResult(from text: VisionText?, error: Error?) -> ([String], [CGRect]) {
        guard let features = text else { return ([], []) }
        return selectDishes(features: features)
    }
    
    // After it is seen that a dish is a dish, the rectangle is returned
    private func selectDishes(features: VisionText) -> ([String], [CGRect]) {
        var wordsFound: [String] = []
        var rectangles: [CGRect] = []

        for lines in features.blocks {
            for line in lines.lines {
                let newLine = processWords(line.text)
                if (TextRecognition.isDish(words: newLine)) {
                    wordsFound.append(newLine.capitalizeEveryWord())
                    rectangles.append(line.frame)
                }
            }
        }
        
        return (wordsFound, rectangles)
    }
    
    // This function is used to check if a text is dish or not
    static func isDish(words: String) -> Bool {
        let words1 = words.lowercased()
        let arrayOfWords = words1.split(separator: " ")
        var totalDishWords = 0
        for word in arrayOfWords {
            if (DatasetWords.words.contains(String(word))) {
                totalDishWords += 1
            }
        }
        if (totalDishWords >= 1) {
            return true
        }
        return false
    }
    
    // This processes the string to remove brackets, quotes, hyphens etc.
    private func processWords(_ string: String) -> String {
        var newString = string.lowercased()
        newString = newString.replacingOccurrences(of: "\\((.*?)\\)", with: " ", options: .regularExpression) // brackets
        newString = newString.replacingOccurrences(of: "\"(.*?)\"", with: " ", options: .regularExpression)   // quotations
        newString = newString.replacingOccurrences(of: "\\{(.*?)\\}", with: " ", options: .regularExpression) // curly braces
        newString = newString.replacingOccurrences(of: "\\[(.*?)\\]", with: " ", options: .regularExpression) // square braces
        newString = newString.replacingOccurrences(of: "/", with: " ", options: .regularExpression)           // slash
        newString = newString.replacingOccurrences(of: "[!@#$%^&*_+=<,>.?:;]", with: " ", options: .regularExpression)  // special characters
        newString = newString.components(separatedBy: CharacterSet.decimalDigits).joined() // numbers
        
        return newString
    }
}
