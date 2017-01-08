//
//  TempSquareObject.swift
//  ProjectPuzzleGame
//
//  Created by Tri Tran on 11/22/16.
//  Copyright © 2016 Tri Tran. All rights reserved.
//

import UIKit

class TempSquareObject: NSObject {
    var originPoint: CGPoint = CGPoint()
    var newPoint: CGPoint = CGPoint()
    var state: CGFloat = 0
    var direction: CGFloat = 0
    
    func initObjec(orPoint:CGPoint, nePoint:CGPoint, state: CGFloat, direction: CGFloat) {
        self.originPoint = orPoint
        self.newPoint = nePoint
        self.state = state
        self.direction = direction
    }
    
    func getLengthNowWithOrigin ()-> CGFloat {
        var length:CGFloat = 0
        let first = newPoint.x - originPoint.x
        let two = newPoint.y - originPoint.y
        length =  abs(first)+abs(two)
        return length
    }
    
    func equalOther(object: TempSquareObject) -> Bool {
        if originPoint == object.originPoint && newPoint == object.newPoint && state == object.state {
            return true
        }
        return false
    }

}
