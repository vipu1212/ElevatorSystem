//
//  Lift.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

class Lift {
    
    var number : Int                // Unique ID for the lift
    let maxWeight :  Int = 800      // Maximum Weight capacity iof the lift n Kilo Grams
    var currentWeight :  Int = 0    // Current Sum total weight of the people in the lift
    var currentState :  LiftState = LiftState.Stationary // Current State of the lift
    var currentFloor : Int = 0       // Floor at which lift is at stationary
    var pressedButtons : NSMutableArray = NSMutableArray()  // All the pressed buttons in the lift
    
    
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
}