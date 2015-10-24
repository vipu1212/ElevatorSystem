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

    var isOpen : Bool {
        for lift in MainController.openLifts {
            if lift as! Lift == self
            {
                return true
            }
        }
        return false
    }
    
    init(LiftNumber number :  Int) {
        self.number = number
    }
    
    //MARK:- Main Flow Methods
    
    // checks type of input reqeust and move
    func moveLiftForRequest(request : FloorRequest, interruptCall : Bool, openLiftRequest : Bool) {
        
        if self.setLiftDirection(request)
        {
        var timer : NSTimer?
        
         timer  = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "moveOneFloor:", userInfo: request, repeats: true)
        
        if interruptCall {
            
            timer!.invalidate()
            timer = nil
            
            if openLiftRequest
            {
             timer  = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "moveOneFloor:", userInfo: request, repeats: true)
            }
            else
            {
            request.openLiftRequest = false
                timer  = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "moveOneFloor:", userInfo: request, repeats: true)
            }
          }
        }
      }
    
    // Goes to next 1 floor
    func moveOneFloor(request : NSTimer) {
        
        if self.currentState == Direction.GoingUp {
            println("UP")
        } else {
            println("DOWN")
        }
        
        let liftCurrentFloor = updatedCurrentFloor()
        
        let requestArray : NSMutableArray
        
        if (request.userInfo as! FloorRequest).direction == Direction.GoingUp {
            
            requestArray = upPressedButtons
            
             if requestArray.count > 0 {
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
            
            
        else if (request.userInfo as! FloorRequest).direction == Direction.GoingDown
        {
            requestArray = downPressedButtons
            
            if requestArray.count > 0 {
                
                if (requestArray.lastObject as! FloorRequest).currentFloor == liftCurrentFloor
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
        else {
            requestArray = downPressedButtons
            println("*****ERROR IN MOVE ONE FLOOR()*****")
        }
    }
    
    //MARK:-
    
    func setLiftDirection(request : FloorRequest) -> Bool{
        
        if let liftIsBelow = self.isBelow(request) {
            if liftIsBelow {
                self.currentState = Direction.GoingUp
                return true
            } else {
                self.currentState = Direction.GoingDown
                return true
            }
        } else {
            self.currentState = Direction.Stationary
            println("In Equal Condition. Lift at same floor, lifts open")
            return false
        }
        
    }

    // Updates currentFLoor propert of lift
    func updatedCurrentFloor() -> Int{
        
        if self.currentState == Direction.GoingDown {
           return --currentFloor
        } else if self.currentState == Direction.GoingUp {
           return ++currentFloor
        } else {
            return currentFloor
        }
    }
    
    // CHecks if lif is below request
    func isBelow(floor :  FloorRequest) ->  Bool? {
        
        if (floor.currentFloor > self.currentFloor) {
            return true
        } else if (floor.currentFloor < self.currentFloor) {
            return false
        }
        return nil
    }

    // Check if lift with that ID  already exists
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
        return "Lift At Floor \(currentFloor) , Number :  \(number)"
    }
}