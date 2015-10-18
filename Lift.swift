//
//  Lift.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

protocol LiftMovementProtocol {
    func movedOneFloor(lift: Lift, reachedRequest: Bool, request : FloorRequest)
}

class Lift : NSObject {
    
    
    var currentState : Direction = Direction.Stationary // Current State of the lift
    var currentFloor : Int = 0          // Floor at which lift is at stationary
    var totalRequestCount : Int {
        return self.upPressedButtons.count + self.downPressedButtons.count
    }
  
    var upPressedButtons = NSMutableArray()
    var downPressedButtons = NSMutableArray()
   
    var priority :  Int = 0
    var delegate : LiftMovementProtocol?

    var number : Int {
        didSet(oldID) {
            if alreadyExistingID(number) {
                number = oldID
            } else {
                
                MainController.totalLifts.replaceObjectAtIndex(MainController.totalLifts.indexOfObject(oldID), withObject: number)
            }
        }
    }

    var firstLift : Lift {
       return MainController.totalLifts.firstObject as! Lift
    }
    
    var secondLift : Lift {
        return MainController.totalLifts.lastObject as! Lift
    }
    
    init(LiftNumber number :  Int) {
        self.number = number
    }
    
    //MARK:- Main Flow Methods
    
    func moveLiftForRequest(request : FloorRequest, interruptCall : Bool) {
        
        self.setLiftDirection(request)
        
       let timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "moveOneFloor:", userInfo: request, repeats: true)
        
        // Called just the first time before calling moveOn function
        // To Stop the current timer if interrupt occured
        
        if interruptCall {
            timer.invalidate()
            
            ////**** ADDITIONAL METHODS ****/////
        }
    }
    
    
    func moveOneFloor(request : NSTimer) {
        
        if self.currentState == Direction.GoingUp {
            println("UP")
        } else {
             println("DOWN")
        }
        
        let liftCurrentFloor = updatedCurrentFloor()
        let requestedFloor = (request.userInfo as! FloorRequest).currentFloor
        
        if liftCurrentFloor == requestedFloor {
            
            // Stop Moving Lift Requested Floor Reached
            delegate!.movedOneFloor(self, reachedRequest: true, request: request.userInfo! as! FloorRequest)
            request.invalidate()
        } else {
            
            // Continue moving lift until Requested Floor reached
            delegate!.movedOneFloor(self, reachedRequest: false, request: request.userInfo! as! FloorRequest)
        }
        
    }
    
    //MARK:-
    
    func setLiftDirection(request : FloorRequest) {
        
        if let liftIsBelow = self.isBelow(request) {
            if liftIsBelow {
                self.currentState = Direction.GoingUp
            } else {
                self.currentState = Direction.GoingDown
            }
        } else {
            
            /******* SET LIFT OPEN AND CONTINUE FLOW ***********/
        }
        
    }

    
    func updatedCurrentFloor() -> Int?{
        
        if self.currentState == Direction.GoingDown {
           return --currentFloor
        } else if self.currentState == Direction.GoingUp {
           return ++currentFloor
        } else {
            print("Error case in movedOneFloor()")
            return nil
        }
    }
    
    func isBelow(floor :  FloorRequest) ->  Bool?{
        
        if (floor.currentFloor > self.currentFloor) {
            return true
        } else if (floor.currentFloor < self.currentFloor) {
            return false
        }
        return nil
    }
    
    func alreadyExistingID(newID : Int) -> Bool{
    
        if !(MainController.totalLifts.count == 0) {
            for liftNumber in MainController.totalLifts {
                if (newID == liftNumber as! Int) {
                    println("This ID Already exists ! Value set to previous ID")
                    return true
                }
            }
        }
        return false
    }
}