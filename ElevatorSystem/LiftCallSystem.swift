//
//  ElevatorProtocols.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 11/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

protocol LiftCallProtocol {
    func addToRequestQueueForLift(lift : Lift)
}

class LiftCallSystem : LiftButtonProtocol {
    
    
    var currentFloor : Int?
    private var buttonsPressedOnAllFloors : NSMutableArray = NSMutableArray()
    var leftLift : Lift?
    var rightLift : Lift?
    var delegate : LiftCallProtocol?
    var direction : LiftState?
    
    func buttonPressed(AtFloor floor: Int, Direction: String) {
        currentFloor = floor
        buttonsPressedOnAllFloors.addObject(currentFloor!)
        if Direction == "up" {
            direction = LiftState.GoingUp  // Direction of the request
        }
        else {
            direction = LiftState.GoingDown
        }
        
        prioritizeCall()
    }
    
    func prioritizeCall () {
    
        
        // CHECK  ANY  STATIONARY  LIFT
        if let stationaryLift = anyLiftStationary() {
            stationaryLift.priority += 1
        } else {
                                    // in case both lifts are moving
        }
        
        
        // CHECK  NEAREST  LIFT
        if let nearestLift = nearestLift() {
            nearestLift.priority += 1
        }
        else {
                                    // In case of same difference
        }
        
        // CHECK DIRECTION  OF  THE  LIFT
        checkLiftSuitableOnDirection().priority += 1
        
        // CHECK  REQUEST  QUEUE  OF  LIFT
        checkLeastRequestQeueu()?.priority += 1
        
        addRequestInLift()
    }
    
    func anyLiftStationary() -> Lift? {
        
        if leftLift?.currentState == LiftState.Stationary {
            return leftLift
        } else if rightLift?.currentState == LiftState.Stationary {
            return rightLift
        }
        return nil
    }
    
    func nearestLift() -> Lift? {
        
        let leftLiftDifference = abs(leftLift!.currentFloor - currentFloor!)
        let rightLiftDifference = abs(rightLift!.currentFloor - currentFloor!)
        
        if leftLiftDifference < rightLiftDifference {
            return leftLift!
        } else if leftLiftDifference > rightLiftDifference {
            return rightLift!
        }
        return nil
    }

    
    func checkLiftSuitableOnDirection() ->  Lift {
        
       if leftLift!.currentState  == LiftState.Stationary && rightLift!.currentState == rightLift!.currentState  {
            return nearestLift()!
        }
        if let leftLiftBelow = leftLift!.isBelow(self),
                rightLiftBelow = rightLift!.isBelow(self)
        {
            if leftLiftBelow && leftLift!.currentState == LiftState.GoingUp && direction == LiftState.GoingUp {
                return leftLift!
            } else if rightLiftBelow && rightLift?.currentState == LiftState.GoingUp && direction == LiftState.GoingUp {
                return rightLift!
            }
            
            else if !leftLiftBelow && leftLift?.currentState == LiftState.GoingDown && direction == LiftState.GoingDown {
                return leftLift!
            } else if !rightLiftBelow && rightLift?.currentState == LiftState.GoingDown && direction == LiftState.GoingDown {
                return rightLift!
            }
        }
        else if direction == leftLift?.currentState {
            return leftLift!
        } else {
            return rightLift!
        }
        return randomLift()
    }
    
    
    func checkLeastRequestQeueu() -> Lift? {
        if leftLift?.pressedButtons.count < rightLift?.pressedButtons.count {
            return leftLift
        } else if rightLift?.pressedButtons.count < leftLift?.pressedButtons.count {
            return rightLift
        }
        return nil
    }
    
    func addRequestInLift() {
        if leftLift?.priority > rightLift?.priority {
            delegate?.addToRequestQueueForLift(leftLift!)
        }
        else if rightLift?.priority > leftLift?.priority {
            delegate?.addToRequestQueueForLift(rightLift!)
        }
            else {
                if let leastQueueLift = checkLeastRequestQeueu() {
                    delegate?.addToRequestQueueForLift(leastQueueLift)
                } else {
                    if let leastDiffLift = nearestLift() {
                        delegate?.addToRequestQueueForLift(leastDiffLift)
                    } else {
                        delegate?.addToRequestQueueForLift(checkLiftSuitableOnDirection())
                   }
                }
             }
          }
    
    
    func randomLift() -> Lift {
        let randomNumber = arc4random_uniform(2)
        if randomNumber == 0 {
            return leftLift!
        }
        return rightLift!
     }
    
}


