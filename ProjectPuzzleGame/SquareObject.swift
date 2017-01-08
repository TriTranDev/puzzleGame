//
//  SquareObject.swift
//  ProjectPuzzleGame
//
//  Created by Tri Tran on 11/2/16.
//  Copyright © 2016 Tri Tran. All rights reserved.
//

import UIKit

class SquareObject: NSObject {
    var x: CGFloat = 0 // x, y nay la toa do ma tran ko phai toa do hien tren mang hinh
    var y: CGFloat = 0
    var xPixel: CGFloat = 0
    var yPixel: CGFloat = 0
    var width: CGFloat = 0
    var height: CGFloat = 0
    var state: CGFloat = 0  // = 0 white , = 1 image, =2 can move. = -1 empty square
    var image: UIImage = UIImage()
    var originPoint: CGPoint = CGPoint()
    func SquareObject(xt: CGFloat, yt:CGFloat,wi:CGFloat,he:CGFloat,image: UIImage, xpi: CGFloat, ypi: CGFloat) {
        self.x = xt
        self.y = yt
        self.width = wi
        self.height = he
        self.image = image
        self.xPixel = xpi
        self.yPixel = ypi
        self.originPoint = CGPoint(x: xt, y: yt)
    }
    
    func checkTrue(xt: CGFloat, yt:CGFloat) -> Bool {
        let tempFrame = CGRect(x: xPixel, y: yPixel, width: width, height: height)
        if tempFrame.contains(CGPoint(x: xt, y: yt)) {
            return true
        }
        return false
    }
    
    func checkTrue(point: CGPoint) -> Bool {
        let tempFrame = CGRect(x: xPixel, y: yPixel, width: width, height: height)
        if tempFrame.contains(point) {
            return true
        }
        return false
    }
    
    func checkTrueWithPoint(point:CGPoint) ->Bool {
        if x == point.x && y == point.y {
            return true
        }
        return false
    }
    
    func getPoint () ->CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    func setPoint(point: CGPoint) {
        self.x = point.x
        self.y = point.y
    }
    
    func setPointPix(point: CGPoint) {
        self.xPixel = point.x
        self.yPixel = point.y
    }
    
    func getLengthNowWithOrigin ()-> CGFloat {
        var length:CGFloat = 0
        let first = x - originPoint.x
        let two = y - originPoint.y
        length =  abs(first)+abs(two)
        return length
    }
    
    func resetLocation() {
        self.x = self.originPoint.x
        self.y = self.originPoint.y
    }

}
