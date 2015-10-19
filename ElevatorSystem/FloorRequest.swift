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

class FloorRequest : NSObject, LiftButtonProtocol {
    
    private var leftPriority :  Int = 0
    private var rightPriority : Int = 0
    var currentFloor : Int?
    static var upPressedOnAllFloors : NSMutableArray = NSMutableArray()
    static var downPressedOnAllFloors : NSMutableArray = NSMutableArray()
    static var firstLift : Lift?
    static var secondLift : Lift?
    static var totalLifts : NSMutableArray = NSMutableArray(array: [])
    var delegate : LiftCallProtocol?
    var direction : Direction?
    
    override init() {
        
    }
    
    init(floor : Int, direction : Direction) {
        self.currentFloor = floor
        self.direction = direction
    }
    
    func buttonPressed(ForFloor floor: Int, Direction btnDirection: String) {
        
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
        
        if FloorRequest.firstLift?.currentState == Direction.Stationary {
           leftPriority += 1
        }
        if FloorRequest.secondLift?.currentState == Direction.Stationary {
            rightPriority += 1
        }
    }
    
    func nearestLift()  {
        
        let leftLiftDifference = abs(FloorRequest.firstLift!.currentFloor - currentFloor!)
        let rightLiftDifference = abs(FloorRequest.secondLift!.currentFloor - currentFloor!)
        
        if leftLiftDifference < rightLiftDifference {
           leftPriority += 1
        } else if leftLiftDifference > rightLiftDifference {
            rightPriority += 1
        }
    }

    
    func checkLiftSuitableOnDirection()  {
        
       if FloorRequest.firstLift!.currentState  == Direction.Stationary && FloorRequest.secondLift!.currentState == Direction.Stationary
       {
         nearestLift()
        if leftPriority == rightPriority {
           randomLift()
        }
       }
        if let leftLiftBelow = FloorRequest.firstLift!.isBelow(self),
                rightLiftBelow = FloorRequest.secondLift!.isBelow(self)
        {
            if leftLiftBelow && FloorRequest.firstLift!.currentState == Direction.GoingUp && direction == Direction.GoingUp {
                leftPriority += 1
            } else if rightLiftBelow && FloorRequest.secondLift!.currentState == Direction.GoingUp && direction == Direction.GoingUp {
                rightPriority += 1
            }
            
            else if !leftLiftBelow && FloorRequest.firstLift!.currentState == Direction.GoingDown && direction == Direction.GoingDown {
                leftPriority += 1
            } else if !rightLiftBelow && FloorRequest.secondLift!.currentState == Direction.GoingDown && direction == Direction.GoingDown {
                rightPriority += 1
            }
        }
        else if direction == FloorRequest.firstLift!.currentState {
            leftPriority += 1
        } else {
            rightPriority += 1
        }
    }
    
    
    func leastRequestQeueu()  {
        if FloorRequest.firstLift!.totalRequestCount < FloorRequest.secondLift!.totalRequestCount {
            leftPriority += 1
        } else if FloorRequest.secondLift!.totalRequestCount < FloorRequest.firstLift!.totalRequestCount {
           rightPriority += 1
        }
    }
    
    
    func addRequestInLift() {
                
        if leftPriority > rightPriority {
            delegate?.addToRequestQueueForLift(FloorRequest.firstLift!, request: self)
        }
        else if rightPriority > leftPriority {
            delegate?.addToRequestQueueForLift(FloorRequest.secondLift!, request: self)
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