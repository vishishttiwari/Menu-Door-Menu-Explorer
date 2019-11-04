//
//  IngredientsView.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/28/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This class is used to show the the ingredients of the dish

import Foundation
import UIKit

internal class IngredientsView: UIView {
    // The UI elemnts are declared
    private let background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    private let dishTitle: UILabel! = UILabel()
    private let ingredientsTitle: UILabel! = UILabel()
    private let disclaimer: UILabel! = UILabel()
    private var ingredientsTableView: UITableView! = UITableView()
    private let backButton: BackButton! = BackButton()
    
    // This sets the dimensions of the view in different states
    private let y: [State: CGFloat]! = [State.HiddenState: -Catalog.screenSize.height, State.ShownState: 0]
    private let dishTitleHeight: CGFloat! = 50
    private let ingredientsTitleHeight: CGFloat! = 40
    
    private let cellId = "cellId"
    private let cellHeight: CGFloat! = 60
    
    private let noIngredients: String! = "No ingredients were found"
    private let ingredientsTitleString: String! = "Common Ingredients"
    private let disclaimerString: String! = "Ingredients may vary depending on restaurants"
    private let recipePuppyIngredients: RecipePuppyIngredients = RecipePuppyIngredients()
    private var ingredients: [String]! = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Sets the views
        setupViews()
        
        // Sets the cells of the table view
        ingredientsTableView.register(IngredientsCell.self, forCellReuseIdentifier: cellId)
        ingredientsTableView.dataSource = self
        ingredientsTableView.delegate = self
        
        // Sets the contraints
        setupInitialLayout()
        
        // Sets the back button and the function is called when back button is pressed
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        // Sets the tap on the cells. Whenever a cell is pressed, the description of that cell is shown
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        ingredientsTableView.addGestureRecognizer(tap)
    }
    
    // Sets the UI of the elements of the view
    private func setupViews() {
        background.setupViews(view: self, isPopUp: false, addBlur: true, addDark: false)
        
        dishTitle.backgroundColor = .clear
        dishTitle.font = UIFont.systemFont(ofSize: Catalog.FontSize.titleFontSize + 15, weight: UIFont.Weight.light)
        dishTitle.numberOfLines = 0
        dishTitle.lineBreakMode = .byTruncatingTail
        dishTitle.textAlignment = .center
        dishTitle.textColor = .white
        dishTitle.sizeToFit()
        self.addSubview(dishTitle)
        
        ingredientsTitle.backgroundColor = .clear
        ingredientsTitle.font = UIFont.systemFont(ofSize: Catalog.FontSize.normalButtonFontSize + 5, weight: UIFont.Weight.light)
        ingredientsTitle.numberOfLines = 0
        ingredientsTitle.lineBreakMode = .byTruncatingTail
        ingredientsTitle.textAlignment = .center
        ingredientsTitle.textColor = .white
        ingredientsTitle.sizeToFit()
        self.addSubview(ingredientsTitle)
        
        disclaimer.backgroundColor = .clear
        disclaimer.font = UIFont.systemFont(ofSize: Catalog.FontSize.normalButtonFontSize, weight: UIFont.Weight.light)
        disclaimer.numberOfLines = 0
        disclaimer.lineBreakMode = .byTruncatingTail
        disclaimer.textAlignment = .center
        disclaimer.textColor = .white
        disclaimer.sizeToFit()
        self.addSubview(disclaimer)
        
        ingredientsTableView.backgroundColor = .clear
        ingredientsTableView.isScrollEnabled = true
        ingredientsTableView.showsHorizontalScrollIndicator = false
        ingredientsTableView.showsVerticalScrollIndicator = false
        ingredientsTableView.rowHeight = cellHeight
        self.addSubview(ingredientsTableView)
        
        backButton.setupViews(view: self, titleColor: .black)
        self.addSubview(backButton)
    }
    
    // Sets the contraints
    private func setupInitialLayout() {
        dishTitle.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTitle.translatesAutoresizingMaskIntoConstraints = false
        disclaimer.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = 0
        self.frame.origin.y = y[State.HiddenState]!
        self.frame.size.width = self.frame.width
        self.frame.size.height = self.frame.height
        
        dishTitle.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        dishTitle.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        dishTitle.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        dishTitle.heightAnchor.constraint(equalToConstant: dishTitleHeight).isActive = true
        
        ingredientsTitle.topAnchor.constraint(equalTo: self.dishTitle.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        ingredientsTitle.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        ingredientsTitle.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        ingredientsTitle.heightAnchor.constraint(equalToConstant: ingredientsTitleHeight).isActive = true
        
        disclaimer.topAnchor.constraint(equalTo: self.ingredientsTitle.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        disclaimer.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        disclaimer.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        disclaimer.heightAnchor.constraint(equalToConstant: 2 * ingredientsTitleHeight).isActive = true
        
        ingredientsTableView.topAnchor.constraint(equalTo: disclaimer.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        ingredientsTableView.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        ingredientsTableView.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        ingredientsTableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -Catalog.Layout.betweenElementsDistance).isActive = true
        
        backButton.setupLayout(view: self)
    }
    
    // Shows the ingredients from recipe puppy
    private func recipePuppySearch(withDish: String) {
        recipePuppyIngredients.getIngredients(forWhat: withDish)
        
        recipePuppyIngredients.ingredientsReceived = { (_ ingredients: [String]?, _ title: String?) -> () in
            DispatchQueue.main.async {
                if (title == nil || title!.count == 0) {
                    self.dishTitle.text = ""
                    self.ingredientsTitle.text = self.noIngredients
                    self.disclaimer.text = ""
                }
                else {
                    self.dishTitle.text = withDish
                    self.ingredientsTitle.text = self.ingredientsTitleString
                    self.disclaimer.text = self.disclaimerString
                    self.ingredients.append(contentsOf: ingredients!)
                }
                self.ingredientsTableView.reloadData()
            }
        }
    }
    
    // This function is called when the view has to be shown
    internal func present(withDish: String) {
        background.resetViews(isPopUp: false)
        ingredients.removeAll()
        recipePuppySearch(withDish: withDish)
        ingredientsTableView.scroll(to: .top, animated: true)

        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[State.ShownState]!
            })
        }
    }
    
    // This function is called whne the view has to be dismissed
    private func dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[State.HiddenState]!
            })
        }
    }
    
    // This function is called when the back button is pressed
    @objc func back() {
        backButton.clicked()
        dismiss()
    }
    
    // Thi function is called when the cells are tap.
    // It shows the description of the ingredient that is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer){
        if let indexPath = ingredientsTableView.indexPathForRow(at: sender.location(in: ingredientsTableView)) {
            let cell = ingredientsTableView.cellForRow(at: indexPath) as! IngredientsCell
            if sender.state == .ended {
                cell.backgroundColor = .white
                UIView.animate(withDuration: Catalog.animateTime, animations: {
                    cell.backgroundColor = .clear
                })
                Catalog.mainViewController?.ingredientDescription.present(ingredient: cell.ingredient.text!)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// This sets the table view of the ingredients
extension IngredientsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! IngredientsCell
        
        cell.ingredient.text = ingredients[indexPath.row]
        
        return cell
    }
}
