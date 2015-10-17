//
//  ViewController.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, LiftCallProtocol, LiftMovementProtocol {

    
    @IBOutlet weak var lblLeftCurrentFloor: UILabel!
    
    @IBOutlet weak var lblRightCurrentFloor: UILabel!
    
    @IBOutlet weak var editLeftUpStopQueue: UITextView!
    
    @IBOutlet weak var editRightUpStopQueue: UITextView!
    
    @IBOutlet weak var editRightDownStopQueue: UITextView!
    
    @IBOutlet weak var editLeftDownStopQueue: UITextView!
    
    @IBOutlet weak var floorTableView: UITableView!
    
    static var totalLifts : NSMutableArray = NSMutableArray(array: [])
    
    var openLifts : NSMutableArray = NSMutableArray()
    
    var leftLift = Lift(LiftNumber: 1)
    var rightLift = Lift(LiftNumber: 2)
    
    override func viewDidAppear(animated: Bool) {
        
        MainController.totalLifts.addObjectsFromArray([leftLift, rightLift])
        
    }

    
    
    
    // MARK:- Table View Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("floorCell") as! FloorCell
        cell.fillCellData(ForFloor: indexPath.row)
        
        return cell
    }
    
    
    // MARK:- Collection View Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
         return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return 2
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("liftCell", forIndexPath: indexPath) as! LiftCell
        
        return cell
    }
    
    
    //MARK:- Lift Protocol Methods
    
    func addToRequestQueueForLift(lift: Lift, floor: LiftRequest) {
        
        lift.delegate = self
        
        if floor.direction == LiftState.GoingUp {
            lift.upPressedButtons.addObject(floor)
        } else {
            lift.downPressedButtons.addObject(floor)
        }
        
        lift.pressedButtons.addObject(floor)
        
        appendFloorInTextView(lift, floor: floor)
        
        if lift.pressedButtons.count == 1 {
           lift.moveLift(floor.direction!)
        }
    }
    
    
    func liftReached(lift: Lift) {
        
        removeFloorFromTextView(lift)
        
        var liftCell : LiftCell
        
        if openLifts.count < 2 {
        
        
        let floorCell =  floorTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0)) as! FloorCell
        
        if lift.number == (MainController.totalLifts.firstObject as! Lift).number {
            
          liftCell =  floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as! LiftCell
        } else {
            liftCell =  floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as! LiftCell
        }
        
        liftCell.setOpenLiftImage()
            
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "moveToNextInQueue:", userInfo: liftCell, repeats: false)
            
        }
    }
    
    func moveToNextInQueue(liftCell : LiftCell) {
        
     liftCell.setClosedLiftImage()
    }
    
    //MARK:- TextView methods
    
    func removeFloorFromTextView(lift : Lift) {
        if lift.currentState == LiftState.GoingUp {
            if lift.number == MainController.totalLifts.firstObject as! Lift {
                editLeftUpStopQueue.text = lift.upPressedButtons.displayFloor()
            } else {
                editRightUpStopQueue.text = lift.upPressedButtons.displayFloor()
            }
        } else {
            if lift.number == MainController.totalLifts.firstObject as! Lift {
                editLeftDownStopQueue.text = lift.downPressedButtons.displayFloor()
            } else {
                
                editRightDownStopQueue.text = lift.downPressedButtons.displayFloor()
            }
        }
    }
    

    func appendFloorInTextView(lift: Lift, floor: LiftRequest) {
        if lift == leftLift {
            
            if floor.direction == LiftState.GoingUp {
                
                editLeftUpStopQueue.text = lift.upPressedButtons.displayFloor()
            }
            else {
                
                editLeftDownStopQueue.text = lift.downPressedButtons.displayFloor()
            }
        }
        else {
            
            if floor.direction == LiftState.GoingUp {
                
                editRightUpStopQueue.text = lift.upPressedButtons.displayFloor()
            }
            else {
                
                editRightDownStopQueue.text = lift.downPressedButtons.displayFloor()
            }
        }
    }

}