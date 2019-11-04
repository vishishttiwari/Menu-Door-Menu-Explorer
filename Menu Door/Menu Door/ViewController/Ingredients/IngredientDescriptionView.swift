//
//  IngredientDescriptionView.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/30/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Class used for showing the description ingredients

import Foundation
import UIKit

internal class IngredientDescriptionView: UIView {
    // Elements in the view
    private let background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    private let ingredientName: UITextField! = UITextField()
    private let ingredientNutrition: UILabel! = UILabel()
    private let ingredientSummary: UILabel! = UILabel()
    private let ingredientSummaryScroll: UIScrollView! = UIScrollView()
    private let ingredientGoogle: SpecialButton! = SpecialButton()
    private var ingredientImagesView: UICollectionView!
    private let backButton: BackButton! = BackButton()
    
    // Height of elements
    private let ingredientNameHeight: CGFloat! = 45
    private let ingredientNutritionHeight: CGFloat! = 50
    private var ingredientSummaryHeight: CGFloat! = 50
    private var ingredientSummaryScrollHeight: CGFloat! = 50
    private let ingredientGoogleHeight: CGFloat! = 20
    private let ingredientGoogleWidth: CGFloat! = 42
    private let y: [State: CGFloat]! = [State.HiddenState: Catalog.screenSize.height, State.ShownState: 0]
    
    // Cell properties
    private let cellId = "cellId"
    private let totalCells: Int! = 10
    private var ingredientImages: [UIImage]! = []
    private let cellHeight: CGFloat! = Catalog.screenSize.height/3
    private let cellWidth: CGFloat! = Catalog.screenSize.height/3
    
    // Sets the APIs
    private let fatSecretInfo: FatSecretInfo = FatSecretInfo.init()
    private let usdaInfo: USDANutrients = USDANutrients.init()
    private let wikiSearch: WikipediaSummary = WikipediaSummary.init()
    private let googleSearch: GoogleImageSearch = GoogleImageSearch.init()
    
    private let noNutrition: String! = "No nutrition info was found for this ingredient"
    private let noSummary: String! = "No summary was found for this ingredient"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // This makes sure the first and last cell are in the middle and not at sides
        let insetX = (self.bounds.width - cellWidth)/2
        let insetY: CGFloat = 0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight!)
        ingredientImagesView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        ingredientImagesView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        // Set the display of all the elements in the popup
        setupViews()
        
        // Sets the cells of the collection view for images
        ingredientImagesView.register(DishImageCell.self, forCellWithReuseIdentifier: cellId)
        ingredientImagesView.dataSource = self
        ingredientImagesView.delegate = self
        
        // Sets the constraints
        setupInitialLayout()
        
        // Sets the buttons functions
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        ingredientGoogle.addTarget(self, action: #selector(google), for: .touchUpInside)
    }
    
    // This function is called whenever the view has to be presented
    internal func present(ingredient: String) {
        ingredientNutrition.text = ""
        ingredientSummary.text = ""
        
        background.resetViews(isPopUp: false)
        
        ingredientName.text = ingredient
        implementWikiSummarySearch(ingredient: ingredient)
        implementNutritionSearch(ingredient: ingredient)
        implementGoogleImageSearch(ingredient: ingredient)
        
        scrollToWithoutAnimation(cellNumber: 1)
        scrollToWithAnimation(cellNumber: 0)
        
        DispatchQueue.main.async {
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
    
    // This function is called when back button is pressed
    @objc func back() {
        backButton.clicked()
        dismiss()
    }
    
    // Sets the views of the ui elements
    private func setupViews() {        
        background.setupViews(view: self, isPopUp: false, addBlur: true, addDark: false)
        
        ingredientName.backgroundColor = .clear
        ingredientName.font = UIFont.systemFont(ofSize: Catalog.FontSize.titleFontSize + 5, weight: UIFont.Weight.light)
        ingredientName.textAlignment = .center
        ingredientName.textColor = .white
        ingredientName.keyboardAppearance = .dark
        ingredientName.contentVerticalAlignment = .top
        self.addSubview(ingredientName)
        
        ingredientNutrition.backgroundColor = .clear
        ingredientNutrition.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        ingredientNutrition.numberOfLines = 0
        ingredientNutrition.lineBreakMode = .byTruncatingTail
        ingredientNutrition.textAlignment = .center
        ingredientNutrition.textColor = .white
        ingredientNutrition.sizeToFit()
        self.addSubview(ingredientNutrition)
        
        ingredientSummaryScroll.backgroundColor = .clear
        ingredientSummaryScroll.isScrollEnabled = true
        ingredientSummaryScroll.showsVerticalScrollIndicator = false
        ingredientSummaryScroll.contentSize.height = ingredientSummaryScrollHeight
        self.addSubview(ingredientSummaryScroll)
        
        ingredientSummary.backgroundColor = .clear
        ingredientSummary.font = UIFont.systemFont(ofSize: Catalog.FontSize.longDataFontSize, weight: UIFont.Weight.light)
        ingredientSummary.numberOfLines = 0
        ingredientSummary.lineBreakMode = .byTruncatingTail
        ingredientSummary.textAlignment = .justified
        ingredientSummary.textColor = .white
        ingredientSummaryScroll.addSubview(ingredientSummary)
        
        ingredientImagesView.backgroundColor = .clear
        ingredientImagesView.isScrollEnabled = true
        ingredientImagesView.showsHorizontalScrollIndicator = false
        ingredientImagesView.showsVerticalScrollIndicator = false
        self.addSubview(ingredientImagesView)
        
        backButton.setupViews(view: self, titleColor: .black)
        self.addSubview(backButton)
        
        ingredientGoogle.setupButtons(view: self, buttonName: "google")
    }
    
    // Sets the contraints
    private func setupInitialLayout() {
        ingredientName.translatesAutoresizingMaskIntoConstraints = false
        ingredientNutrition.translatesAutoresizingMaskIntoConstraints = false
        ingredientSummary.translatesAutoresizingMaskIntoConstraints = false
        ingredientSummaryScroll.translatesAutoresizingMaskIntoConstraints = false
        ingredientGoogle.translatesAutoresizingMaskIntoConstraints = false
        ingredientImagesView.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = 0
        self.frame.origin.y = y[State.HiddenState]!
        self.frame.size.width = self.frame.width
        self.frame.size.height = self.frame.height
        
        ingredientName.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        ingredientName.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        ingredientName.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        ingredientName.heightAnchor.constraint(equalToConstant: ingredientNameHeight).isActive = true
        
        ingredientNutrition.topAnchor.constraint(equalTo: ingredientName.bottomAnchor).isActive = true
        ingredientNutrition.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        ingredientNutrition.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        ingredientNutrition.heightAnchor.constraint(equalToConstant: ingredientNutritionHeight).isActive = true
        
        ingredientGoogle.topAnchor.constraint(equalTo: ingredientNutrition.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        ingredientGoogle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        ingredientGoogle.widthAnchor.constraint(equalToConstant: ingredientGoogleWidth).isActive = true
        ingredientGoogle.heightAnchor.constraint(equalToConstant: ingredientGoogleHeight).isActive = true
        
        ingredientSummaryScroll.topAnchor.constraint(equalTo: ingredientGoogle.bottomAnchor, constant: Catalog.Layout.betweenElementsDistance).isActive = true
        ingredientSummaryScroll.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        ingredientSummaryScroll.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        ingredientSummaryScroll.bottomAnchor.constraint(equalTo: self.ingredientImagesView.topAnchor, constant: -Catalog.Layout.betweenElementsDistance).isActive = true
        
        ingredientSummary.topAnchor.constraint(equalTo: ingredientSummaryScroll.topAnchor).isActive = true
        ingredientSummary.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.betweenElementsDistance).isActive = true
        ingredientSummary.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.betweenElementsDistance).isActive = true
        
        ingredientImagesView.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self)).isActive = true
        ingredientImagesView.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self)).isActive = true
        ingredientImagesView.heightAnchor.constraint(equalToConstant: cellHeight).isActive = true
        ingredientImagesView.bottomAnchor.constraint(equalTo: self.backButton.topAnchor, constant: -Catalog.Layout.betweenElementsDistance).isActive = true
        
        backButton.setupLayout(view: self)
    }
    
    // Gets the wiki information of the ingredient
    private func implementWikiSummarySearch(ingredient: String) {
        wikiSearch.startWikiSearch(forWhat: ingredient)
        
        // Call back functions are called when information is received
        wikiSearch.summaryReceived = { (_ summary: String?) -> () in
            DispatchQueue.main.async {
                if (summary == nil || summary!.count == 0) {
                    self.ingredientSummary.text = self.noSummary
                    self.ingredientSummary.textAlignment = .center
                }
                else {
                    self.ingredientSummary.text = summary
                    self.ingredientSummary.textAlignment = .justified
                }
                self.ingredientSummary.sizeToFit()
                self.ingredientSummaryScrollHeight = self.ingredientSummary.frame.height
                self.ingredientSummaryScroll.contentSize.height = self.ingredientSummaryScrollHeight
            }
        }
    }
    
    // Gets the nutritional info form fatsecret
    private func implementNutritionSearchFatSecret(ingredient: String) {
        fatSecretInfo.getNutritionAuth2(forWhat: ingredient)
        fatSecretInfo.nutritionReceived = { (_ nutrition: String?) -> () in
            DispatchQueue.main.async {
                if (nutrition == nil || nutrition!.count == 0) {
                    self.ingredientNutrition.text = self.noNutrition
                }
                else {
                    self.ingredientNutrition.text = nutrition
                }
            }
        }
    }
    
    // Gets the nutritional info form usda
    private func implementNutritionSearch(ingredient: String) {
        usdaInfo.getNutrients(forWhat: ingredient)
        usdaInfo.nutrientsReceived = { (_ nutrients: String?) -> () in
            DispatchQueue.main.async {
                if (nutrients == nil || nutrients!.count == 0) {
                    self.ingredientNutrition.text = self.noNutrition
                }
                else {
                    self.ingredientNutrition.text = nutrients
                }
            }
        }
    }
    
    // Gets the images from google
    private func implementGoogleImageSearch(ingredient: String) {
        self.ingredientImages.removeAll()
        
        googleSearch.findImages(forWhat: ingredient)
        
        googleSearch.imageReceived = { (_ imageArray: [String]) -> () in
            for image in imageArray {
                guard let imageURL: URL = Foundation.URL(string: image) else { return }
                
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    guard let data = data else { return }
                    if (error == nil) {
                        guard let img = UIImage.init(data: data) else { return }
                        self.ingredientImages.append(img)
                        DispatchQueue.main.async {
                            self.ingredientImagesView.reloadData()
                        }
                    }
                }.resume()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UICollectionViewDataSource
// Sets everything related to horizontal srolling collection view
extension IngredientDescriptionView: UICollectionViewDataSource {
    
    // Sets the total cells in images collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCells
    }
    
    // Sets each of the cells in thh collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DishImageCell
        
        cell.activityIndicator.startAnimating()
        
        if (indexPath.row >= ingredientImages.count) {
            cell.image.image = nil }
        else {
            cell.image.image = ingredientImages[indexPath.row]
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }
    
    // Sets the sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Sets the scrolling to a specific cell with animation
    private func scrollToWithAnimation(cellNumber: Int) {
        DispatchQueue.main.async {
            self.ingredientImagesView.scrollToItem(at: .init(item: cellNumber, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // Sets the scrolling to a specific cell without animation
    private func scrollToWithoutAnimation(cellNumber: Int) {
        DispatchQueue.main.async {
            self.ingredientImagesView.scrollToItem(at: .init(item: cellNumber, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    // This function is called when google is pressed
    @objc func google() {
        ingredientGoogle.clicked()
        guard let text = ingredientName.text else { return }
        if (text.count == 0) { return }
        
        guard let url = URL(string: "https://www.google.com/search?q=\(text.replacingOccurrences(of: " ", with: "%20"))") else { return }
        UIApplication.shared.open(url)
    }
}

extension IngredientDescriptionView: UIScrollViewDelegate, UICollectionViewDelegate {
    
    // This function makes sure that when dragging ends, the cell only lands in the middle
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = ingredientImagesView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left)/cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint.init(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    // During every scroll the the zooming is set
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCellZooming()
    }
    
    // Sets the whiteness of the cells who are on the side
    private func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.25
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
    }
    
    // Sets the size of the cells to give a zooming feeling. The cells on the side are shrunk and
    // cell in the middle is bigger.
    private func setCellZooming() {
        let centerX = ingredientImagesView.center.x + 50
        
        for cell in ingredientImagesView.visibleCells {
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self)
            let cellCenterX = basePosition.x + ingredientImagesView.frame.size.width/2.0
            let distance = abs(cellCenterX - centerX)
            
            let tolerance : CGFloat = 0.02
            var scale = 1.00 + tolerance - (( distance / centerX ) * 0.2)
            if(scale > 1.0) { scale = 1.0 }
            if(scale < 0.86){ scale = 0.86 }
            
            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
            let coverCell = cell as! DishImageCell
            
            coverCell.image.alpha = changeSizeScaleToAlphaScale(scale)
        }
    }
}
