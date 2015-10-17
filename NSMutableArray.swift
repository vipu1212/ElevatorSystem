//
//  NSMutableArray.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 17/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

extension NSMutableArray {
    
    func pop() -> AnyObject {
       let last: AnyObject = self.lastObject!
       self.removeLastObject()
       return last
    }
    
    func displayFloor() -> String {
        var floorsString = String()
        for floor in self {
           floorsString = floorsString + "\((floor as! LiftRequest).currentFloor!) "
        }
        return floorsString
    }
}