//
//  Lift.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

class Lift : NSObject {
    
    
    let maxWeight :  Int = 800          // Maximum Weight capacity of the lift in Kilo Grams
    var currentWeight :  Int = 0        // Current total weight of the people in the lift
    var currentState : LiftState = LiftState.Stationary // Current State of the lift
    var currentFloor : Int = 0          // Floor at which lift is at stationary
    var pressedButtons = NSMutableArray()  // All the pressed buttons in the lift
    var priority :  Int = 0
    
    
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
    
    func startLift() {
        
    }
    
    func stopLift() {
        
    }
    
    func restartLift() {
        
    }
    
    func callLift() {
        
    }
    
    func openDoor() {
        
    }
    
    func closeDoor() {
        
    }
    
    func isBelow(floor :  LiftCallSystem) ->  Bool?{
        
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