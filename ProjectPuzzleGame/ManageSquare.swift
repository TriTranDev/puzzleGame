//
//  ManageSquare.swift
//  ProjectPuzzleGame
//
//  Created by Tri Tran on 11/2/16.
//  Copyright © 2016 Tri Tran. All rights reserved.
//

import UIKit


enum MyError: Error {
    case FoundNil(String)
}

class ManageSquare: NSObject {
    var arrSquare : [SquareObject] = []
    var whitePoint = CGPoint(x: 0, y: 0)
    var direction: CGFloat = 0 // 0 right, 1 left, 2 up, 3 down
    var pointFirst: CGPoint = CGPoint(x: 0, y: 0)
    var sizeCell: CGPoint = CGPoint (x: 0, y: 0)
    var col:CGFloat = 0
    var row:CGFloat = 0
    var arrFindTheWay : [[TempSquareObject]] = []
    var arrTrackWay : [[TempSquareObject]] = []
    var lastState : [TempSquareObject] = []
    var maxStep : Int = 50
    var currentStep : Int = 0
    var arrImageTemp: [UIImage] = []
    func ManageSquare (col:CGFloat , row :CGFloat , xFrist:CGFloat, yFirst:CGFloat, image: UIImage, completion: @escaping(([UIImageView]))->()) -> (CGFloat) {
        var arrImage : [UIImageView] = []
        
        let widthCell = (screenSize.size.width - 2*xFrist )/col
        let heightCell = widthCell
        let widthImage : CGFloat = widthCell * col
        let heightImage : CGFloat = heightCell * row
        let newSize : CGSize = CGSize(width: widthImage , height: heightImage )
        print ("width \(widthImage)")
        print ("height  \(heightImage)")
        print("new size \(newSize)")
        print ("widthImage = \(image.size.width), height = \(image.size.height)")
        
        pointFirst.x = xFrist
        pointFirst.y = yFirst
        
        sizeCell.x = widthCell
        sizeCell.y = heightCell
        
        self.col = col
        self.row = row
        
        let widthImageCell = image.size.width/col
        let heightImageCell = widthImageCell
        
        let newWidtCell = widthImageCell
        let newHeightCell = heightImageCell
        let newrow = row+1
        self.arrImageTemp = []

        for i in 0...Int(newrow-1) {
            for j in 0...Int(col-1) {
                    //
                    let xImage = CGFloat(j)*widthCell+xFrist
                    let yImage = CGFloat(i)*heightCell+yFirst
                    
                    var newImage:UIImage = UIImage()
                    if (i==0 && j==0) {
                        newImage = self.fromColor(color: .white)
                        self.arrImageTemp.append(newImage)
                    }
                
                    if i != 0 {
                        let tempRow = CGFloat(i)-1
                        let tempCol = j+0
                        let tempRect = CGRect(origin: CGPoint(x: CGFloat(tempCol)*newWidtCell, y: CGFloat(tempRow)*newHeightCell), size: CGSize(width: newWidtCell , height: newHeightCell ))
                        print ("rect \(tempRect)")
                        let cropImage = image.cgImage?.cropping(to:tempRect)
                        newImage = UIImage(cgImage: cropImage!)
                            self.arrImageTemp.append(newImage)
                    }
                    
                    let tempSquare:SquareObject = SquareObject()
                    tempSquare.SquareObject(xt: CGFloat(i), yt: CGFloat(j), wi: widthCell, he: heightCell,image: newImage,xpi: xImage,ypi: yImage)
                    if (i==0 && j != 0) {
                        tempSquare.state = -1
                        self.arrImageTemp.append(newImage)
                    } else if (i==0 && j==0) {
                        tempSquare.state = 0
                    } else {
                        tempSquare.state = 1
                    }
                    arrSquare.append(tempSquare)
                }
            }
        
            print("All Done");
            weak var weakSelf = self
            var index: Int = 0
            for temp in (weakSelf?.arrSquare)! {
                    let newPoint : CGPoint = weakSelf!.convertOriginPointToPixel(point: temp.originPoint)
                    
                    let newImageView: UIImageView = UIImageView(frame: CGRect(origin: newPoint , size: CGSize(width: weakSelf!.sizeCell.x, height: weakSelf!.sizeCell.y)))
                    newImageView.image = weakSelf?.arrImageTemp[index]
                    arrImage.append(newImageView)
                    index += 1
            }
            completion(arrImage)
        
        return widthCell
    }
    
    
    func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func updateState() {
        for temp in arrSquare {
            if temp.state == 2 {
                self.whitePoint = temp.getPoint()
                var newPoint :CGPoint = CGPoint()
                newPoint = self.updateCoordinate(point: temp.getPoint(), direction: self.direction)
                temp.setPoint(point: newPoint )
                temp.state = 1;
            }
        }
        
        for temp in arrSquare {
            if temp.state == 0 {
                temp.setPoint(point: whitePoint)
                break
            }
        }
        let stateNow = getStateNowWithDirection()
        self.arrTrackWay.append(stateNow)
    }
    
    func updateStateRandomWalk(newPoint: CGPoint) {
        
        for temp in arrSquare {
            if temp.getPoint() == newPoint {
                temp.setPoint(point: whitePoint)
                break
            }
        }
        
        for temp  in arrSquare {
            if temp.state == 0 {
                temp.setPoint(point: newPoint)
                break
            }
        }
    
        whitePoint = newPoint
        let stateNow = getStateNowWithDirection()
        self.arrTrackWay.append(stateNow)
    }
    
    func checkMove (point: CGPoint, direction: CGFloat) -> ([CGPoint]) {
        var arrPoint:[CGPoint] = []
        self.direction = direction
        for temp in arrSquare {
            let newCol = Int ((point.x-pointFirst.x) / sizeCell.x)
            let newRow = Int ( (point.y-pointFirst.y) / sizeCell.y)
            
            if temp.checkTrueWithPoint(point: CGPoint(x: newRow, y: newCol))  { //temp.checkTrue(point: point)
                let newPointTemp = self.getNextPointWithDirection(point: temp.getPoint(), direction: self.getReverseDirection(direction: direction))
                if newPointTemp == whitePoint {
                    let length = self.lengthTwoPoint(point1: whitePoint, point2: temp.getPoint())
                    let newPoint = CGPoint(x: temp.getPoint().y * sizeCell.x + pointFirst.x + 10, y: temp.getPoint().x * sizeCell.y + pointFirst.y + 10)
                    if length == 1 {
                        let nextPoint = self.updateCoordinate(point: temp.getPoint(), direction: direction)
                        if nextPoint == whitePoint {
                            temp.state = 2
                            arrPoint.append(newPoint)
                        }
                        self.updateState()
                    }
                    break
                }
            }
        }
        
        return arrPoint
    }
    
    private func lengthTwoPoint(point1: CGPoint,point2: CGPoint) -> CGFloat {
        var length:CGFloat = 0
        let first = point2.x-point1.x
        let two = point2.y-point1.y
        length =  abs(first)+abs(two)
        return length
    }
    
    private func checkSameRow(point1: CGPoint,point2: CGPoint) -> Bool {
        if point1.x == point2.x {
           return true
        }
        return false
    }
    
    private func checkSamrCol(point1: CGPoint,point2: CGPoint) -> Bool {
        if point1.y == point2.y {
            return true
        }
        return false
    }
    
    private func updateCoordinate(point: CGPoint, direction: CGFloat) -> (CGPoint) {
        var newPoint = CGPoint(x: 0, y: 0)
        
        if direction == 0 {  // right
            newPoint.x = point.x
            newPoint.y = point.y+1
            
        } else if direction == 1 { // left
            newPoint.x = point.x
            newPoint.y = point.y-1
            
        } else if direction == 2 { // up
            newPoint.x = point.x-1
            newPoint.y = point.y
        
        } else if direction == 3 { // down
            newPoint.x = point.x+1
            newPoint.y = point.y
        }
        
        return newPoint
    }
    
    private func getNextPointWithDirection(point: CGPoint, direction: CGFloat) ->(CGPoint) {
        var newPoint = CGPoint(x: 0, y: 0)
        
        if direction == 0 {  // right
            newPoint.x = point.x
            newPoint.y = point.y-1
            
        } else if direction == 1 { // left
            newPoint.x = point.x
            newPoint.y = point.y+1
            
        } else if direction == 2 { // up
            newPoint.x = point.x+1
            newPoint.y = point.y
            
        } else if direction == 3 { // down
            
            newPoint.x = point.x-1
            newPoint.y = point.y
        }
        
        return newPoint
    }
    
    func copyArray(arr: [TempSquareObject], direction:CGFloat ) ->([TempSquareObject]) {
        var newArr :[TempSquareObject] = []
        for t in arr {
            let newObject = TempSquareObject()
            newObject.initObjec(orPoint: t.originPoint, nePoint: t.newPoint, state: t.state,direction: direction)
            newArr.append(newObject)
        }
        return newArr
    }
    

    
    func getArrState(arrState: [TempSquareObject], pointWhite: CGPoint) ->([[TempSquareObject]]) {
        var arrInArr : [[TempSquareObject]] = []
        
        for i in 0...3 {
            
            let newPoint = self.getNextPointWithDirection(point: pointWhite, direction: CGFloat(i))
            var checkExist = false
            for tp in arrState {
                if (tp.originPoint == newPoint) {
                    checkExist = true
                }
            }
            if checkExist  {  //!(newPoint.x == 0 && newPoint.y>0) && !(newPoint.y < col &&  newPoint.y >= 0) && !(newPoint.x >= 0 && newPoint.x < row)
                let newArrNextStep:[TempSquareObject] = self.copyArray(arr: arrState,direction:  CGFloat(i))
                for t in newArrNextStep {
                    if t.state == 0 {
                        t.newPoint = newPoint
                    } else if t.newPoint == newPoint {
                        t.newPoint = pointWhite
                    }
                }
                arrInArr.append(newArrNextStep)
            }
        }
        return arrInArr
    }
    
    func getStateNow()-> [TempSquareObject]  {
        var arrWayToWinFinal : [TempSquareObject] = []
        for temp in arrSquare {
            if temp.state != -1 {
                let tempObject = TempSquareObject()
                tempObject.initObjec(orPoint: temp.originPoint, nePoint: temp.getPoint(), state: temp.state,direction: -1)
                arrWayToWinFinal.append(tempObject)
            }
        }
        return arrWayToWinFinal
    }

    func getStateNowWithDirection()-> [TempSquareObject]  {
        var arrWayToWinFinal : [TempSquareObject] = []
        for temp in arrSquare {
            if temp.state != -1 {
                let tempObject = TempSquareObject()
                tempObject.initObjec(orPoint: temp.originPoint, nePoint:  temp.getPoint(), state: temp.state,direction: self.getReverseDirection(direction: self.direction))
                arrWayToWinFinal.append(tempObject)
            }
        }
        return arrWayToWinFinal
    }
    
    func findTheWay2(numberStep:CGFloat) ->([[TempSquareObject]]) {
        var arrWayToWinFinal : [TempSquareObject] = []
        
        for temp in arrSquare {
            if temp.state != -1 {
                let tempObject = TempSquareObject()
                tempObject.initObjec(orPoint: temp.originPoint, nePoint: temp.getPoint(), state: temp.state,direction: -1)
                arrWayToWinFinal.append(tempObject)
            }
        }
        self.arrFindTheWay.append(arrWayToWinFinal)
        
            self.maxStep = Int( numberStep)
            self.currentStep = 0
            var tempArrFindTheWay : [[TempSquareObject]] = []
            tempArrFindTheWay.append(arrWayToWinFinal)
            self.lastState = arrWayToWinFinal
            self.getArrState4(arrState: &tempArrFindTheWay)
            if self.getLengthOfArr(arr: tempArrFindTheWay.last!) == 0 {
                return tempArrFindTheWay
            
            }
        return []//self.arrFindTheWay
    }
    
    
    
    func getArrState4(arrState: inout [[TempSquareObject]])  {
        
        weak var weakSelf = self
        weakSelf?.currentStep += 1
        if ((weakSelf?.currentStep)! > (weakSelf?.maxStep)!) {
            return
        }
        
        var pointWhite:CGPoint = CGPoint ()
        let tempLateArr = arrState.last//weakSelf?.lastState

        for temp in tempLateArr! {
            if temp.state == 0 {
                pointWhite = temp.newPoint
                break
            }
        }
        var arrMinArr : [[TempSquareObject]] = []
        
        for i in 0...3 {
            if i != Int((weakSelf?.getReverseDirection(direction: (tempLateArr?[0].direction)!))!) {
                let newPoint = weakSelf?.getNextPointWithDirection(point: pointWhite, direction: CGFloat(i))
                var checkExist = false
                for tp in tempLateArr! {
                    if (tp.originPoint == newPoint) {
                        checkExist = true
                    }
                }
                if checkExist  {
                    let newArrNextStep:[TempSquareObject] = weakSelf!.copyArray(arr: tempLateArr!,direction:  CGFloat(i))
                    for t in newArrNextStep {
                        if t.state == 0 {
                            t.newPoint = newPoint!
                        } else if t.newPoint == newPoint {
                            t.newPoint = pointWhite
                        }
                    }
                    arrMinArr.append(newArrNextStep)
                }
            }
        }
        
        if arrMinArr.count == 0
        {
            return
        }
        
        for i in 0...arrMinArr.count-1 {
            for j in i...arrMinArr.count-1 {

                if (weakSelf?.getLengthOfArr(arr: arrMinArr[i]))! > (weakSelf?.getLengthOfArr(arr: arrMinArr[j]))! {
                    let tempArr = arrMinArr[i]
                    arrMinArr[i] = arrMinArr[j]
                    arrMinArr[j] = tempArr
                }
            }
        }
        
        for i in 0...arrMinArr.count-1 {

            if weakSelf?.getLengthOfArr(arr: arrMinArr[i]) == 0 {
                arrState.append(arrMinArr[i])
                return
            } else {
                arrState.append(arrMinArr[i])
                weakSelf?.getArrState4(arrState: &arrState)
                if weakSelf?.getLengthOfArr(arr: arrState.last!) == 0 {
                    return
                } else {
                    weakSelf?.currentStep -= 1
                    arrState.removeLast()
                    print("current step \(weakSelf?.currentStep)")
                }
            }
        }
    }
    
    func printArr(arr: [TempSquareObject]) {
        for t in 0...arr.count-1 {
            print("x= \(arr[t].newPoint.x) y= \(arr[t].newPoint.y) state = \(arr[t].state)")
            
        }
        print(" ")
    }
    
    func equalArrTempSquare(object1: [TempSquareObject], object2: [TempSquareObject]) -> Bool {
        var check = true
        for i in 0...object1.count-1 {
            if object1[i].equalOther(object: object2[i]) {
                check = true
            } else {
                check = false
                break
            }
        }
        return check
    }
    
    func getReverseDirection(direction:CGFloat) -> CGFloat {
        if direction == 0 { return 1 }
        if direction == 1 { return 0 }
        if direction == 2 { return 3 }
        if direction == 3 { return 2 }
        return -1
    }
    
    func getLengthOfArr(arr: [TempSquareObject]) ->CGFloat {
        var length : CGFloat = 0
        for t in arr {
            if (t.state != 0 ) {
                length += t.getLengthNowWithOrigin()
            }
        }
        return length
    }
    
    func resetState() {
        for temp in arrSquare {
            if temp.state != -1 {
                temp.resetLocation()
                if temp.getPoint() == CGPoint(x: 0, y: 0) {
                    temp.state = 0
                } else {
                    temp.state = 1
                }
            }
        }
        whitePoint = CGPoint(x: 0, y: 0)
        self.arrFindTheWay = []
        self.arrTrackWay = []
    }
    
    func getListImageWhenReset() -> ([UIImageView]){
        resetState()
        var arrImage: [UIImageView] = []
        for temp in arrSquare {
            let newPoint : CGPoint = convertOriginPointToPixel(point: temp.originPoint)
            
            let newImageView: UIImageView = UIImageView(frame: CGRect(origin: newPoint , size: CGSize(width: sizeCell.x, height: sizeCell.y)))
            newImageView.image = temp.image
            arrImage.append(newImageView)
        }
        return arrImage
    }
    
    func getListSolution2(numberStep: CGFloat) ->([ObjectPointDirection]) {
        let arrInArrFinal : [[TempSquareObject]] =  self.findTheWay2(numberStep: numberStep)
        var listPointDirection : [ObjectPointDirection] = []
        
        for tempArr in arrInArrFinal {
            for t in tempArr {
                if t.state == 0 {
                    let tOPD = ObjectPointDirection()
                    tOPD.direction = t.direction
                    tOPD.point = self.convertPointToPixel(point:t.newPoint)
                    listPointDirection.append(tOPD)
                }
            }
        }
        
        resetState()
        
        return listPointDirection
    }
    
    func getListSolutionNotFind() ->([ObjectPointDirection]){
        let arrInArrFinal : [[TempSquareObject]] =  self.arrTrackWay//self.findTheWay2(numberStep: numberStep)
        var listPointDirection : [ObjectPointDirection] = []
        
        for tempArr in arrInArrFinal.reversed() {
            for t in tempArr {
                if t.state == 0 {
                    let tOPD = ObjectPointDirection()
                    tOPD.direction = t.direction
                    tOPD.point = self.convertPointToPixel(point:self.getNextPointWithDirection(point: t.newPoint, direction: t.direction))
                    listPointDirection.append(tOPD)
                }
            }
        }
        
        resetState()
        
        return listPointDirection
    }
    
    func getListRandomWalk(length: Int) ->([ObjectPointDirection]) {
        let arrInArrFinal : [[TempSquareObject]] =  generateState(length: length)
        var listPointDirection : [ObjectPointDirection] = []
        
        for tempArr in arrInArrFinal {
            
            for t in tempArr {
                if t.state == 0 {
                    let tOPD = ObjectPointDirection()
                    tOPD.direction = t.direction
                    self.direction = t.direction
                    tOPD.point = self.convertPointToPixel(point:t.newPoint)
                    listPointDirection.append(tOPD)
                    break
                }
            }
                updateStateRandomWalk(newPoint: getPointWhite(arrState: tempArr))
            
        }

        return listPointDirection
    }

    func convertPointToPixel(point:CGPoint)->(CGPoint) {
     let newPoint = CGPoint(x: point.y * sizeCell.x + pointFirst.x + 10, y: point.x * sizeCell.y + pointFirst.y + 10)
        return newPoint
    }
    
    func convertOriginPointToPixel(point:CGPoint)->(CGPoint) {
        let newPoint = CGPoint(x: point.y * sizeCell.x + pointFirst.x + point.y*1 , y: point.x * sizeCell.y + pointFirst.y + point.x*1)
        return newPoint
    }
    
    func getStateNext (tempLateArr: [TempSquareObject], pointWhite: CGPoint) -> [[TempSquareObject]] {
        weak var weakSelf = self
        var arrMinArr : [[TempSquareObject]] = []
        
        for i in 0...3 {
            if i != Int((weakSelf?.getReverseDirection(direction: (tempLateArr[0].direction)))!) {
                let newPoint = weakSelf?.getNextPointWithDirection(point: pointWhite, direction: CGFloat(i))
                var checkExist = false
                for tp in tempLateArr {
                    if (tp.originPoint == newPoint) {
                        checkExist = true
                    }
                }
                if checkExist  {
                    let newArrNextStep:[TempSquareObject] = weakSelf!.copyArray(arr: tempLateArr,direction:  CGFloat(i))
                    for t in newArrNextStep {
                        if t.state == 0 {
                            t.newPoint = newPoint!
                        } else if t.newPoint == newPoint {
                            t.newPoint = pointWhite
                        }
                    }
                    arrMinArr.append(newArrNextStep)
                }
            }
        }
     return arrMinArr
    }
    
    func getPointWhite (arrState: [TempSquareObject]) ->(CGPoint) {
        var whitePoint: CGPoint = CGPoint()
        for temp in arrState {
            if temp.state == 0 {
                whitePoint = temp.newPoint
                break
            }
        }
        return whitePoint
    }
    
    func generateState (length: Int) -> ([[TempSquareObject]]) {
        weak var weakSelf = self
        var arrRandomSquare : [[TempSquareObject]] = []
        var arrStateNow : [TempSquareObject] = (weakSelf?.getStateNow())!
        var pointWhite: CGPoint = CGPoint()
//        arrRandomSquare.append(arrStateNow)
        for _ in 0...length-1 {
            let newState = weakSelf?.getStateNext(tempLateArr: arrStateNow, pointWhite: pointWhite)
            if (newState?.count)! > 0 {
                if (newState?.count)! > 1 {
                    let randomIndex = Int(arc4random_uniform(UInt32((newState?.count)!)))
                    arrRandomSquare.append((newState![randomIndex]))
                    arrStateNow = (newState?[randomIndex])!
                    
                } else {
                    arrRandomSquare.append((newState?.last)!)
                    arrStateNow = (newState?.last)!
                }
            }
            pointWhite = getPointWhite(arrState: arrStateNow)
        }
        return arrRandomSquare
    }
    
}




















