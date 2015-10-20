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

class Lift : NSObject , DebugPrintable{
    
    
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
                
                FloorRequest.totalLifts.replaceObjectAtIndex(FloorRequest.totalLifts.indexOfObject(oldID), withObject: number)
            }
        }
    }

    
    init(LiftNumber number :  Int) {
        self.number = number
    }
    
    //MARK:- Main Flow Methods
    
    func moveLiftForRequest(request : FloorRequest, interruptCall : Bool) {
        
        self.setLiftDirection(request)
        
     //   dispatch_async(DISPATCH_QUEUE_PRIORITY_HIGH, {
        
         let timer  = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "moveOneFloor:", userInfo: request, repeats: true)
    // })
    }
    
    
    func moveOneFloor(request : NSTimer) {
        
        if self.currentState == Direction.GoingUp {
            println("UP")
        } else {
            println("DOWN")
        }
        
        let liftCurrentFloor = updatedCurrentFloor()
        
        let requestedFloor = (request.userInfo as! FloorRequest).currentFloor
        
        let requestArray : NSMutableArray
        
        if (request.userInfo as! FloorRequest).direction == Direction.GoingUp {
            requestArray = upPressedButtons
        }
        else if (request.userInfo as! FloorRequest).direction == Direction.GoingDown
        {
            requestArray = downPressedButtons
        }
        else {
            requestArray = downPressedButtons
            println("*****ERROR IN MOVE ONE FLOOR()*****")
        }
        
        if requestArray.count != 0 {
        
        if (requestArray.firstObject as! FloorRequest).currentFloor == liftCurrentFloor
        {
            
            delegate!.movedOneFloor(self, reachedRequest: true, request: request.userInfo! as! FloorRequest)
            request.invalidate()
        }
        else
        {
            delegate!.movedOneFloor(self, reachedRequest: false, request: request.userInfo! as! FloorRequest)
        }
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
            println("Unhandled condition !!! ")
        }
        
    }

    
    func updatedCurrentFloor() -> Int{
        
        if self.currentState == Direction.GoingDown {
           return --currentFloor
        } else if self.currentState == Direction.GoingUp {
           return ++currentFloor
        } else {
            return currentFloor
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
    
        if !(FloorRequest.totalLifts.count == 0) {
            for liftNumber in FloorRequest.totalLifts {
                if (newID == liftNumber as! Int) {
                    println("This ID Already exists ! Value set to previous ID")
                    return true
                }
            }
        }
        return false
    }
    
    override var description : String{
        return "\(currentFloor) --- \(number)"
    }
}