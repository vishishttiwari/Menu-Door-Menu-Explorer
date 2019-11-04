//
//  TopPopUp.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/20/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Class used for setting up the popup view at the top

import Foundation
import UIKit

internal class TopPopUp: UIView, UITextFieldDelegate {
    // Optional Closures
    internal var stateChanged: ((_ state: PopUpsState) -> ())?
    
    // Elements in popUp
    private let background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: Catalog.hiddenThreshold, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    internal let dishName: UITextField! = UITextField()
    private let dishNutrition: UILabel! = UILabel()
    private let dishSummary: UILabel! = UILabel()
    private let dishSummaryScroll: UIScrollView! = UIScrollView()
    private let dishSpeak: SpecialButton = SpecialButton()
    private let dishIngredients: SpecialButton! = SpecialButton()
    private let dishGoogle: SpecialButton! = SpecialButton()
    
    // Height of elements in popUp
    internal let dishNameHeight: CGFloat! = 40
    private let dishNutritionHeight: CGFloat! = 70
    private var dishSummaryHeight: CGFloat! = 100
    private var dishSummaryScrollHeight: CGFloat! = 100
    private let spaceNeededForDishSpeakHeight: CGFloat! = 50
    private let dishButtonsWidth: CGFloat! = 62
    private let dishButtonsHeight: CGFloat! = 40
    internal var searchedArray: [String] = []
    
    // Initialize APIs
    private let fatSecretInfo: FatSecretInfo = FatSecretInfo.init()
    private let usdaInfo: USDANutrients = USDANutrients.init()
    private let wikiSearch: WikipediaSummary = WikipediaSummary.init()
    
    // Dimensions of upper pop up in three states
    private var y: CGFloat!
    private var heights: [PopUpsState: CGFloat]! = [PopUpsState.TextSearchState: 0, PopUpsState.TextRecognitionState: 0, PopUpsState.PopUpState: 0, PopUpsState.ImagesState: 0]
    
    // String if info was not found
    private let noNutrition: String! = "No nutrition info was found for this dish"
    private let noSummary: String! = "No summary was found for this dish"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up heights of the popup for different states like when searching or when displaying images
        y = -Catalog.hiddenThreshold
        heights[PopUpsState.TextSearchState] = dishNameHeight + Catalog.PopUps.screenDistanceFromTop + 10
        heights[PopUpsState.TextRecognitionState] = 0
        heights[PopUpsState.PopUpState] = dishNameHeight + dishNutritionHeight + spaceNeededForDishSpeakHeight
        heights[PopUpsState.PopUpState] = heights[PopUpsState.PopUpState]! + Catalog.PopUps.screenDistanceFromTop
        heights[PopUpsState.ImagesState] = dishNameHeight + dishNutritionHeight + dishSummaryHeight + spaceNeededForDishSpeakHeight
        heights[PopUpsState.ImagesState] = heights[PopUpsState.ImagesState]! + Catalog.PopUps.screenDistanceFromTop + 10
        Catalog.height_ImagesState_Top = heights[PopUpsState.ImagesState]! - Catalog.hiddenThreshold
        
        // Set the display of all the elements in the popup
        setupViews()
        
        // Set the constraints of all elements in popup
        setupInitialLayout()
        
        // Tap gesture to toggle between image state and popup state
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    // When dish is either searched or tapped, this function is called
    internal func dishTextRecognized(dish: String?) {
        guard let dish: String = dish else { return }
        if dish.count == 0 { return }
        
        DispatchQueue.main.async {
            self.dishName.text = dish
        }
        
        background.resetViews(isPopUp: true)
        implementNutritionSearch(dish: dish)
        implementWikiSummarySearch(dish: dish)
        popUpState()
    }
    
    // When the dish is searched bu textfield, this function is called
    internal func dishTextStartEditing() {
        dishName.text = ""
        dishName.isEnabled = true
        background.resetViews(isPopUp: true)
        textSearchState()
    }
    
    // Set the display of all the elements in the popup
    private func setupViews() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = Catalog.cornerRadius
        self.clipsToBounds = true
        
        background.setupViews(view: self, isPopUp: true, addBlur: false, addDark: false)
        self.addDarkInBackground(alpha: Catalog.Dark.popUpScreenTransparency)
        
        dishName.backgroundColor = .clear
        dishName.font = UIFont.systemFont(ofSize: Catalog.FontSize.titleFontSize + 5, weight: UIFont.Weight.light)
        dishName.textAlignment = .center
        dishName.textColor = .white
        dishName.autocorrectionType = .no
        dishName.keyboardAppearance = .dark
        dishName.contentVerticalAlignment = .top
        dishName.clearButtonMode = .whileEditing
        dishName.attributedPlaceholder = NSAttributedString(string: "Type any dish",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        dishName.addTarget(self, action: #selector(recommendations(_ :)), for: .editingChanged)
        dishName.delegate = self
        self.addSubview(dishName)
        
        dishNutrition.backgroundColor = .clear
        dishNutrition.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        dishNutrition.numberOfLines = 0
        dishNutrition.lineBreakMode = .byTruncatingTail
        dishNutrition.textAlignment = .center
        dishNutrition.textColor = .white
        dishNutrition.sizeToFit()
        self.addSubview(dishNutrition)
        
        dishSummaryScroll.backgroundColor = .clear
        dishSummaryScroll.isScrollEnabled = true
        dishSummaryScroll.showsVerticalScrollIndicator = false
        dishSummaryScroll.contentSize.height = dishSummaryScrollHeight
        self.addSubview(dishSummaryScroll)
        
        dishSummary.backgroundColor = .clear
        dishSummary.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        dishSummary.numberOfLines = 0
        dishSummary.lineBreakMode = .byTruncatingTail
        dishSummary.textAlignment = .justified
        dishSummary.textColor = .white
        dishSummaryScroll.addSubview(dishSummary)
        
        dishIngredients.addTarget(self, action: #selector(ingredients), for: .touchUpInside)
        dishIngredients.setupButtons(view: self, buttonName: "ingredients")
        self.addSubview(dishIngredients)
        
        dishSpeak.addTarget(self, action: #selector(speak), for: .touchUpInside)
        dishSpeak.setupButtons(view: self, buttonName: "speak")
        self.addSubview(dishSpeak)
        
        dishGoogle.addTarget(self, action: #selector(google), for: .touchUpInside)
        dishGoogle.setupButtons(view: self, buttonName: "google")
        self.addSubview(dishGoogle)
    }
    
    // Sets the contraints
    private func setupInitialLayout() {
        dishName.translatesAutoresizingMaskIntoConstraints = false
        dishNutrition.translatesAutoresizingMaskIntoConstraints = false
        dishSummary.translatesAutoresizingMaskIntoConstraints = false
        dishSummaryScroll.translatesAutoresizingMaskIntoConstraints = false
        dishSpeak.translatesAutoresizingMaskIntoConstraints = false
        dishIngredients.translatesAutoresizingMaskIntoConstraints = false
        dishGoogle.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = 0
        self.frame.origin.y = y
        self.frame.size.width = self.frame.width
        self.frame.size.height = heights[PopUpsState.TextRecognitionState]!
        
        dishName.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.PopUps.screenDistanceFromTopWithoutSafeArea).isActive = true
        dishName.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        dishName.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        dishName.heightAnchor.constraint(equalToConstant: dishNameHeight).isActive = true
        
        dishNutrition.topAnchor.constraint(equalTo: dishName.bottomAnchor).isActive = true
        dishNutrition.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        dishNutrition.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        dishNutrition.heightAnchor.constraint(equalToConstant: dishNutritionHeight).isActive = true
        
        dishSpeak.topAnchor.constraint(equalTo: dishNutrition.bottomAnchor).isActive = true
        dishSpeak.centerXAnchor.constraint(equalTo: Catalog.Contraints.getCenterXAnchor(view: self)).isActive = true
        dishSpeak.widthAnchor.constraint(equalToConstant: dishButtonsWidth).isActive = true
        dishSpeak.heightAnchor.constraint(equalToConstant: dishButtonsHeight).isActive = true
        
        dishIngredients.topAnchor.constraint(equalTo: dishNutrition.bottomAnchor).isActive = true
        dishIngredients.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: dishButtonsHeight).isActive = true
        dishIngredients.widthAnchor.constraint(equalToConstant: dishButtonsWidth).isActive = true
        dishIngredients.heightAnchor.constraint(equalToConstant: dishButtonsHeight).isActive = true
        
        dishGoogle.topAnchor.constraint(equalTo: dishNutrition.bottomAnchor).isActive = true
        dishGoogle.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -dishButtonsHeight).isActive = true
        dishGoogle.widthAnchor.constraint(equalToConstant: dishButtonsWidth).isActive = true
        dishGoogle.heightAnchor.constraint(equalToConstant: dishButtonsHeight).isActive = true
        
        dishSummaryScroll.topAnchor.constraint(equalTo: dishSpeak.bottomAnchor, constant: Catalog.PopUps.betweenElementsDistance).isActive = true
        dishSummaryScroll.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        dishSummaryScroll.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        dishSummaryScroll.heightAnchor.constraint(equalToConstant: dishSummaryHeight).isActive = true
        
        dishSummary.topAnchor.constraint(equalTo: dishSummaryScroll.topAnchor).isActive = true
        dishSummary.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        dishSummary.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
    }
    
    // State where food item is being searches by the user
    private func textSearchState() {
        Catalog.state = PopUpsState.TextSearchState
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.size.height = self.heights[PopUpsState.TextSearchState]!
            })
        }
    }
    
    // State where the camera is used for scanning menus
    private func textRecognitionState() {
        Catalog.state = PopUpsState.TextRecognitionState
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.size.height = self.heights[PopUpsState.TextRecognitionState]!
            })
        }
    }
    
    // State where some information of food item is being shown
    private func popUpState() {
        Catalog.state = PopUpsState.PopUpState
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.size.height = self.heights[PopUpsState.PopUpState]!
            })
        }
    }
    
    // State where everything about the food item is being shown
    private func imagesState() {
        Catalog.state = PopUpsState.ImagesState
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.size.height = self.heights[PopUpsState.ImagesState]!
            })
        }
    }
    
    // State is changed by calling this function
    internal func changeState(state: PopUpsState) {
        if state == PopUpsState.TextSearchState {
            textSearchState()
        }
        else if state == PopUpsState.TextRecognitionState {
            textRecognitionState()
        }
        else if state == PopUpsState.PopUpState {
            popUpState()
        }
        else if state == PopUpsState.ImagesState {
            imagesState()
        }
    }
    
    // Function called when upper popup view is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        Catalog.closeKeyboardAndRecommendations(view: self)
        if Catalog.state == PopUpsState.PopUpState {
            self.stateChanged?(PopUpsState.ImagesState)
            if sender.state == .ended {
                imagesState()
            }
        }
        else if Catalog.state == PopUpsState.ImagesState {
            self.stateChanged?(PopUpsState.PopUpState)
            if sender.state == .ended {
                popUpState()
            }
        }
    }
    
    // Function called when wiki info has to be found
    private func implementWikiSummarySearch(dish: String) {
        self.dishSummary.text = ""
        wikiSearch.startWikiSearch(forWhat: dish)
        
        // Call back function replies with answers
        wikiSearch.summaryReceived = { (_ summary: String?) -> () in
            DispatchQueue.main.async {
                if (summary == nil || summary!.count == 0) {
                    self.dishSummary.text = self.noSummary
                    self.dishSummary.textAlignment = .center
                }
                else {
                    self.dishSummary.text = summary
                    self.dishSummary.textAlignment = .justified
                }
                self.dishSummary.sizeToFit()
                self.dishSummaryScrollHeight = self.dishSummary.frame.height
                self.dishSummaryScroll.contentSize.height = self.dishSummaryScrollHeight
            }
        }
    }
    // Function called when nutritional info has to be found from fatsecret
    private func implementNutritionSearchFatSecret(dish: String) {
        self.dishNutrition.text = ""
        
        fatSecretInfo.getNutritionAuth2(forWhat: dish)
        
        // Call back function replies with answers
        fatSecretInfo.nutritionReceived = { (_ nutrition: String?) -> () in
            DispatchQueue.main.async {
                if (nutrition == nil || nutrition!.count == 0) {
                    self.dishNutrition.text = self.noNutrition
                }
                else {
                    self.dishNutrition.text = nutrition
                }
            }
        }
    }
    
    // Function called when nutritional info has to be found from USDA
    private func implementNutritionSearch(dish: String) {
        self.dishNutrition.text = ""
        
        usdaInfo.getNutrients(forWhat: dish)
        
        // Call back function replies with answers
        usdaInfo.nutrientsReceived = { (_ nutrients: String?) -> () in
            DispatchQueue.main.async {
                if (nutrients == nil || nutrients!.count == 0) {
                    self.dishNutrition.text = self.noNutrition
                }
                else {
                    self.dishNutrition.text = nutrients
                }
            }
        }
    }
    
    // This function is used to populate the array with recommendations
    // Every word is separated and then searched for recommendations
    // depending on the first few letters of the word
    @objc func recommendations(_ textField: UITextField) {
        searchedArray.removeAll()
        let word = textField.text!.components(separatedBy: " ").last
        if (word!.count >= 2) {
            for frt in DatasetWords.wordsSorted {
                let pre = frt.prefix(word!.count)
                if pre.lowercased() == word?.lowercased() {
                    searchedArray.append(frt.capitalizeEveryWord())
                    if searchedArray.count > 4 {
                        break
                    }
                }
            }
            if searchedArray.count == 0 {
                Catalog.mainViewController?.recoTableView.isHidden = true
            }
            else {
                Catalog.mainViewController?.recoTableView.isHidden = false
                Catalog.mainViewController?.recoTableView.frame.size.height = Catalog.Recommendation.recoCellHeight * CGFloat(searchedArray.count)
            }
        }
        else {
            Catalog.mainViewController?.recoTableView.isHidden = true
            searchedArray.removeAll()
        }
        Catalog.mainViewController?.recoTableView.reloadData()
    }
    
    // This function is called when the speak button is pressed
    @objc func speak() {
        Catalog.closeKeyboardAndRecommendations(view: self)
        dishSpeak.clicked()
        guard let text = dishName.text else { return }
        if (text.count == 0) { return }
        
        AnalyticsWrapper.Button.sendAnalytics(button: AnalyticsWrapper.Button.Buttons.Speak, dish: text)
        
        GoogleTextToSpeech.shared.speak(text)
    }
    
    // This function is called when ingredients button is pressed
    @objc func ingredients() {
        Catalog.closeKeyboardAndRecommendations(view: self)
        dishIngredients.clicked()
        guard let text = dishName.text else { return }
        if (text.count == 0) { return }
        
        AnalyticsWrapper.Button.sendAnalytics(button: AnalyticsWrapper.Button.Buttons.Ingredients, dish: text)
        
        Catalog.mainViewController?.ingredientsView.present(withDish: text)
    }
    
    // This function is called when google button is pressed
    @objc func google() {
        Catalog.closeKeyboardAndRecommendations(view: self)
        dishGoogle.clicked()
        guard let text = dishName.text else { return }
        if (text.count == 0) { return }
        
        AnalyticsWrapper.Button.sendAnalytics(button: AnalyticsWrapper.Button.Buttons.Google, dish: text)
        
        guard let url = URL(string: "https://www.google.com/search?q=\(text.replacingOccurrences(of: " ", with: "%20"))") else { return }
        UIApplication.shared.open(url)
    }
    
    // When the user presses enter after searching dish
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        Catalog.mainViewController?.recoTableView.isHidden = true
        guard let text = textField.text else { return true }
        
        // If dish field is empty then raise an alert
        if text.count == 0 {
            Catalog.alert(title: "No dish entered", message: "Please enter a dish name")
            return true
        }

        // If it is not a dish then raise an alert and ask if they want to search on google
        // if not then show the info
        if !TextRecognition.isDish(words: text) {
            AnalyticsWrapper.DishSearch.sendAnalytics(dish: text, dishRecognized: false)
            
            self.changeState(state: PopUpsState.TextSearchState)
            Catalog.mainViewController?.bottomPopUp.changeState(state: PopUpsState.TextSearchState)
            Catalog.dishNotFound(dish: text)
            return true
        }
        else {
            AnalyticsWrapper.DishSearch.sendAnalytics(dish: text, dishRecognized: true)
            
            textField.resignFirstResponder()
            dishTextRecognized(dish: textField.text)
            Catalog.mainViewController?.bottomPopUp.dishTextRecognized(dish: textField.text)
            return true
        }
    }
    
    // One done editing the recommendations table is hidden and keyboard is hidden
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        Catalog.mainViewController?.recoTableView.isHidden = true
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
