//
//  MainViewController.swift
//  Menu Door
//
//  Created by Vishisht Tiwari on 5/14/19.
//  Copyright © 2019 Vishisht Tiwari. All rights reserved.
//
//  Original screen in MainViewContoller which has camera and all other views
//

import UIKit
import AVFoundation
import paper_onboarding

class MainViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // Initialization of variables for camera
    private var captureSession = AVCaptureSession()
    private var backCamera:AVCaptureDevice?
    private var frontCamera:AVCaptureDevice?
    private var currentCamera:AVCaptureDevice?
    private var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    
    // Initialization of timer variables. Decides the frequency with which text recognition occurs
    private var timer: Timer!
    private var countDown: TimeInterval! = 0.5
    
    // This is used to get image from buffer
    private let context = CIContext()
    private var image: UIImage?
//    private var imageFrame: CGRect = CGRect.init(x: 0, y: (Catalog.screenSize.height - 640)/2, width: 480, height: 640)
    private var imageFrame: CGRect?
    private var imageView: UIView!
    private var helpLabel: UILabel! = UILabel()
    
    // Used for the rectangle created for text detection
    private var words: [WordFound] = []
    
    // Initialization of UI Element in MainViewController
    private let topBar: UIView! = UIView()
    private let bottomBar: UIView! = UIView()
    private let applicationName: UIImageView! = UIImageView()
    private let dishSearch: UIButton! = UIButton()
    private let options: UIButton! = UIButton()
    private let flash: UIButton! = UIButton()
    private var flashToggle: Bool! = false
    internal var bottomPopUp: BottomPopUp!
    internal var topPopUp: TopPopUp!
    internal var recoTableView: UITableView!
    internal var ingredientsView: IngredientsView!
    internal var ingredientDescription: IngredientDescriptionView!
    private var optionsView: OptionsView!
    internal var reportView: ReportView!
    internal var disclaimerView: DisclaimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (Catalog.ram < 2500000000) {
            countDown = 1
        }
        
        self.view.backgroundColor = Catalog.themeColor
        
        Catalog.mainViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        Catalog.askCameraPermission(viewController: self)
        
        // This is used to set safe area in the app. Specially useful in notches where safe area is extended due to notches and bar at the bottom.
        setTopBottomSafeArea()
        
        // Setup the frame where the image will be showed
        imageFrame = CGRect.init(x: 0, y: Catalog.MainScreen.barHeight, width: Catalog.screenSize.width, height: Catalog.screenSize.height - (2*Catalog.MainScreen.barHeight))
        
        // Setting up the dimensions of views
        recoTableView = UITableView()
        bottomPopUp = BottomPopUp.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
        topPopUp = TopPopUp.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
        ingredientsView = IngredientsView.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
        ingredientDescription = IngredientDescriptionView.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
        optionsView = OptionsView.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
        reportView = ReportView.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
        disclaimerView = DisclaimerView.init(frame: CGRect.init(x: 0, y: 0, width: Catalog.screenSize.width, height: Catalog.screenSize.height))
    
        // Setup the views of different button
        self.view.backgroundColor = .black
        setupCamera()
        setupTopBottomBars()
        setupSearchButton()
        setupOptionsButton()
        setupFlashButton()
        setupApplicationName()
        setupPopUpViews()
        setupRecommendationTable()
        self.view.addSubview(ingredientsView)
        self.view.addSubview(ingredientDescription)
        self.view.addSubview(optionsView)
        self.view.addSubview(reportView)
        self.view.addSubview(disclaimerView)

        // Add gesture recognizer to view to close the popup windows
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    // Sets up the top and bottom safe area specially for notches
    private func setTopBottomSafeArea() {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            Catalog.topSafeArea = safeFrame.minY
            Catalog.bottomSafeArea = window.frame.maxY - safeFrame.maxY
        }
        else {
            Catalog.topSafeArea = topLayoutGuide.length
            Catalog.bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    // Hides the time and network icon at top of screen
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Setup the camera by setting the view and camera etc.
    private func setupCamera() {
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        imageView = UIView.init(frame: imageFrame!)
        
        // This sets the help view at the bottom to help user
        self.view.addSubview(helpLabel)
        helpLabel.text = "Point the camera at a menu."
        helpLabel.alpha = 1
        helpLabel.backgroundColor = UIColor.black.withAlphaComponent(Catalog.Dark.buttonsTransparency)
        helpLabel.layer.borderColor = UIColor.black.cgColor
        helpLabel.layer.borderWidth = 1
        helpLabel.numberOfLines = 0
        helpLabel.textColor = .white
        helpLabel.layer.cornerRadius = Catalog.cornerRadius
        helpLabel.textAlignment = .center
        helpLabel.clipsToBounds = true
        
        // Sets the help label constraints
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(Catalog.MainScreen.barHeight + 20)).isActive = true
        helpLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: Catalog.MainScreen.screenDistanceFromLeftRight).isActive = true
        helpLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -Catalog.MainScreen.screenDistanceFromLeftRight).isActive = true
        helpLabel.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.helpLabelHeight).isActive = true
        
        runTimer()
    }
    
    // Setup top and bottom bar
    private func setupTopBottomBars() {
        self.view.addSubview(topBar)
        self.view.addSubview(bottomBar)
        
        topBar.backgroundColor = Catalog.themeColor
        bottomBar.backgroundColor = Catalog.themeColor
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        topBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        topBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.barHeight).isActive = true
        
        bottomBar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        bottomBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        bottomBar.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.barHeight).isActive = true
    }
    
    // Setup the name logo at the top
    private func setupApplicationName() {
        self.view.addSubview(applicationName)
        
        applicationName.image = UIImage.init(named: "applicationName")
        applicationName.contentMode = .scaleAspectFit
        applicationName.backgroundColor = .clear
        
        applicationName.translatesAutoresizingMaskIntoConstraints = false
        
        applicationName.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self.view), constant: Catalog.MainScreen.screenDistanceFromTopForName).isActive = true
        applicationName.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        applicationName.widthAnchor.constraint(equalToConstant: Catalog.MainScreen.applicationNameWidth).isActive = true
        applicationName.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.applicationNameHeight).isActive = true
    }
    
    // Setup the poup views
    private func setupPopUpViews() {
        self.view.addSubview(topPopUp)
        self.view.addSubview(bottomPopUp)
        
        bottomPopUp.stateChanged = { (_ state: PopUpsState) -> () in
            self.topPopUp.changeState(state: state)
        }
        topPopUp.stateChanged = { (_ state: PopUpsState) -> () in
            self.bottomPopUp.changeState(state: state)
        }
    }
    
    // Setup the recommendation table
    private func setupRecommendationTable() {
        self.view.addSubview(recoTableView)
        
        recoTableView.isHidden = true
        recoTableView.backgroundColor = .darkGray
        recoTableView.rowHeight = Catalog.Recommendation.recoCellHeight
        recoTableView.clipsToBounds = true
        recoTableView.isScrollEnabled = false
        if (UIDevice.current.model.range(of: "iPhone") != nil) {
            recoTableView.roundCorners([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: Catalog.cornerRadius)
        }
        recoTableView.separatorStyle = .none
        
        let tapRecommendation = UITapGestureRecognizer(target: self, action: #selector(self.handleTapRecommendation(_:)))
        recoTableView.addGestureRecognizer(tapRecommendation)
        
        recoTableView.register(RecommendationCell.self, forCellReuseIdentifier: Catalog.Recommendation.recoCellId)
        recoTableView.dataSource = self
        recoTableView.delegate = self
        
        recoTableView.frame.origin.x = Catalog.Layout.screenDistance
        recoTableView.frame.origin.y = Catalog.MainScreen.barHeight + 15
        recoTableView.frame.size.width = self.view.frame.width - 2*(Catalog.Layout.screenDistance)
        recoTableView.frame.size.height = 0
    }
    
    // Setup the search button
    private func setupSearchButton() {
        self.view.addSubview(dishSearch)
        
//        let logos: [String] = ["searchMenu.png", "searchFries.png", "searchChinese.png"]
//        dishSearch.setImage(UIImage.init(named: logos[Int.random(in: 0..<3)]), for: .normal)
        
        dishSearch.setImage(UIImage.init(named: "search"), for: .normal)
        dishSearch.backgroundColor = .clear
        
        dishSearch.translatesAutoresizingMaskIntoConstraints = false
        dishSearch.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self.view), constant: Catalog.MainScreen.screenDistanceFromTopBottom).isActive = true
        dishSearch.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self.view), constant: -Catalog.MainScreen.screenDistanceFromLeftRight).isActive = true
        dishSearch.widthAnchor.constraint(equalToConstant: Catalog.MainScreen.buttonsDimensions).isActive = true
        dishSearch.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.buttonsDimensions).isActive = true
        
        dishSearch.addTarget(self, action: #selector(search), for: .touchUpInside)
    }
    
    // Setup the options button
    private func setupOptionsButton() {
        self.view.addSubview(options)
        
        options.setImage(UIImage.init(named: "options.png"), for: .normal)
        options.setImage(UIImage.init(named: "optionsClicked.png"), for: .selected)
        options.backgroundColor = .clear
        
        options.translatesAutoresizingMaskIntoConstraints = false
        options.topAnchor.constraint(equalTo: Catalog.Contraints.getTopAnchor(view: self.view), constant: Catalog.MainScreen.screenDistanceFromTopBottom).isActive = true
        options.leftAnchor.constraint(equalTo: Catalog.Contraints.getLeftAnchor(view: self.view), constant: Catalog.MainScreen.screenDistanceFromLeftRight).isActive = true
        options.widthAnchor.constraint(equalToConstant: Catalog.MainScreen.buttonsDimensions).isActive = true
        options.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.buttonsDimensions).isActive = true
        
        options.addTarget(self, action: #selector(optionsShow), for: .touchUpInside)
    }
    
    // Setup up the flash button
    private func setupFlashButton() {
        self.view.addSubview(flash)
        
        flash.setImage(UIImage.init(named: "flashOff.png"), for: .normal)
        flash.backgroundColor = .clear
        
        flash.translatesAutoresizingMaskIntoConstraints = false
        flash.bottomAnchor.constraint(equalTo: Catalog.Contraints.getBottomAnchor(view: self.view), constant: -Catalog.MainScreen.screenDistanceFromTopBottom).isActive = true
        flash.rightAnchor.constraint(equalTo: Catalog.Contraints.getRightAnchor(view: self.view), constant: -Catalog.MainScreen.screenDistanceFromLeftRight).isActive = true
        flash.widthAnchor.constraint(equalToConstant: Catalog.MainScreen.buttonsDimensions).isActive = true
        flash.heightAnchor.constraint(equalToConstant: Catalog.MainScreen.buttonsDimensions).isActive = true
        
        flash.addTarget(self, action: #selector(flashPressed), for: .touchUpInside)
    }
    
    // This timer is called every 0.5s to refresh the rectangles
    private func runTimer() {
        // Setup the timer. When it reached 0, it will call the countDownAction method
        timer = Timer.scheduledTimer(timeInterval: countDown, target: self, selector: #selector(implementTextRecognition), userInfo: nil, repeats: false)
    }
    
    // This method is called when the timer reaches to 0. Rectangles are updated depending on the response from TextRecignition.
    // TextRecognition responds with with dishes and the coordinates of the reactangles
    @objc private func implementTextRecognition() {
        if image != nil && Catalog.state == PopUpsState.TextRecognitionState {
            let textRecognition = TextRecognition()
            textRecognition.runTextRecognition(with: Catalog.resizeImage(image: image!, targetSize: CGSize.init(width: imageFrame!.width, height: imageFrame!.height)))
            textRecognition.textRecognized = { (_ texts: [String], _ rects: [CGRect]) -> () in
                self.removeRectangles()
                for i in 0..<texts.count {
                    self.words.append(self.createWordFound(text: texts[i], rect: rects[i]))
                }
                self.updateRectangle()
            }
        }
        else {
            self.removeRectangles()
        }
        runTimer()
    }
    
    // This function creates an object of word found. The object contains text and rectangle coordinates.
    private func createWordFound(text: String, rect: CGRect) -> WordFound {
        let rectangle = UIImageView()
        rectangle.frame = rect
        rectangle.backgroundColor = UIColor.white.withAlphaComponent(Catalog.Dark.rectangleTransparency)
        rectangle.isOpaque = false
        rectangle.layer.borderColor =  UIColor.black.cgColor
        rectangle.layer.borderWidth = 0.5
        rectangle.layer.cornerRadius = 5
        rectangle.layer.masksToBounds = true
        
        return WordFound.init(text: text, rectangle: rect, rectangleImage: rectangle)
    }
    
    // This function removes all rectangles from the screen
    private func removeRectangles() {
        for word in words {
            word.rectangleImage?.removeFromSuperview()
        }
        words.removeAll()
    }
    
    // This updates the rectangle on the screen depending on the text recognized on screen
    private func updateRectangle() {
        if words.count == 0 {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.helpLabel.text = "No dish found. Point the camera at a menu"
            })
        }
        else {
            UIView.animate(withDuration: Catalog.animateTime, animations: {
                self.helpLabel.text = "Tap the dish to know more about it"
            })
        }
        for word in words {
            cameraPreviewLayer?.addSublayer(word.rectangleImage.layer)
        }
    }
    
    // If the tap is on rectangle then open the dish information.
    // If the popups are open then shut the popups by touching on the main view controller screen
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        recoTableView.isHidden = true
        if topPopUp.dishName.isFirstResponder {
            topPopUp.endEditing(true)
        }
        else {
            var location = sender.location(in: self.view)
            if Catalog.state == PopUpsState.TextRecognitionState {
//                location = self.imageView.convert(location, from: self.view)
                location.y -= Catalog.MainScreen.barHeight
                if sender.state == .ended {
                    for word in words {
                        // If tap is on rectangle then find the information on the dish
                        if word.rectangle.contains(location) {
                            AnalyticsWrapper.DishTapped.sendAnalytics(dish: word.text)
                            
                            dishTextRecognized(dish: word.text)
                        }
                    }
                }
            }
            else if Catalog.state == PopUpsState.PopUpState || Catalog.state == PopUpsState.TextSearchState {
                if sender.state == .ended {
                    topPopUp.changeState(state: PopUpsState.TextRecognitionState)
                    bottomPopUp.changeState(state: PopUpsState.TextRecognitionState)
                }
            }
        }
    }
    
    // This function is called when a dish is pressed. This calls the popups to show information about the dish.
    private func dishTextRecognized(dish: String) {
        Catalog.PopUpsBackgroundImage.generateRandomPhotoNumber()
        
        topPopUp.dishTextRecognized(dish: dish)
        bottomPopUp.dishTextRecognized(dish: dish)
    }
    
    // To search for a dish
    @objc func search() {
        AnalyticsWrapper.Button.sendAnalytics(button: AnalyticsWrapper.Button.Buttons.Search, dish: "")
        
        topPopUp.dishName.becomeFirstResponder()
        
        if Catalog.state == PopUpsState.TextRecognitionState {
            Catalog.PopUpsBackgroundImage.generateRandomPhotoNumber()
        }
        
        topPopUp.dishTextStartEditing()
        bottomPopUp.dishTextStartEditing()
    }
    
    // To show options
    @objc func optionsShow() {
        AnalyticsWrapper.Button.sendAnalytics(button: AnalyticsWrapper.Button.Buttons.Options, dish: "")
        
        Catalog.closeKeyboardAndRecommendations(view: self.view)
        optionsView.present()
    }
    
    // To toggle flash
    @objc func flashPressed() {
        AnalyticsWrapper.Button.sendAnalytics(button: AnalyticsWrapper.Button.Buttons.Flash, dish: "")
        
        guard let device = currentCamera else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
        
        flashToggle = !flashToggle
        if flashToggle {
            flash.setImage(UIImage.init(named: "flashOn.png"), for: .normal)
        }
        else {
            flash.setImage(UIImage.init(named: "flashOff.png"), for: .normal)
        }
    }
}






// All the camera stuff is here
extension MainViewController {
    // This method is used to capture flow of data from input devices
    private func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.vga640x480
    }
    
    // This method sets up the camera device
    private func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera // Set the currentCamera as back camera as only that will be used
    }
    
    // This method sets up the input and output format and device
    private func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)               // This sets the camera as AVCaptureInput
            guard captureSession.canAddInput(captureDeviceInput) else { return }                    // This checks if the camera can be added as input. Basically if it is being used by something else or not.
            captureSession.addInput(captureDeviceInput)                                             // If the camera be added as an input then it is added as input
            
            let videoOutput = AVCaptureVideoDataOutput()                                            // Initialize the output of video
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer")) // Capturing the frame is handeled by a different thread
            guard captureSession.canAddOutput(videoOutput) else { return }                          // If this output can be added then add it.
            captureSession.addOutput(videoOutput)
            
            guard let connection = videoOutput.connection(with: AVFoundation.AVMediaType.video) else { return }
            guard connection.isVideoOrientationSupported else { return }
            connection.videoOrientation = .portrait
        } catch {
            print(error)
        }
    }
    
    // This method sets up the preview layer on the view controller to show the images
    private func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resize
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait   // Only Potrait is aloud
        cameraPreviewLayer?.frame = self.imageFrame!                                             // Set the size of the video display
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)                              // Show video on the viewController
    }
    
    // This method starts the session of capturing frames from camera and showing it on screen
    private func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        image = imageFromSampleBuffer(sampleBuffer: sampleBuffer)
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}



// The recommendation table is implemented here
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topPopUp.searchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Catalog.Recommendation.recoCellId, for: indexPath) as! RecommendationCell
        cell.recommendation.text = topPopUp.searchedArray[indexPath.row]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This handles the tap. If a recommendation is tapped then the word goes into the text field and is then searched
    @objc func handleTapRecommendation(_ sender: UITapGestureRecognizer){
        if let indexPath = Catalog.mainViewController?.recoTableView.indexPathForRow(at: sender.location(in: Catalog.mainViewController?.recoTableView)) {
            let cell = Catalog.mainViewController?.recoTableView.cellForRow(at: indexPath) as! RecommendationCell
            if sender.state == .ended {
                var newText = ""
                if topPopUp.dishName.text!.components(separatedBy: " ").count > 1 {
                    newText = "\(topPopUp.dishName.text!.components(separatedBy: " ").dropLast().joined(separator: " ")) \(cell.recommendation.text!.capitalizingFirstWord())"
                }
                else {
                    newText = "\(cell.recommendation.text!.capitalizingFirstWord())"
                }
                topPopUp.dishName.text = newText
                Catalog.closeKeyboardAndRecommendations(view: self.view)
                
                if !TextRecognition.isDish(words: newText) {
                    topPopUp.changeState(state: PopUpsState.TextSearchState)
                    bottomPopUp.changeState(state: PopUpsState.TextSearchState)
                    Catalog.dishNotFound(dish: newText)
                }
                else {
                    dishTextRecognized(dish: newText)
                    Catalog.mainViewController?.bottomPopUp.dishTextRecognized(dish: newText)
                }
            }
        }
    }
}
