//
//  NSMutableArray.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 17/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import Foundation

extension NSMutableArray {
    
    func pop(isUpRequestArray : Bool) -> AnyObject {    // First In First Out
        
       if isUpRequestArray
       {
        
        let first: AnyObject = self.firstObject!
        
        self.removeObjectAtIndex(0)
        
        return first
      
       }
       else
       {
        
        let last: AnyObject = self.lastObject!
        
        self.removeLastObject()
        
        return last
        }
    }
    
    func displayFloor() -> String {
        var floorsString = String()
        for floor in self {
           floorsString = floorsString + "\((floor as! FloorRequest).currentFloor!) "
        }
        return floorsString
    }
    
    func sortAscendingOnFloorBasis() -> NSMutableArray {
        
        var array = [AnyObject]()
        
        if self.count != 0 {
            
            if self.firstObject is Int {
                
                array = self as AnyObject as! [(Int)]
                
                array.sort({($0 as! Int) < ($1 as! Int)})
                
            }
                
            else if self.firstObject is FloorRequest {
                
                array = self as AnyObject as! [(FloorRequest)]
                
                array.sort({($0 as! FloorRequest).currentFloor < ($1 as! FloorRequest).currentFloor})
            }
        }
        
        var set = NSOrderedSet(array: array)
        
        return NSMutableArray(array: set.array)
        
    }
}