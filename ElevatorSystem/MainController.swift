//
//  ViewController.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, LiftCallProtocol, LiftMovementProtocol, LiftFloorSelectProtocol {

    
    @IBOutlet weak var lblLeftCurrentFloor: UILabel!
    
    @IBOutlet weak var lblRightCurrentFloor: UILabel!
    
    @IBOutlet weak var editLeftUpStopQueue: UITextView!
    
    @IBOutlet weak var editRightUpStopQueue: UITextView!
    
    @IBOutlet weak var editRightDownStopQueue: UITextView!
    
    @IBOutlet weak var editLeftDownStopQueue: UITextView!
    
    @IBOutlet weak var floorTableView: UITableView!
    
    var liftCell : LiftCell?
    var tempLift : Lift?
    static var totalLifts : NSMutableArray = NSMutableArray(array: [])
    
    static var openLifts : NSMutableArray = NSMutableArray()
    
    var leftLift = Lift(LiftNumber: 1)
    var rightLift = Lift(LiftNumber: 2)
    
    var descriptor: NSSortDescriptor = NSSortDescriptor(key: "currentFloor", ascending: true)
    
    override func viewDidAppear(animated: Bool) {
        
        MainController.totalLifts.addObjectsFromArray([leftLift, rightLift])
        
    }

    
    
    
    //MARK:- Lift Protocol Methods
    
    func addToRequestQueueForLift(lift: Lift, request: FloorRequest) {
        
        lift.delegate = self
        
        addRequestInArray(lift, request: request)
        
        appendFloorInTextView(lift, floor: request)
        
         // If lift is stationary
        if lift.currentState == Direction.Stationary {
            lift.moveLiftForRequest(request, interruptCall: false)
            
        } else {
        // If lift is moving
            
            lift.moveLiftForRequest(request, interruptCall: true)
        }
    }
    
    
    func addRequestInArray(lift: Lift, request: FloorRequest) {
        
        if request.direction == Direction.GoingUp {
            lift.upPressedButtons.addObject(request)
            
            lift.upPressedButtons = NSMutableArray(array: lift.upPressedButtons.sortedArrayUsingDescriptors([descriptor]))
        } else {
            lift.downPressedButtons.addObject(request)
            
            lift.downPressedButtons = NSMutableArray(array: lift.downPressedButtons.sortedArrayUsingDescriptors([descriptor]))
        }
    }
    
    
    
    func movedOneFloor(lift: Lift, reachedRequest: Bool, request: FloorRequest) {
        
        updatedCurrentLiftLabel(lift)
        
        if reachedRequest {
            
           removeRequestFromArray(lift, request: request)
            
           removeFloorFromTextView(lift, floorRequest: request)
            
           updateLiftImage(lift, request: request)
        }
        
    }
    
    
    func removeRequestFromArray(lift: Lift, request: FloorRequest) {
        
        if request.direction == Direction.GoingUp {
            lift.upPressedButtons.pop()
            FloorRequest.upPressedOnAllFloors.pop()
        } else {
            lift.downPressedButtons.pop()
            FloorRequest.downPressedOnAllFloors.pop()
        }
    }
    
    func updatedCurrentLiftLabel(lift: Lift) {
        
        if lift == lift.firstLift {
            lblLeftCurrentFloor.text = "\(lift.currentFloor)"
        } else {
            lblRightCurrentFloor.text = "\(lift.currentFloor)"
        }
    }
    
    func updateLiftImage(lift: Lift, request: FloorRequest) {
        
        let visibleFloor = NSMutableArray(array: self.floorTableView.indexPathsForVisibleRows()!)

        tempLift = lift
      if visibleFloor.containsObject(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0))
      {
        let floorCell =  floorTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0)) as! FloorCell
        
        floorCell.toggleButtonColor(request.direction!)
        
        if lift.number == lift.firstLift.number {
            
            liftCell =  floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? LiftCell
    
        } else {
            liftCell =  floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as? LiftCell
        }
            
        liftCell!.setOpenLiftImage()
        
        MainController.openLifts.addObject(lift)
    }
    }
    
    func closeLift(floor: Int?) {
        
        
        
        if let requestFloor = floor {
        
        let direction : Direction
        
        if requestFloor < tempLift!.currentFloor {
            direction = Direction.GoingDown
        } else if requestFloor > tempLift!.currentFloor {
            direction = Direction.GoingUp
        } else {
            direction = Direction.Stationary
        }
        
        if direction != Direction.Stationary {
          
            let request = FloorRequest(floor: requestFloor, direction: direction)
                
             addToRequestQueueForLift(tempLift!, request: request)
            
        }
        }
        moveToNextInQueue()
        
    }
    
    func moveToNextInQueue() {
        
        liftCell!.setClosedLiftImage()
        MainController.openLifts.removeObject(tempLift!)
    }
    
    //MARK:- TextView methods
    
    func removeFloorFromTextView(lift : Lift, floorRequest : FloorRequest) {
        
        if floorRequest.direction == Direction.GoingUp {
            if lift == lift.firstLift {
                editLeftUpStopQueue.text = lift.upPressedButtons.displayFloor()
            } else {
                editRightUpStopQueue.text = lift.upPressedButtons.displayFloor()
            }
        } else {
            if lift.number == lift.firstLift {
                editLeftDownStopQueue.text = lift.downPressedButtons.displayFloor()
            } else {
                
                editRightDownStopQueue.text = lift.downPressedButtons.displayFloor()
            }
        }
    }
    

    func appendFloorInTextView(lift: Lift, floor: FloorRequest) {
        if lift == leftLift {
            
            if floor.direction == Direction.GoingUp {
                
                editLeftUpStopQueue.text = lift.upPressedButtons.displayFloor()
            }
            else {
                
                editLeftDownStopQueue.text = lift.downPressedButtons.displayFloor()
            }
        }
        else {
            
            if floor.direction == Direction.GoingUp {
                
                editRightUpStopQueue.text = lift.upPressedButtons.displayFloor()
            }
            else {
                
                editRightDownStopQueue.text = lift.downPressedButtons.displayFloor()
            }
        }
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
        
        cell.fillCellData(indexPath.row)
        
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
        cell.delegate = self
        return cell
    }
    

}