//
//  BottomPopUp.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/20/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Class used for setting up the popup view at the bottom

import Foundation
import UIKit

internal class BottomPopUp: UIView {
    
    // Optional Closures
    internal var stateChanged: ((_ state: PopUpsState) -> ())?
    
    // Elements in popUp
    private var background: BackgroundImage! = BackgroundImage.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    private let bar: UIImageView! = UIImageView()
    private var dishImagesView: UICollectionView!
    
    // Height of elements in popUp
    private let barHeight: CGFloat! = 30
    private let thresholdImages = Catalog.screenSize.height/2
    private let thresholdText = 3*Catalog.screenSize.height/4
    
    // Dimensions of lower pop up in three states
    private var y: [PopUpsState: CGFloat]! = [PopUpsState.TextSearchState: 0, PopUpsState.TextRecognitionState: 0, PopUpsState.PopUpState: 0, PopUpsState.ImagesState: 0]
    private var height: CGFloat!
    
    // Cell properties
    private let cellId = "cellId"
    private let totalCells: Int! = 10
    private var dishImages: [UIImage]! = []
    private let cellHeight: CGFloat! = 5*Catalog.screenSize.width/7
    private let cellWidth: CGFloat! = 5*Catalog.screenSize.width/7
    
    // Initialize APIs
    private let googleSearch: GoogleImageSearch = GoogleImageSearch.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Set up heights of the popup for different states like when searching or when displaying images
        background.frame.origin.y = -self.frame.origin.y
        
        y[PopUpsState.TextSearchState] = frame.height
        y[PopUpsState.TextRecognitionState] = frame.height
        y[PopUpsState.PopUpState] = frame.height - (barHeight + cellHeight + Catalog.PopUps.screenDistanceFromBottom)
        y[PopUpsState.ImagesState] = Catalog.height_ImagesState_Top
        height = frame.height + Catalog.hiddenThreshold
        
        // This makes sure the first and last cell are in the middle and not at sides
        let insetX = (self.bounds.width - cellWidth)/2
        let insetY: CGFloat = 0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight!)
        dishImagesView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        dishImagesView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        // Set the display of all the elements in the popup
        setupViews()
        
        // Sets the collection view inside this view
        dishImagesView.register(DishImageCell.self, forCellWithReuseIdentifier: cellId)
        dishImagesView.dataSource = self
        dishImagesView.delegate = self
        
        // Set the constraints of all elements in popup
        setupInitialLayout()
        
        // Tap gesture to toggle between image state and popup state
        // Pan to dismiss the popups or toggle between states
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.addGestureRecognizer(pan)
        self.addGestureRecognizer(tap)
    }
    
    // When dish is either searched or tapped, this function is called
    internal func dishTextRecognized(dish: String?) {
        guard let dish: String = dish else { return }
        if dish.count == 0 { return }
        
        scrollToWithoutAnimation(cellNumber: 1)
        scrollToWithAnimation(cellNumber: 0)
        
        background.resetViews(isPopUp: true)
        implementGoogleImageSearch(dish: dish)
        popUpState()
    }
    
    // When the dish is searched bu textfield, this function is called
    internal func dishTextStartEditing() {
        background.resetViews(isPopUp: true)
        textSearchState()
    }
    
    // This method sets how all the elements of the popup will look
    private func setupViews() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = Catalog.cornerRadius
        self.clipsToBounds = true
        
        background.setupViews(view: self, isPopUp: true, addBlur: false, addDark: true)
        
        bar.backgroundColor = .clear
        bar.contentMode = .scaleToFill
        bar.image = UIImage(named: "bars")
        self.addSubview(bar)
        
        dishImagesView.backgroundColor = .clear
        dishImagesView.isScrollEnabled = true
        dishImagesView.showsHorizontalScrollIndicator = false
        dishImagesView.showsVerticalScrollIndicator = false
        self.addSubview(dishImagesView)
    }
    
    // Sets the contraints
    private func setupInitialLayout() {
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        self.frame.origin.x = 0
        self.frame.origin.y = y[PopUpsState.TextRecognitionState]!
        self.frame.size.width = self.frame.width
        self.frame.size.height = height
        
        bar.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self)).isActive = true
        bar.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self), constant: Catalog.Layout.screenDistance).isActive = true
        bar.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self), constant: -Catalog.Layout.screenDistance).isActive = true
        bar.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        dishImagesView.frame.origin.x = 0
        dishImagesView.frame.origin.y = barHeight
        dishImagesView.frame.size.width = self.frame.width
        dishImagesView.frame.size.height = cellHeight
    }
    
    // State where food item is being searches by the user
    private func textSearchState() {
        Catalog.state = PopUpsState.TextSearchState
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[PopUpsState.TextSearchState]!
            })
        }
    }
    
    // State where the camera is used for scanning menus
    private func textRecognitionState() {
        Catalog.state = PopUpsState.TextRecognitionState
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.frame.origin.y = self.y[PopUpsState.TextRecognitionState]!
            })
        }
    }
    
    // State where some information of food item is being shown
    private func popUpState() {
        Catalog.state = PopUpsState.PopUpState
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.dishImagesView.frame.origin.y = (Catalog.screenSize.height - self.y[PopUpsState.PopUpState]! - self.cellHeight + self.barHeight)/2
                self.frame.origin.y = self.y[PopUpsState.PopUpState]!
                self.background.frame.origin.y = -self.frame.origin.y
            })
        }
    }
    
    // State where everything about the food item is being shown
    private func imagesState() {
        Catalog.state = PopUpsState.ImagesState
        y[PopUpsState.ImagesState] = Catalog.height_ImagesState_Top
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.dishImagesView.frame.origin.y = (Catalog.screenSize.height - self.y[PopUpsState.ImagesState]! - self.cellHeight + self.barHeight)/2 
                self.frame.origin.y = self.y[PopUpsState.ImagesState]!
                self.background.frame.origin.y = -self.frame.origin.y
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
    
    // Function called when lower popup view is tapped
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        Catalog.mainViewController?.recoTableView.isHidden = true
        if (Catalog.mainViewController?.topPopUp.dishName.isFirstResponder)! {
            Catalog.mainViewController?.topPopUp.endEditing(true)
        }
        else {
            if Catalog.state == PopUpsState.PopUpState {
                if sender.state == .ended {
                    imagesState()
                    self.stateChanged?(PopUpsState.ImagesState)
                }
            }
            else if Catalog.state == PopUpsState.ImagesState {
                if sender.state == .ended {
                    popUpState()
                    self.stateChanged?(PopUpsState.PopUpState)
                }
            }
        }
    }
    
    // Function called when lower popup view is panned
    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let location = sender.translation(in: self)

        switch sender.state {
        case .began, .changed:
            background.frame.origin.y -= location.y
            dishImagesView.frame.origin.y -= location.y/2
            frame.origin.y += location.y
            sender.setTranslation(CGPoint.zero, in: self)
        case .ended:
            if (self.frame.origin.y + location.y) < thresholdImages {
                imagesState()
                self.stateChanged?(PopUpsState.ImagesState)
            }
            else if (self.frame.origin.y + location.y) > thresholdText {
                textRecognitionState()
                self.stateChanged?(PopUpsState.TextRecognitionState)
            }
            else {
                popUpState()
                self.stateChanged?(PopUpsState.PopUpState)
            }
        default:
            break
        }
    }
    
    // Function called when images has to be found from google
    private func implementGoogleImageSearch(dish: String) {
        self.dishImages.removeAll()
        
        googleSearch.findImages(forWhat: dish)
        
        googleSearch.imageReceived = { (_ imageArray: [String]) -> () in
            for image in imageArray {
                guard let imageURL: URL = Foundation.URL(string: image) else { return }
                
                URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                    guard let data = data else { return }
                    if (error == nil) {
                        guard let img = UIImage.init(data: data) else { return }
                        self.dishImages.append(img)
                        DispatchQueue.main.async {
                            self.dishImagesView.reloadData()
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
// Everything about the collection view is done here
extension BottomPopUp: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Sets the total cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalCells
    }

    // Sets the cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DishImageCell

        cell.activityIndicator.startAnimating()
        
        if (indexPath.row >= dishImages.count) {
            cell.image.image = nil }
        else {
            cell.image.image = dishImages[indexPath.row]
            cell.activityIndicator.stopAnimating()
        }
        return cell
    }

    // Sets the number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Scroll to a specific cell with animation
    private func scrollToWithAnimation(cellNumber: Int) {
        DispatchQueue.main.async {
            self.dishImagesView.scrollToItem(at: .init(item: cellNumber, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    // Scroll to a specific cell without animation
    private func scrollToWithoutAnimation(cellNumber: Int) {
        DispatchQueue.main.async {
            self.dishImagesView.scrollToItem(at: .init(item: cellNumber, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
}

extension BottomPopUp: UIScrollViewDelegate {
    
    // This sets that cell comes to the middle everytime dragging is done
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = dishImagesView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left)/cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint.init(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
    }
    
    // This sets the scroll view zooming whenever the collection view is scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setCellZooming()
    }
    
    // This sets the whiteness in cells that are not in main view
    private func changeSizeScaleToAlphaScale(_ x : CGFloat) -> CGFloat {
        let minScale : CGFloat = 0.86
        let maxScale : CGFloat = 1.0
        
        let minAlpha : CGFloat = 0.25
        let maxAlpha : CGFloat = 1.0
        
        return ((maxAlpha - minAlpha) * (x - minScale)) / (maxScale - minScale) + minAlpha
    }
    
    // This sets that cell in the middle will be zoomed
    private func setCellZooming() {
        let centerX = dishImagesView.center.x + 50
        
        for cell in dishImagesView.visibleCells {
            // coordinate of the cell in the viewcontroller's root view coordinate space
            let basePosition = cell.convert(CGPoint.zero, to: self)
            let cellCenterX = basePosition.x + dishImagesView.frame.size.width/2.0
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
