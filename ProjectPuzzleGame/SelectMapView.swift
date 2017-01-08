//
//  SelectMapView.swift
//  ProjectPuzzleGame
//
//  Created by Tri Tran on 11/2/16.
//  Copyright © 2016 Tri Tran. All rights reserved.
//

import UIKit

class SelectMapView: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageSelected: UIImageView!
    @IBOutlet weak var widthImage: NSLayoutConstraint!
    @IBOutlet weak var heightImage: NSLayoutConstraint!
//    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var button3x3: UIButton!
    @IBOutlet weak var button3x4: UIButton!
    @IBOutlet weak var button4x4: UIButton!
    @IBOutlet weak var button4x5: UIButton!
    @IBOutlet weak var button5x5: UIButton!
    @IBOutlet weak var button5x6: UIButton!
    
    
    var imageDefault : UIImage? = nil
    var gestureTap : UITapGestureRecognizer!
    let imagePicker : UIImagePickerController = UIImagePickerController()
    var typeMap:CGFloat=0;
    var rowSelect:CGFloat = 3;
    var colSelect:CGFloat = 3;
    var checkLoadImage:Bool = false
    var arrButton: [UIButton] = []
    var scaleSize : CGFloat = 1
    
    override func viewDidLoad() {
//        activitySpinner.hidesWhenStopped = true
//        activitySpinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
//        activitySpinner.center = view.center
        super.viewDidLoad()

        if UIScreen.main.bounds.size.width > 500 {
            scaleSize = 300*(1/768)*UIScreen.main.bounds.size.width
            
        } else {
            scaleSize = 80*(1/375)*UIScreen.main.bounds.size.width
            
        }
        
        self.imageSelected.image = UIImage.init(named: "ImageTest")
        self.imageDefault = UIImage.init(named: "ImageTest")
        self.gestureTap = UITapGestureRecognizer.init(target: self, action: #selector(actionTap))
        self.imageSelected.isUserInteractionEnabled = true
        self.imageSelected.addGestureRecognizer(self.gestureTap)
        imagePicker.delegate = self
        
        self.setupUIFirst()
    }

    
    @IBAction func actionType3x3(_ sender: UIButton) {
        rowSelect = 3
        colSelect = 3
        self.typeMap = 0
        self.resetBorderButton(button: sender)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    @IBAction func actionType3x4(_ sender: UIButton) {
        rowSelect = 3
        colSelect = 4
        self.typeMap = 1
        self.resetBorderButton(button: sender)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    @IBAction func actionType4x4(_ sender: UIButton) {
        rowSelect = 4
        colSelect = 4
        self.typeMap = 2
        self.resetBorderButton(button: sender)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    @IBAction func actionType4x5(_ sender: UIButton) {
        rowSelect = 4
        colSelect = 5
        self.typeMap = 3
        self.resetBorderButton(button: sender)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    @IBAction func actionType5x5(_ sender: UIButton) {
        rowSelect = 5
        colSelect = 5
        self.typeMap = 4
        self.resetBorderButton(button: sender)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    @IBAction func actionType5x6(_ sender: UIButton) {
        rowSelect = 5
        colSelect = 6
        self.typeMap = 5
        self.resetBorderButton(button: sender)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    func resetBorderButton (button: UIButton) {
        for tempBt in arrButton {
            tempBt.layer.cornerRadius = 0
            tempBt.layer.masksToBounds = false
            tempBt.layer.borderWidth = 0
            tempBt.layer.borderColor = UIColor.clear.cgColor
        }
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupUIFirst() {
        self.arrButton.append(button3x3)
        self.arrButton.append(button3x4)
        self.arrButton.append(button4x4)
        self.arrButton.append(button4x5)
        self.arrButton.append(button5x5)
        self.arrButton.append(button5x6)
        
        rowSelect = 3
        colSelect = 3
        self.typeMap = 0
        self.resetBorderButton(button: button3x3)
        self.resizeImageWithType(row: rowSelect, col: colSelect)
    }
    
    func resizeImageWithType (row: CGFloat, col:CGFloat) {
        let cellWidth = (screenSize.size.width-scaleSize)/col
        let widthImage = cellWidth * col
        let heightImage = cellWidth * row
        self.widthImage.constant = CGFloat(widthImage)
        self.heightImage.constant = CGFloat(heightImage)
        print ("size image \(self.imageDefault?.size)")
        let newSize = CGSize(width: widthImage, height: heightImage)
        print ("size new \(newSize)")
        
        var newHeight: CGFloat = 0
        var newWidth : CGFloat = 0
        if widthImage <= heightImage {
            if self.imageDefault!.size.width < self.imageDefault!.size.height {
                newHeight = self.imageDefault!.size.width
            } else {
                newHeight = self.imageDefault!.size.height
            }
            newWidth = newHeight
            
        } else {
            if self.imageDefault!.size.width < self.imageDefault!.size.height {
                newWidth = self.imageDefault!.size.height
            } else {
                newWidth = self.imageDefault!.size.width
            }
            newHeight = (newWidth * heightImage) / widthImage
        }

        let tempCiimage = self.imageDefault?.cgImage
        let backgroundQueue = DispatchQueue.global(qos: .background)
        backgroundQueue.async {
//            self.activitySpinner.startAnimating()
            if !self.checkLoadImage {
                newWidth*=UIScreen.main.scale
                newHeight*=UIScreen.main.scale
            }
            let newSizeImage = CGSize(width: newWidth, height: newHeight ) //* UIScreen.main.scale
            
            print ("widthImage = \(self.imageDefault?.size.width), height = \(self.imageDefault?.size.height)")
            
            let newImage =  UIImage(cgImage: (tempCiimage?.cropping(to: CGRect(origin: CGPoint(x: 0, y: 0), size: newSizeImage)))!)

            DispatchQueue.main.async {
//                self.activitySpinner.stopAnimating()
                print ("widthImage = \(newImage.size.width), height = \(newImage.size.height)")
                self.imageSelected.image = newImage
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionExit(_ sender: AnyObject) {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageDefault = info[UIImagePickerControllerOriginalImage] as? UIImage
        if imageDefault?.imageOrientation != UIImageOrientation.up {
            
            UIGraphicsBeginImageContextWithOptions((imageDefault?.size)!, false, (imageDefault?.scale)!)
            imageDefault?.draw(in:CGRect(x: 0, y: 0, width: (imageDefault?.size)!.width, height: (imageDefault?.size)!.height) )
            let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
            UIGraphicsEndImageContext();
            imageDefault = normalizedImage
        }
        
        imageSelected.contentMode = .scaleToFill
        imageSelected.image = imageDefault
        self.checkLoadImage = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func actionTap () {
        print("tap on image")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainView" {
            if let destinationVC = segue.destination as? MainGameView {
                destinationVC.col = colSelect
                destinationVC.row = rowSelect
                destinationVC.imagemain = self.imageSelected.image!
                print ("widthImage = \(self.imageSelected.image?.size.width), height = \(self.imageSelected.image?.size.height)")
                destinationVC.typeMap = self.typeMap
            }
        }
    }
}
