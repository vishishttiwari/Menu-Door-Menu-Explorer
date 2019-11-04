//
//  Catalog.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/20/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  This is a catalog from which global values can be taken

import AVFoundation
import UIKit

internal class Catalog {
    
    // Variables for state change in popup views
    static var mainViewController: MainViewController?
    static var state: PopUpsState! = PopUpsState.TextRecognitionState
    static var height_ImagesState_Top: CGFloat! = 0
    
    // Variables for setting up views in the app
    static let ram = ProcessInfo.processInfo.physicalMemory
    static let screenSize = UIScreen.main.bounds.size
    static let animateTime: Double! = 0.3
    static let hiddenThreshold: CGFloat! = 50
    static let cornerRadius: CGFloat! = 20
    static let themeColor: UIColor! = UIColor.init(red: 197/255, green: 10/255, blue: 9/255, alpha: 1)
    
    // Top safe area bottom safe area set when MainViewController is initiailzed. Used for finding top area in iphoneX
    static var topSafeArea: CGFloat! = 0
    static var bottomSafeArea: CGFloat! = 0
    
    // Dark transparency used in app
    struct Dark {
        static let rectangleTransparency: CGFloat! = 0.3
        static let popUpScreenTransparency: CGFloat! = 0.6
        static let otherScreenTransparency: CGFloat! = 0.4
        static let buttonsTransparency: CGFloat! = 0.75
    }
    
    // Different font sizes used in app
    struct FontSize {
        static let backButtonFontSize: CGFloat! = 30
        static let normalButtonFontSize: CGFloat! = 20
        static let smallButtonFontSize: CGFloat! = 15
        static let longDataFontSize: CGFloat! = 15
        static let titleFontSize: CGFloat! = 25
    }
    
    // Dimensions of back button used in app
    struct BackButtonDimensions {
        static let distanceFromLeftRight: CGFloat! = 20
        static let height: CGFloat! = 70
        static let distanceFromBottom: CGFloat! = 20
    }
    
    // Background image of popup
    struct PopUpsBackgroundImage {
        static var photoNumberForPopUps: Int = Int.random(in: 0..<21)
        static func generateRandomPhotoNumber() {
            photoNumberForPopUps = Int.random(in: 0..<21)
        }
    }
    
    
    
    
    // Sets different layout values for contraints
    struct Layout {
        static let screenDistance: CGFloat! = 20
        static let betweenElementsDistance: CGFloat! = 10
    }
    struct Recommendation {
        static let recoCellId = "cellId"
        static let recoCellHeight: CGFloat! = 40
    }
    struct MainScreen {
        static let barHeight: CGFloat! = Catalog.topSafeArea + Catalog.MainScreen.applicationNameHeight + Catalog.MainScreen.screenDistanceFromTopForName
        static let buttonsDimensions: CGFloat! = 30
        static let applicationNameHeight: CGFloat! = 50
        static let applicationNameWidth: CGFloat! = Catalog.screenSize.width - (2 * buttonsDimensions)
        static let screenDistanceFromTopBottom: CGFloat! = 10
        static let screenDistanceFromLeftRight: CGFloat! = 10
        static let screenDistanceFromTopForName: CGFloat! = 0
        static let helpLabelHeight: CGFloat! = 50
    }
    struct PopUps {
        static let screenDistanceFromTop: CGFloat! = 15 + Catalog.hiddenThreshold + Catalog.topSafeArea
        static let screenDistanceFromBottom: CGFloat! = 20 + Catalog.bottomSafeArea
        static let screenDistanceFromTopWithoutSafeArea: CGFloat! = 10 + Catalog.hiddenThreshold
        static let betweenElementsDistance: CGFloat! = 20
    }
    
    
    // This is to get constraints. This app works in iOS 10 or above so for
    // iOS 10 to workm the following functions were created to get contraints
    struct Contraints {
        static func getTopAnchor(view: UIView) -> NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.topAnchor }
            else {
                return view.topAnchor }
        }
        static func getBottomAnchor(view: UIView) -> NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.bottomAnchor }
            else {
                return view.bottomAnchor }
        }
        static func getLeftAnchor(view: UIView) -> NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.leftAnchor }
            else {
                return view.leftAnchor }
        }
        static func getRightAnchor(view: UIView) -> NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.rightAnchor }
            else {
                return view.rightAnchor }
        }
        static func getCenterYAnchor(view: UIView) -> NSLayoutYAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.centerYAnchor }
            else {
                return view.centerYAnchor }
        }
        static func getCenterXAnchor(view: UIView) -> NSLayoutXAxisAnchor {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide.centerXAnchor }
            else {
                return view.centerXAnchor }
        }
    }
    
    // Created alert in the app
    static func alert(title: String, message: String) {
        AnalyticsWrapper.Alert.sendAnalytics(title: title, description: message)
        
        guard let mainViewController = self.mainViewController else { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        mainViewController.present(alert, animated: true, completion: nil)
    }
    
    // When a dish is not found, the following alert view controller is generated.
    // It gives an option of googling the dish
    static func dishNotFound(dish: String) {
        guard let mainViewController = self.mainViewController else { return }
        
        let alert = UIAlertController(title: "Dish not recognized", message: "We could not recognize this dish. Would you like to search results on Google?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Google", style: .default, handler: { (action) in
            AnalyticsWrapper.DishNotFoundAlert.sendAnalytics(dish: dish, googlePressed: true, cancelPressed: false)
            
            guard let url = URL(string: "https://www.google.com/search?q=\(dish.replacingOccurrences(of: " ", with: "%20"))") else { return }
            UIApplication.shared.open(url)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            AnalyticsWrapper.DishNotFoundAlert.sendAnalytics(dish: dish, googlePressed: false, cancelPressed: true)
        }))
        mainViewController.present(alert, animated: true, completion: nil)
    }
    // This function asks for camera permission
    static func askCameraPermission(viewController: UIViewController) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            return
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    return
                } else {
                    DispatchQueue.main.async {
                        let controller = AllowCameraViewController()
                        
                        controller.modalTransitionStyle = .coverVertical
                        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        
                        viewController.present(controller, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    // This dismisses the keyboard and recommendation table
    static func closeKeyboardAndRecommendations(view: UIView) {
        Catalog.mainViewController?.recoTableView.isHidden = true
        if (mainViewController?.topPopUp.dishName.isFirstResponder)! {
            view.endEditing(true)
        }
    }
    // Resize Image    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}















// This is used for caching images
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCache(url: String, available: Bool = true) {
        if (url.count == 0) { return }
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            if (available) {
                self.image = cachedImage
            } else {
                let originalImage = cachedImage
                self.image = grayScale(originalImage: originalImage)
            }
            return
        }
        
        guard let imageURL: URL = Foundation.URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data else { return }
            if (error == nil) {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage.init(data: data) {
                        imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                        
                        if (available) {
                            self.image = downloadedImage
                        } else {
                            let originalImage = downloadedImage
                            self.image = self.grayScale(originalImage: originalImage)
                        }
                    }
                }
            }
        }.resume()
    }
    
    // To make an image grayscale
    func grayScale(originalImage: UIImage) -> UIImage {
        
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")
        currentFilter!.setValue(CIImage(image: originalImage), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        return UIImage(cgImage: cgimg!)
    }
}

// This extension is used to add blue and dark background to views
extension UIView {
    func addBlurInBackground() {
        let blurView = UIVisualEffectView(effect:  UIBlurEffect.init(style: .dark))
        blurView.frame = self.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
    }
    
    func addDarkInBackground(alpha: CGFloat) {
        let darkView = UIView()
        darkView.backgroundColor = UIColor.black.withAlphaComponent(alpha)
        darkView.frame = self.frame
        darkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(darkView)
    }
}

// This extension adds round corners to recommendation table view controller in a UIView
extension UIView {
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

// This adds blue to a uiviewcontroller
extension UIViewController {
    func addBlurInBackground() {
        let blurView = UIVisualEffectView(effect:  UIBlurEffect.init(style: .dark))
        blurView.frame = self.view.frame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
    }
}

// This capitalizes the first letter in word
extension String {
    func capitalizingFirstWord() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    func capitalizeEveryWord() -> String {
        if count == 0 {
            return self
        }
        let words = split(separator: " ")
        var newString: String = ""
        for word in words {
            newString += "\(word.prefix(1).uppercased() + word.lowercased().dropFirst()) "
        }
        return "" + newString.dropLast()
    }
}

// This function is called to scroll the table view to the top whenever the table view is shown
extension UITableView {
    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }
    enum scrollsTo {
        case top,bottom
    }
}











// This initializes the back button
internal class BackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupViews(view: UIView, titleColor: UIColor) {
        self.setTitle("Back", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: Catalog.FontSize.backButtonFontSize, weight: UIFont.Weight.light)
        if titleColor == .white {
            self.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        }
        else if titleColor == .black {
            self.backgroundColor = UIColor.white
        }
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = Catalog.cornerRadius
        self.clipsToBounds = true
        view.addSubview(self)
    }
    
    internal func setupLayout(view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: view), constant: Catalog.BackButtonDimensions.distanceFromLeftRight).isActive = true
        self.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: view), constant: -Catalog.BackButtonDimensions.distanceFromLeftRight).isActive = true
        self.heightAnchor.constraint(equalToConstant: Catalog.BackButtonDimensions.height).isActive = true
        self.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: view), constant: -Catalog.BackButtonDimensions.distanceFromBottom).isActive = true
    }
    
    // When back button is clicked, the following animation is shown
    internal func clicked() {
        if self.backgroundColor == .white {
            self.backgroundColor = .black
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.backgroundColor = UIColor.white
            })
        }
        else {
            self.backgroundColor = .white
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
            })
        }
    }
}






// This sets the background images of different views of the application with images
internal class BackgroundImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    internal func setupViews(view: UIView, isPopUp: Bool, addBlur: Bool, addDark: Bool) {
        self.image = getImage(isPopUp: isPopUp)
        self.contentMode = .scaleAspectFit
        if addBlur {
            self.addBlurInBackground()
        }
        if addDark {
            if isPopUp {
                self.addDarkInBackground(alpha: Catalog.Dark.popUpScreenTransparency) }
            else {
                self.addDarkInBackground(alpha: Catalog.Dark.otherScreenTransparency) }
        }
        view.addSubview(self)
    }
    
    internal func resetViews(isPopUp: Bool) {
        self.image = getImage(isPopUp: isPopUp)
    }
    
    // This created image so that the image fits in the background of the view without stretching the image.
    // It crops the image accordingly
    private func getImage(isPopUp: Bool) -> UIImage {
        var image: UIImage!
        if isPopUp {
            image = UIImage.init(named: "\(Catalog.PopUpsBackgroundImage.photoNumberForPopUps).jpg")
        }
        else {
            image = UIImage.init(named: "\(Int.random(in: 0..<21)).jpg")
        }
        
        let width = Double((image?.size.width)!)
        let height = Double((image?.size.height)!)
        
        let screenWidth = Double(UIScreen.main.bounds.width)
        let screenHeight = Double(UIScreen.main.bounds.height)
        
        if ((width/height) > (screenWidth/screenHeight)) {
            let newWidth = (screenWidth/screenHeight) * height
            let difference = width - newWidth
            let rect = CGRect.init(x: Double(difference/2), y: Double(0), width: newWidth, height: height)
            let imageRef:CGImage = (image?.cgImage!.cropping(to: rect)!)!
            let cropped:UIImage = UIImage(cgImage:imageRef)
            return cropped
        }
        else {
            let newHeight = (screenHeight/screenWidth) * width
            let difference = height - newHeight
            let rect = CGRect.init(x: Double(0), y: Double(difference/2), width: width, height: newHeight)
            let imageRef:CGImage = (image?.cgImage!.cropping(to: rect)!)!
            let cropped:UIImage = UIImage(cgImage:imageRef)
            return cropped
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




// This is used to initialize button like speak button and ingredients button
internal class SpecialButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupButtons(view: UIView, buttonName: String) {
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3/UIScreen.main.nativeScale
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16)
        setImage(UIImage.init(named: "\(buttonName).png"), for: .normal)
        setImage(UIImage.init(named: "\(buttonName)Clicked.png"), for: .selected)
        backgroundColor = .clear
        
        view.addSubview(self)
    }
    
    // Click animation of the button is done here
    internal func clicked() {
        self.backgroundColor = .white
        UIView.animate(withDuration: Catalog.animateTime, animations: {
            self.backgroundColor = UIColor.clear
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = UIColor.white.cgColor
    }
}
