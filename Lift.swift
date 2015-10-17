//
//  Lift.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

protocol LiftMovementProtocol {
    func liftReached(lift: Lift)
}

class Lift : NSObject {
    
    
    let maxWeight :  Int = 800          // Maximum Weight capacity of the lift in Kilo Grams
    var currentWeight :  Int = 0        // Current total weight of the people in the lift
    var currentState : LiftState = LiftState.Stationary // Current State of the lift
    var currentFloor : Int = 0          // Floor at which lift is at stationary
    var pressedButtons = NSMutableArray()  // All the pressed buttons in the lift
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

    
    init(LiftNumber number :  Int) {
        self.number = number
    }
    
    func moveLift(direction : LiftState) {
        
        self.currentState = direction
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "update", userInfo: nil, repeats: false)
        

    }
    
    func update() {
        
        let toFloor = pressedButtons.pop() as! LiftRequest

        if self.currentState == LiftState.GoingUp {
            upPressedButtons.pop()
        } else {
            downPressedButtons.pop()
        }
        
        self.currentFloor = toFloor.currentFloor!
        
        delegate!.liftReached(self)
    }
        
    func isBelow(floor :  LiftRequest) ->  Bool?{
        
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