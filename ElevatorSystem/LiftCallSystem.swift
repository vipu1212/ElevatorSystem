//
//  ElevatorProtocols.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 11/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

protocol LiftCallProtocol {
    func addToRequestQueueForLift(lift : Int)
}

class LiftCallSystem : LiftButtonProtocol {
    
    
    private var currentFloor : Int?
    private var buttonsPressedOnAllFloors : NSMutableArray = NSMutableArray()
    var leftLift : Lift?
    var rightLift : Lift?
    var delegate : LiftCallProtocol?
    var direction : LiftState?
    
    func buttonPressed(AtFloor floor: Int, Direction: String) {
        currentFloor = floor
        buttonsPressedOnAllFloors.addObject(currentFloor!)
        if Direction == "up" {
            direction = LiftState.GoingUp
        }
        else {
            direction = LiftState.GoingDown
        }
        
        prioritizeCall()
    }
    
    func prioritizeCall () {
    
        nearestLift()
    }
    
    func checkLiftDirection() {
        
        
    }
    
    
    func nearestLift() -> Lift? {
        
        let leftLiftDifference = abs(leftLift!.currentFloor - currentFloor!)
        let rightLiftDifference = abs(rightLift!.currentFloor - currentFloor!)
        
        if leftLiftDifference < rightLiftDifference {
            return leftLift!
        } else if leftLiftDifference > rightLiftDifference {
            return rightLift!
        } else  {
            return nil
        }
    }
    
    
    
    func checkLeastRequestQeueu() {
        
    }
}
