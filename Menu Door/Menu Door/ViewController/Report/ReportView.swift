//
//  ReportView.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/24/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class declared the report view will look

import Foundation
import UIKit
import MessageUI

internal class ReportView: UIView {
    private let background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    
    private var titlePhoto: UIImageView! = UIImageView()
    private var title: UILabel! = UILabel()
    private var reportInfo: UITextView! = UITextView()
    private let dishNotFoundButton: UIButton! = UIButton()
    private let wrongNutritionInfoButton: UIButton! = UIButton()
    private let wrongInfoButton: UIButton! = UIButton()
    private let wrongImagesButton: UIButton! = UIButton()
    private let othersButton: UIButton! = UIButton()
    private let reportButton: UIButton! = UIButton()
    private let cancelButton: UIButton! = UIButton()
    
    private let titleHeight: CGFloat! = Catalog.screenSize.height/5
    private let infoHeight: CGFloat! = Catalog.screenSize.height/5
    private let highbuttonHeight: CGFloat = Catalog.screenSize.height/20
    private let lowbuttonHeight: CGFloat! = Catalog.screenSize.height/8
    private let placeholder: String! = "If you have feedback on any dish then you can mention it here. Any other feedbacks are also welcome. Select one or more buttons below to help us understand the feedback better. We will get on this right away. Thank you for your cooperation!"
    
    private let betweenElementsDistance: CGFloat = 8

    private let y: [State: CGFloat]! = [State.HiddenState: Catalog.screenSize.height, State.ShownState: 0]
    
    private var buttonsSelected: [ReportButtons]! = []
    private var buttonsBoolean: [ReportButtons: Bool]! = [ReportButtons.Dish_Not_Found: false,
        ReportButtons.Wrong_Nutrition_Info: false,
        ReportButtons.Wrong_Information: false,
        ReportButtons.Wrong_Images: false,
        ReportButtons.Others: false]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        
        reportInfo.delegate = self
        
        setupInitialLayout()
        
        dishNotFoundButton.addTarget(self, action: #selector(dishNotFound), for: .touchUpInside)
        wrongNutritionInfoButton.addTarget(self, action: #selector(wrongNutritionInfo), for: .touchUpInside)
        wrongInfoButton.addTarget(self, action: #selector(wrongInfo), for: .touchUpInside)
        wrongImagesButton.addTarget(self, action: #selector(wrongImages), for: .touchUpInside)
        othersButton.addTarget(self, action: #selector(others), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(report), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    }
    
    // Sets the views
    private func setupViews() {        
        background.setupViews(view: self, isPopUp: false, addBlur: true, addDark: false)

        titlePhoto.image = UIImage.init(named: "feedback")
        titlePhoto.backgroundColor = .clear
        self.addSubview(titlePhoto)
        
        title.text = "Thank you for your feedback"
        title.font = UIFont.systemFont(ofSize: Catalog.FontSize.titleFontSize, weight: UIFont.Weight.light)
        title.numberOfLines = 0
        title.textAlignment = .center
        title.textColor = .white
        self.addSubview(title)
        
        reportInfo.text = placeholder
        reportInfo.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        reportInfo.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        reportInfo.textAlignment = .justified
        reportInfo.textColor = .lightGray
        reportInfo.layer.cornerRadius = Catalog.cornerRadius
        reportInfo.clipsToBounds = true
        reportInfo.keyboardAppearance = .dark
        self.addSubview(reportInfo)
        
        dishNotFoundButton.setTitle("Dish Not Found", for: .normal)
        dishNotFoundButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        dishNotFoundButton.setTitleColor(.white, for: .normal)
        dishNotFoundButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        dishNotFoundButton.layer.cornerRadius = highbuttonHeight/2
        dishNotFoundButton.clipsToBounds = true
        self.addSubview(dishNotFoundButton)
        
        wrongNutritionInfoButton.setTitle("Wrong Ingredients Information", for: .normal)
        wrongNutritionInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        wrongNutritionInfoButton.setTitleColor(.white, for: .normal)
        wrongNutritionInfoButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        wrongNutritionInfoButton.layer.cornerRadius = highbuttonHeight/2
        wrongNutritionInfoButton.clipsToBounds = true
        self.addSubview(wrongNutritionInfoButton)
        
        wrongInfoButton.setTitle("Wrong Summary/Nutrition Info", for: .normal)
        wrongInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        wrongInfoButton.setTitleColor(.white, for: .normal)
        wrongInfoButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        wrongInfoButton.layer.cornerRadius = highbuttonHeight/2
        wrongInfoButton.clipsToBounds = true
        self.addSubview(wrongInfoButton)
        
        wrongImagesButton.setTitle("Wrong Images", for: .normal)
        wrongImagesButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        wrongImagesButton.setTitleColor(.white, for: .normal)
        wrongImagesButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        wrongImagesButton.layer.cornerRadius = highbuttonHeight/2
        wrongImagesButton.clipsToBounds = true
        self.addSubview(wrongImagesButton)
        
        othersButton.setTitle("Others", for: .normal)
        othersButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        othersButton.setTitleColor(.white, for: .normal)
        othersButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        othersButton.layer.cornerRadius = highbuttonHeight/2
        othersButton.clipsToBounds = true
        self.addSubview(othersButton)
        
        reportButton.setTitle("Send", for: .normal)
        reportButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        reportButton.setTitleColor(.white, for: .normal)
        reportButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        reportButton.layer.cornerRadius = lowbuttonHeight/2
        reportButton.clipsToBounds = true
        self.addSubview(reportButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.smallButtonFontSize, weight: UIFont.Weight.light)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        cancelButton.layer.cornerRadius = lowbuttonHeight/2
        cancelButton.clipsToBounds = true
        self.addSubview(cancelButton)
    }
    
    // Sets the constraints
    private func setupInitialLayout() {
        titlePhoto.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        reportInfo.translatesAutoresizingMaskIntoConstraints = false
        dishNotFoundButton.translatesAutoresizingMaskIntoConstraints = false
        wrongNutritionInfoButton.translatesAutoresizingMaskIntoConstraints = false
        wrongInfoButton.translatesAutoresizingMaskIntoConstraints = false
        wrongImagesButton.translatesAutoresizingMaskIntoConstraints = false
        othersButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = 0
        self.frame.origin.y = y[State.HiddenState]!
        self.frame.size.width = self.frame.width
        self.frame.size.height = self.frame.height
        
        titlePhoto.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        titlePhoto.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        titlePhoto.widthAnchor.constraint(equalToConstant: titleHeight).isActive = true
        titlePhoto.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        
        title.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        title.leftAnchor.constraint(equalTo: titlePhoto.rightAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        title.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        title.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
        
        reportInfo.topAnchor.constraint(equalTo: title.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        reportInfo.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        reportInfo.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        reportInfo.heightAnchor.constraint(equalToConstant: infoHeight).isActive = true
        
        dishNotFoundButton.topAnchor.constraint(equalTo: reportInfo.bottomAnchor, constant: betweenElementsDistance).isActive = true
        dishNotFoundButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        dishNotFoundButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        dishNotFoundButton.heightAnchor.constraint(equalToConstant: highbuttonHeight).isActive = true
        
        wrongNutritionInfoButton.topAnchor.constraint(equalTo: dishNotFoundButton.bottomAnchor, constant: betweenElementsDistance).isActive = true
        wrongNutritionInfoButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        wrongNutritionInfoButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        wrongNutritionInfoButton.heightAnchor.constraint(equalToConstant: highbuttonHeight).isActive = true
        
        wrongInfoButton.topAnchor.constraint(equalTo: wrongNutritionInfoButton.bottomAnchor, constant: betweenElementsDistance).isActive = true
        wrongInfoButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        wrongInfoButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        wrongInfoButton.heightAnchor.constraint(equalToConstant: highbuttonHeight).isActive = true
        
        wrongImagesButton.topAnchor.constraint(equalTo: wrongInfoButton.bottomAnchor, constant: betweenElementsDistance).isActive = true
        wrongImagesButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        wrongImagesButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        wrongImagesButton.heightAnchor.constraint(equalToConstant: highbuttonHeight).isActive = true
        
        othersButton.topAnchor.constraint(equalTo: wrongImagesButton.bottomAnchor, constant: betweenElementsDistance).isActive = true
        othersButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        othersButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        othersButton.heightAnchor.constraint(equalToConstant: highbuttonHeight).isActive = true
        
        reportButton.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        reportButton.widthAnchor.constraint(equalToConstant: lowbuttonHeight).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: lowbuttonHeight).isActive = true
        reportButton.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        
        cancelButton.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: lowbuttonHeight).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: lowbuttonHeight).isActive = true
        cancelButton.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
    }
    
    
    // This function is called whenever the view has to be presented
    internal func present() {
        reset()
        
        DispatchQueue.main.async {
            self.background.resetViews(isPopUp: false)
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[State.ShownState]!
            })
        }
    }
    
    // This function is called whenever a device has to be reported because it was not found in the database
    internal func presentWithDishName(dish: String) {
        reset()
        
        DispatchQueue.main.async {
            self.background.resetViews(isPopUp: false)
            self.reportInfo.text = "\(dish) was not found"
            self.reportInfo.textColor = UIColor.white
            self.dishNotFound()
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
    
    // This function is called whenever the view has to be deleted.
    // The text field is emptied and all the buttons are unpressed
    private func reset() {
        dishNotFoundButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        wrongNutritionInfoButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        wrongInfoButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        wrongImagesButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        othersButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        
        dishNotFoundButton.setTitleColor(.white, for: .normal)
        wrongNutritionInfoButton.setTitleColor(.white, for: .normal)
        wrongInfoButton.setTitleColor(.white, for: .normal)
        wrongImagesButton.setTitleColor(.white, for: .normal)
        othersButton.setTitleColor(.white, for: .normal)
        
        buttonsSelected.removeAll()
        
        for (button, _) in buttonsBoolean {
            buttonsBoolean[button] = false
        }
        
        reportInfo.text = placeholder
        reportInfo.textColor = UIColor.lightGray
    }
    
    // When the dish not found button is pressed
    @objc func  dishNotFound() {
        if buttonsBoolean[ReportButtons.Dish_Not_Found]! {
            dishNotFoundButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            dishNotFoundButton.setTitleColor(.white, for: .normal)
            buttonsSelected.append(ReportButtons.Dish_Not_Found)
            buttonsBoolean[ReportButtons.Dish_Not_Found] = false
        }
        else {
            dishNotFoundButton.backgroundColor = .white
            dishNotFoundButton.setTitleColor(.black, for: .normal)
            buttonsSelected.append(ReportButtons.Dish_Not_Found)
            buttonsBoolean[ReportButtons.Dish_Not_Found] = true
        }
    }
    
    // When the wrong nutrition info button is pressed
    @objc func wrongNutritionInfo() {
        if buttonsBoolean[ReportButtons.Wrong_Nutrition_Info]! {
            wrongNutritionInfoButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            wrongNutritionInfoButton.setTitleColor(.white, for: .normal)
            buttonsSelected.append(ReportButtons.Wrong_Nutrition_Info)
            buttonsBoolean[ReportButtons.Wrong_Nutrition_Info] = false
        }
        else {
            wrongNutritionInfoButton.backgroundColor = .white
            wrongNutritionInfoButton.setTitleColor(.black, for: .normal)
            buttonsSelected.append(ReportButtons.Wrong_Nutrition_Info)
            buttonsBoolean[ReportButtons.Wrong_Nutrition_Info] = true
        }
    }
    
    // When the wrong info button is pressed
    @objc func wrongInfo() {
        if buttonsBoolean[ReportButtons.Wrong_Information]! {
            wrongInfoButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            wrongInfoButton.setTitleColor(.white, for: .normal)
            buttonsSelected.append(ReportButtons.Wrong_Information)
            buttonsBoolean[ReportButtons.Wrong_Information] = false
        }
        else {
            wrongInfoButton.backgroundColor = .white
            wrongInfoButton.setTitleColor(.black, for: .normal)
            buttonsSelected.append(ReportButtons.Wrong_Information)
            buttonsBoolean[ReportButtons.Wrong_Information] = true
        }
    }
    
    // When the wrong images button is pressed
    @objc func wrongImages() {
        if buttonsBoolean[ReportButtons.Wrong_Images]! {
            wrongImagesButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            wrongImagesButton.setTitleColor(.white, for: .normal)
            buttonsSelected.append(ReportButtons.Wrong_Images)
            buttonsBoolean[ReportButtons.Wrong_Images] = false
        }
        else {
            wrongImagesButton.backgroundColor = .white
            wrongImagesButton.setTitleColor(.black, for: .normal)
            buttonsSelected.append(ReportButtons.Wrong_Images)
            buttonsBoolean[ReportButtons.Wrong_Images] = true
        }
    }
    
    // When the others button is pressed
    @objc func others() {
        if buttonsBoolean[ReportButtons.Others]! {
            othersButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            othersButton.setTitleColor(.white, for: .normal)
            buttonsSelected.append(ReportButtons.Others)
            buttonsBoolean[ReportButtons.Others] = false
        }
        else {
            othersButton.backgroundColor = .white
            othersButton.setTitleColor(.black, for: .normal)
            buttonsSelected.append(ReportButtons.Others)
            buttonsBoolean[ReportButtons.Others] = true
        }
    }
    
    // When the report button is pressed
    @objc func report() {
        
        // If no button is pressed then ask user to select some button
        if buttonsSelected.count == 0 {
            reportButton.backgroundColor = .red
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.reportButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            })
            Catalog.alert(title: "No option selected", message: "Please select an option to help us better understand the feedback")
            return
        }
        
        // When the description is too small, ask the user to fill more info
        if reportInfo.textColor == UIColor.lightGray || reportInfo.text.count < 5 {
            reportButton.backgroundColor = .red
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.reportButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            })
            Catalog.alert(title: "Description too small", message: "Please write a bit more feedback to help us understand better")
            return
        }
        else {
            reportButton.backgroundColor = .green
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.reportButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            })
            dismiss()
            
            AnalyticsWrapper.Report.sendAnalytics(info: reportInfo.text, whichButton: buttonsSelected, reportPressed: true, cancelPressed: false)
            
            Catalog.alert(title: "Thank you for your feedback", message: "We will get on this right away")
        }
    }
    
    // This is called when the cancel button is pressed
    @objc func cancel() {
        cancelButton.backgroundColor = .red
        UIView.animate(withDuration: Catalog.animateTime, animations: {
            self.cancelButton.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            
            AnalyticsWrapper.Report.sendAnalytics(info: "", whichButton: [], reportPressed: false, cancelPressed: true)
        })
        dismiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// This is used to set a placeholder in text view.
// Text view does not have any placeholder so all this drama has to be done.
// When the view is empty then it is replaced with gray text.
// When the user is writing the if there is a gray text then it is all removed,
extension ReportView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
