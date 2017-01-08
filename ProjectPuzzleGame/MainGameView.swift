//
//  MainGameView.swift
//  ProjectPuzzleGame
//
//  Created by Tri Tran on 11/2/16.
//  Copyright © 2016 Tri Tran. All rights reserved.
//

import UIKit
//import GoogleMobileAds
let screenSize: CGRect = UIScreen.main.bounds

class MainGameView: UIViewController {
    
    private var widthCell:CGFloat = 0
    private var heightCell:CGFloat = 0
    private let xStart:CGFloat = 40
    private let ratio:CGFloat = 139/568
    private let yStart:CGFloat = screenSize.size.height * 0.2
    private var direction:CGFloat = 0
    private var manage:ManageSquare = ManageSquare()
    var row:CGFloat = 0
    var col:CGFloat = 0
    var typeMap:CGFloat=0
    var numberStep: CGFloat = 0
    var yFirst: CGFloat = 0
    
    @IBOutlet weak var constraintHeightBanner: NSLayoutConstraint!

    @IBOutlet weak var constraintWidthBanner: NSLayoutConstraint!
//    @IBOutlet weak var bannerAds: GADBannerView!
    ///
    private var arrImageView:[UIImageView] = []
    
    var imagemain: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupBanner()
        yFirst = (170/568)*UIScreen.main.bounds.size.height
        var xFirst:CGFloat = 0
        if UIScreen.main.bounds.size.width > 500 {
            print ("width size ipad = \(UIScreen.main.bounds.size.width)")
            xFirst = (65/320)*UIScreen.main.bounds.size.width
            
        } else {
            xFirst = (32/320)*UIScreen.main.bounds.size.width
            
        }
        
        
        print ("height = \(UIScreen.main.bounds.size.height)")
        print ("width = \(UIScreen.main.bounds.size.width)")

        //self.widthCell = manage.ManageSquare(col: col, row: row, xFrist: xFirst, yFirst: yFirst , image: imagemain!,completion:)
        self.widthCell = manage.ManageSquare(col: col, row: row, xFrist: xFirst, yFirst: yFirst, image: imagemain) { (arrImage) in
            weak var weakSelf = self
            weakSelf?.arrImageView = arrImage
            
            for t in 0...(weakSelf?.arrImageView.count)!-1   {
                if t==0 {
                    let viewWhite  = UIImageView(frame: (weakSelf?.arrImageView[t].frame)!)
                    viewWhite.image = weakSelf?.manage.fromColor(color: .white)
                    weakSelf?.view.addSubview(viewWhite)
                    
                    
                    
                }
                weakSelf?.view.addSubview((weakSelf?.arrImageView[t])!)
            }            
        }
        let heightImage = (self.widthCell*2)*237/940
        let imageViewPuzzle = UIImageView(frame: CGRect(x: xFirst + self.widthCell + 1 , y: yFirst + self.widthCell - heightImage - 5, width: self.widthCell*2, height: heightImage))
        imageViewPuzzle.image = UIImage(named: "IconGame")
        self.view.addSubview(imageViewPuzzle)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // function
    
//    func setupBanner () {
//        if UIScreen.main.bounds.size.width > 500 {
//            constraintHeightBanner.constant = 90
//            constraintWidthBanner.constant = 728
//            bannerAds.adSize = kGADAdSizeLeaderboard
//            
//        } else {
//            constraintHeightBanner.constant = 50
//            constraintWidthBanner.constant = 320
//            bannerAds.adSize = kGADAdSizeBanner
//        }
//        
//        bannerAds.adUnitID = "ca-app-pub-9528547388455539/7119486403"
//        bannerAds.delegate = self
//        bannerAds.rootViewController = self
//        
//        
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
//        bannerAds.load(request)
//        self.view.setNeedsUpdateConstraints()
//    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
            newSize = CGSize (width: targetSize.width, height: widthRatio*size.height)
        let rect =  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @IBAction func actionBack(_ sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func actionRandom(_ sender: AnyObject) {
        resetUI()
        
        let arrListPoint:[ObjectPointDirection] = manage.getListRandomWalk(length: 17)
        for temp in arrListPoint {
            updateUIRandomWalk(point: temp.point, direction: temp.direction)
            
        }
        self.numberStep = 17

    }
    
    @IBAction func actionHelp(_ sender: AnyObject) {
        let arrListPoint:[ObjectPointDirection] = manage.getListSolutionNotFind()
            //manage.getListSolution2(numberStep: self.numberStep)
        print ("so buoc \(arrListPoint.count)")
        
        self.updateUI2(arrPoint: arrListPoint, index: 0)
        self.numberStep = 0
        
    }
    
    @IBAction func actionShareFB (_ sender: AnyObject) {
        let newImage: UIImage = self.captureScreen()
        
        let cropRect = CGRect(x: 0, y: yFirst-5, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-yFirst-50+5)
        let imageCrop = newImage.cgImage?.cropping(to: cropRect)
        
        let image : UIImage = UIImage(cgImage: imageCrop!)
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [image], applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        activityViewController.popoverPresentationController?.permittedArrowDirections = .any
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        

        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    /////
    
    func generatorListImage(size:Int) -> [UIImageView] {
        var arrImages = [UIImageView]()
        for _ in 0...size {
            let tempImage:UIImageView = UIImageView.init(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
            arrImages.append(tempImage)
        }
        return arrImages
        
    }
    
    func captureScreen () -> (UIImage) {
        let keyWindow = UIApplication.shared.keyWindow
        let rect = keyWindow?.bounds
        UIGraphicsBeginImageContext((rect?.size)!)
        let context = UIGraphicsGetCurrentContext()
        keyWindow?.layer.render(in: context!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
    
    ////
    
    func resetUI () {
        let arrImageReset : [UIImageView] = manage.getListImageWhenReset()
        
        for i in 0...arrImageReset.count-1 {
            arrImageView[i].removeFromSuperview()
            arrImageView[i] = arrImageReset[i]
            self.view.addSubview(arrImageView[i])
            
        }
    }
    
    func updateUI(arrPoint: [CGPoint]) {
        for tempPoint in arrPoint {
            for temp in arrImageView {
                if temp.frame.contains(tempPoint) {
                    
                    UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options:UIViewAnimationOptions.allowUserInteraction, animations: {
                        let index = self.arrImageView.index(of: temp)
                        self.arrImageView[index!] = self.moveImage(image: temp)
                    }) { (succeess) in
                        
                    }
                }
            }
        }
    }

    func updateUI(point: CGPoint,direction : CGFloat) {
            for temp in arrImageView {
                if temp.frame.contains(point) {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options:UIViewAnimationOptions.allowUserInteraction, animations: {
                        let index = self.arrImageView.index(of: temp)
                        self.arrImageView[index!] = self.moveImage(image: temp,direction:direction)
                    }) { (succeess) in
                        
                    }
                }
            }
    }
    
    func updateUIRandomWalk(point: CGPoint,direction : CGFloat) {
        for temp in arrImageView {
            if temp.frame.contains(point) {
                    let index = self.arrImageView.index(of: temp)
                    self.arrImageView[index!] = self.moveImage(image: temp,direction:direction)
            }
        }
    }
    
    
    func updateUI2(arrPoint: [ObjectPointDirection], index:Int) {
        if index < arrPoint.count {
            
            let tempPoint = arrPoint[index].point
            let direction = arrPoint[index].direction
            let nextIndex = index+1
            
            for temp in arrImageView {
                if temp.frame.contains(tempPoint) {
                    
                    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 0, options:UIViewAnimationOptions.allowUserInteraction, animations: {
                        let index = self.arrImageView.index(of: temp)
                        self.arrImageView[index!] = self.moveImage(image: temp,direction:direction)
                    }) { (succeess) in
                        self.updateUI2(arrPoint: arrPoint, index: nextIndex)
                    }
                }
            }

            
        } else {
            return
        }
    }

    
    func moveImage (image: UIImageView, direction: CGFloat) ->(UIImageView) {
        let newFrame = image.frame
        var nextFrame: CGRect = CGRect()
        if direction == 0 { // di chuyen qua phai
            
            nextFrame = CGRect(x: newFrame.origin.x + self.widthCell + 1, y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)
            
        } else if direction == 1 { // di chuyen qua trai
            
            nextFrame = CGRect(x: newFrame.origin.x - self.widthCell - 1, y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)
            
        } else if direction == 2 { // di chuyen len tren
            
            nextFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y-self.widthCell - 1, width: newFrame.size.width, height: newFrame.size.height)
            
        } else if direction == 3 {// di chuyen xuong duoi
            
            nextFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y+self.widthCell + 1, width: newFrame.size.width, height: newFrame.size.height)
            
        }
        
        image.frame = nextFrame
        return image
    }
    
    func moveImage (image: UIImageView) ->(UIImageView) {
        let newFrame = image.frame
        var nextFrame: CGRect = CGRect()
        if self.direction == 0 { // di chuyen qua phai
            
            nextFrame = CGRect(x: newFrame.origin.x + self.widthCell + 1, y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)
            
        } else if self.direction == 1 { // di chuyen qua trai
            
            nextFrame = CGRect(x: newFrame.origin.x - self.widthCell - 1, y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)
            
        } else if self.direction == 2 { // di chuyen len tren
            
            nextFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y-self.widthCell - 1, width: newFrame.size.width, height: newFrame.size.height)
            
        } else if self.direction == 3 {// di chuyen xuong duoi
            
            nextFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y+self.widthCell + 1, width: newFrame.size.width, height: newFrame.size.height)
            
        }
        
        image.frame = nextFrame
        return image
    }
    
    
    @IBAction func actionSwipesRight(_ sender: UISwipeGestureRecognizer) {
        print("swipes right ")
        let pointBegan1 = sender.location(in: self.view)
        print("point begin in gray view: x= \(pointBegan1.x) y= \(pointBegan1.y)")
        self.direction = 0
        let arrPoint = manage.checkMove(point: pointBegan1, direction: 0)
        self.updateUI(arrPoint: arrPoint)
        self.numberStep += 1
    }
    
    @IBAction func actionSwipesLeft(_ sender: UISwipeGestureRecognizer) {
        print("swipes left ")
        let pointBegan1 = sender.location(in: self.view)
        print("point begin in gray view: x= \(pointBegan1.x) y= \(pointBegan1.y)")
        self.direction = 1
        let arrPoint = manage.checkMove(point: pointBegan1, direction: 1)
        self.updateUI(arrPoint: arrPoint)
        self.numberStep += 1
    }
    
    @IBAction func actionSwipesDown(_ sender: UISwipeGestureRecognizer) {
        print("swipes down ")
        let pointBegan1 = sender.location(in: self.view)
        print("point begin in gray view: x= \(pointBegan1.x) y= \(pointBegan1.y)")
        self.direction = 3
        let arrPoint = manage.checkMove(point: pointBegan1, direction: 3)
        self.updateUI(arrPoint: arrPoint)
        self.numberStep += 1
    }
    
    @IBAction func actionSwipesUp(_ sender: UISwipeGestureRecognizer) {
        print("swipes up ")
        let pointBegan1 = sender.location(in: self.view)
        print("point begin in gray view: x= \(pointBegan1.x) y= \(pointBegan1.y)")
        self.direction = 2
        let arrPoint = manage.checkMove(point: pointBegan1, direction: 2)
        self.updateUI(arrPoint: arrPoint)
        self.numberStep += 1
    }

}
//
//extension MainGameView : GADBannerViewDelegate {
//    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
//        
//    }
//    
//    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
//        
//    }
//}


