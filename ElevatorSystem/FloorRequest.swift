//
//  ElevatorProtocols.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 11/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

protocol LiftCallProtocol {
    func addToRequestQueueForLift(lift: Lift, request : FloorRequest)
}

class FloorRequest : NSObject, LiftButtonProtocol , DebugPrintable {
    
    private var leftPriority :  Int = 0
    private var rightPriority : Int = 0
    var currentFloor : Int?
    static var upPressedOnAllFloors : NSMutableArray = NSMutableArray()
    static var downPressedOnAllFloors : NSMutableArray = NSMutableArray()
    static var firstLift : Lift?
    static var secondLift : Lift?
    static var totalLifts : NSMutableArray = NSMutableArray(array: [])
    var delegate : LiftCallProtocol?
    var direction : Direction?
    var openLiftRequest : Bool?
    
    override init() {
        
    }
    
    init(floor : Int, direction : Direction) {
        self.currentFloor = floor
        self.direction = direction
    }
    
    func buttonPressed(ForFloor floor: Int, Direction btnDirection: String) {
        
        currentFloor = floor
        
        if btnDirection == "up"
        {
            direction = Direction.GoingUp  // Direction of the request
        }
        else
        {
            direction = Direction.GoingDown
        }
        
        prioritizeCall()
        
    }
    
    func prioritizeCall () {
    
        // Chexk any stationary Lift
        anyLiftStationary()
        
        // Check nearest lift
        nearestLift()
        
        // Check direction of the lift
        checkLiftSuitableOnDirection()
        
        // Check min request for the lift
        leastRequestQeueu()
        
        if !definiteCondition() {
         addRequestInLift()   
        }
    }
    
    func anyLiftStationary()  {
        
        if FloorRequest.firstLift?.currentState == Direction.Stationary {
           leftPriority += 1
        }
        if FloorRequest.secondLift?.currentState == Direction.Stationary {
            rightPriority += 1
        }
    }
    
    func nearestLift()  {
        
        let leftLiftDifference = abs(FloorRequest.firstLift!.currentFloor - currentFloor!)
        let rightLiftDifference = abs(FloorRequest.secondLift!.currentFloor - currentFloor!)
        
        if leftLiftDifference < rightLiftDifference {
           leftPriority += 1
        } else if leftLiftDifference > rightLiftDifference {
            rightPriority += 1
        }
    }

    func definiteCondition() -> Bool {
        
       if (currentFloor == FloorRequest.firstLift?.currentFloor && (FloorRequest.firstLift?.currentState == Direction.Stationary
         ))
       {
         delegate?.addToRequestQueueForLift(FloorRequest.firstLift!, request: self)
        return true
       }
       else if (currentFloor == FloorRequest.secondLift?.currentFloor && (FloorRequest.secondLift?.currentState == Direction.Stationary
        ))
       {
        delegate?.addToRequestQueueForLift(FloorRequest.secondLift!, request: self)
        return true
       }
        
        for openLift in MainController.openLifts {
            if currentFloor == openLift.currentFloor {
                return true
            }
        }
        
        return false
    }
    
    func checkLiftSuitableOnDirection()  {
        
       if FloorRequest.firstLift!.currentState  == Direction.Stationary && FloorRequest.secondLift!.currentState == Direction.Stationary
       {
         nearestLift()
        if leftPriority == rightPriority {
           randomLift()
        }
       }
        if let leftLiftBelow = FloorRequest.firstLift!.isBelow(self),
                rightLiftBelow = FloorRequest.secondLift!.isBelow(self)
        {
            if leftLiftBelow && FloorRequest.firstLift!.currentState == Direction.GoingUp && direction == Direction.GoingUp {
                leftPriority += 1
            } else if rightLiftBelow && FloorRequest.secondLift!.currentState == Direction.GoingUp && direction == Direction.GoingUp {
                rightPriority += 1
            }
            
            else if !leftLiftBelow && FloorRequest.firstLift!.currentState == Direction.GoingDown && direction == Direction.GoingDown {
                leftPriority += 1
            } else if !rightLiftBelow && FloorRequest.secondLift!.currentState == Direction.GoingDown && direction == Direction.GoingDown {
                rightPriority += 1
            }
        }
        else if direction == FloorRequest.firstLift!.currentState {
            leftPriority += 1
        } else {
            rightPriority += 1
        }
    }
    
    
    func leastRequestQeueu()  {
        
        if FloorRequest.firstLift!.totalRequestCount < FloorRequest.secondLift!.totalRequestCount {
            
            leftPriority += 1
            
        } else if FloorRequest.secondLift!.totalRequestCount < FloorRequest.firstLift!.totalRequestCount {
            
           rightPriority += 1
        }
    }
    
    
    func addRequestInLift() {
                
        if leftPriority > rightPriority {
            
            delegate?.addToRequestQueueForLift(FloorRequest.firstLift!, request: self)
        }
        else if rightPriority > leftPriority {
            
            delegate?.addToRequestQueueForLift(FloorRequest.secondLift!, request: self)
        }
            else {
            
            randomLift()
            
            addRequestInLift()
        }
    }
    
    
    func randomLift() {
        
       let randomNumber = arc4random_uniform(127)
    
        if randomNumber%2 == 0 {
            leftPriority += 1
            return
        }
        rightPriority += 1
     }
    
    override var description : String{
        
        return "Request Floor \(currentFloor!) In direction :  \(direction!)"
    }
    
    override var hashValue: Int {
        
        return currentFloor!.hashValue
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        
        return self.currentFloor == (object! as! FloorRequest).currentFloor
    }
}