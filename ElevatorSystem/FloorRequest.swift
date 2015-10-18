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

class FloorRequest : LiftButtonProtocol {
    
    private var leftPriority :  Int = 0
    private var rightPriority : Int = 0
    var currentFloor : Int?
    static var upPressedOnAllFloors : NSMutableArray = NSMutableArray()
    static var downPressedOnAllFloors : NSMutableArray = NSMutableArray()
    var leftLift : Lift?
    var rightLift : Lift?
    var delegate : LiftCallProtocol?
    var direction : Direction?
    
    
    
    func buttonPressed(AtFloor floor: Int, Direction btnDirection: String) {
        
        currentFloor = floor
        
        if btnDirection == "up" {
            FloorRequest.upPressedOnAllFloors.addObject(currentFloor!)
            direction = Direction.GoingUp  // Direction of the request
        }
        else {
            FloorRequest.downPressedOnAllFloors.addObject(currentFloor!)
            direction = Direction.GoingDown
        }
        
        prioritizeCall()
        
    }
    
    func prioritizeCall () {
    
        
        // CHECK  ANY  STATIONARY  LIFT
        anyLiftStationary()
        
        // CHECK  NEAREST  LIFT
        nearestLift()
        
        // CHECK DIRECTION  OF  THE  LIFT
        checkLiftSuitableOnDirection()
        
        // CHECK  REQUEST  QUEUE  OF  LIFT
        leastRequestQeueu()
        
        addRequestInLift()
    }
    
    func anyLiftStationary()  {
        
        if leftLift?.currentState == Direction.Stationary {
           leftPriority += 1
        }
        if rightLift?.currentState == Direction.Stationary {
            rightPriority += 1
        }
    }
    
    func nearestLift()  {
        
        let leftLiftDifference = abs(leftLift!.currentFloor - currentFloor!)
        let rightLiftDifference = abs(rightLift!.currentFloor - currentFloor!)
        
        if leftLiftDifference < rightLiftDifference {
           leftPriority += 1
        } else if leftLiftDifference > rightLiftDifference {
            rightPriority += 1
        }
    }

    
    func checkLiftSuitableOnDirection()  {
        
       if leftLift!.currentState  == Direction.Stationary && rightLift!.currentState == Direction.Stationary
       {
         nearestLift()
        if leftPriority == rightPriority {
           randomLift()
        }
       }
        if let leftLiftBelow = leftLift!.isBelow(self),
                rightLiftBelow = rightLift!.isBelow(self)
        {
            if leftLiftBelow && leftLift!.currentState == Direction.GoingUp && direction == Direction.GoingUp {
                leftPriority += 1
            } else if rightLiftBelow && rightLift?.currentState == Direction.GoingUp && direction == Direction.GoingUp {
                rightPriority += 1
            }
            
            else if !leftLiftBelow && leftLift?.currentState == Direction.GoingDown && direction == Direction.GoingDown {
                leftPriority += 1
            } else if !rightLiftBelow && rightLift?.currentState == Direction.GoingDown && direction == Direction.GoingDown {
                rightPriority += 1
            }
        }
        else if direction == leftLift?.currentState {
            leftPriority += 1
        } else {
            rightPriority += 1
        }
    }
    
    
    func leastRequestQeueu()  {
        if leftLift!.totalRequestCount < rightLift!.totalRequestCount {
            leftPriority += 1
        } else if rightLift!.totalRequestCount < leftLift!.totalRequestCount {
           rightPriority += 1
        }
    }
    
    
    func addRequestInLift() {
                
        if leftPriority > rightPriority {
            delegate?.addToRequestQueueForLift(leftLift!, request: self)
        }
        else if rightPriority > leftPriority {
            delegate?.addToRequestQueueForLift(rightLift!, request: self)
        }
            else {
            randomLift()
            addRequestInLift()
        }
    }
    
    
    func randomLift() {
        let randomNumber = arc4random_uniform(20)
    
        if randomNumber%2 == 0 {
            leftPriority += 1
        }
        rightPriority += 1
     }
}