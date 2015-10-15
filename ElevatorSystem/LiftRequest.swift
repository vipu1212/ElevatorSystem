//
//  ElevatorProtocols.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 11/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

protocol LiftCallProtocol {
    func addToRequestQueueForLift(lift: Lift, floor : LiftRequest)
}

class LiftRequest : LiftButtonProtocol {
    
    var leftPriority :  Int = 0
    var rightPriority : Int = 0
    var currentFloor : Int?
    static var upPressedOnAllFloors : NSMutableArray = NSMutableArray()
    static var downPressedOnAllFloors : NSMutableArray = NSMutableArray()
    var leftLift : Lift?
    var rightLift : Lift?
    var delegate : LiftCallProtocol?
    var direction : LiftState?
    
    
    
    func buttonPressed(AtFloor floor: Int, Direction: String) {
        
        currentFloor = floor
        
        if Direction == "up" {
            LiftRequest.upPressedOnAllFloors.addObject(currentFloor!)
            direction = LiftState.GoingUp  // Direction of the request
        }
        else {
            LiftRequest.downPressedOnAllFloors.addObject(currentFloor!)
            direction = LiftState.GoingDown
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
        
        if leftLift?.currentState == LiftState.Stationary {
           leftPriority += 1
        }
        if rightLift?.currentState == LiftState.Stationary {
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
        
       if leftLift!.currentState  == LiftState.Stationary && rightLift!.currentState == LiftState.Stationary
       {
         nearestLift()
        if leftPriority == rightPriority {
           randomLift()
        }
       }
        if let leftLiftBelow = leftLift!.isBelow(self),
                rightLiftBelow = rightLift!.isBelow(self)
        {
            if leftLiftBelow && leftLift!.currentState == LiftState.GoingUp && direction == LiftState.GoingUp {
                leftPriority += 1
            } else if rightLiftBelow && rightLift?.currentState == LiftState.GoingUp && direction == LiftState.GoingUp {
                rightPriority += 1
            }
            
            else if !leftLiftBelow && leftLift?.currentState == LiftState.GoingDown && direction == LiftState.GoingDown {
                leftPriority += 1
            } else if !rightLiftBelow && rightLift?.currentState == LiftState.GoingDown && direction == LiftState.GoingDown {
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
        if leftLift?.pressedButtons.count < rightLift?.pressedButtons.count {
            leftPriority += 1
        } else if rightLift?.pressedButtons.count < leftLift?.pressedButtons.count {
           rightPriority += 1
        }
    }
    
    func addRequestInLift() {
                
        if leftPriority > rightPriority {
            delegate?.addToRequestQueueForLift(leftLift!, floor: self)
        }
        else if rightPriority > leftPriority {
            delegate?.addToRequestQueueForLift(rightLift!, floor: self)
        }
            else {
            /*
                if let leastQueueLift = checkLeastRequestQeueu() {
                    delegate?.addToRequestQueueForLift(leastQueueLift)
                } else {
                    if let leastDiffLift = nearestLift() {
                        delegate?.addToRequestQueueForLift(leastDiffLift)
                    } else {
                        delegate?.addToRequestQueueForLift(checkLiftSuitableOnDirection())
                   }
                }*/
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


