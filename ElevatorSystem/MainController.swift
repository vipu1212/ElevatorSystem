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
    
    
    static var openLifts : NSMutableArray = NSMutableArray()
    
    var descriptor: NSSortDescriptor = NSSortDescriptor(key: "currentFloor", ascending: true)
    
    override func viewDidAppear(animated: Bool) {
        
        FloorRequest.firstLift = Lift(LiftNumber: 1)
        FloorRequest.secondLift = Lift(LiftNumber: 2)
        
        FloorRequest.totalLifts.addObjectsFromArray([FloorRequest.firstLift!, FloorRequest.secondLift!])
    }
    
    //MARK:- Lift Protocol Methods
    
    func addToRequestQueueForLift(lift: Lift, var request: FloorRequest) {

        if lift.currentFloor == request.currentFloor && lift.currentState == Direction.Stationary {
            openLiftOnSameFloor(lift)
            return
        }
        
        lift.delegate = self
        
        addRequestInArray(lift, request: request)
        
        appendFloorInTextView(lift, floor: request)
        
        
        if lift.currentState == Direction.Stationary {
            lift.moveLiftForRequest(request, interruptCall: false, openLiftRequest: false)
        }
        else
        {
        
        
        

        for openLift in MainController.openLifts {
            
            if (openLift as! Lift) == lift {
                
                if openLift.currentFloor == request.currentFloor {
                    
                lift.moveLiftForRequest(request, interruptCall: true, openLiftRequest: true)
                }
                else
                {
                    if request.openLiftRequest != nil {
                        
                    request = pendingRequests(lift, request: request)
                        
                    lift.moveLiftForRequest(request, interruptCall: true, openLiftRequest: false)
                    }
                 }
              }
           }
        }
    }
    
    func pendingRequests(lift: Lift, var request: FloorRequest) -> FloorRequest{
        
        if request.direction != lift.currentState {
            
            if lift.currentState == Direction.GoingUp {
                
                if lift.upPressedButtons.count > 0 {
                    
                   request = lift.upPressedButtons.lastObject as! FloorRequest
                }
            }
            else if lift.currentState == Direction.GoingDown {
                
                if lift.downPressedButtons.count > 0 {
                    
                    request = lift.downPressedButtons.lastObject as! FloorRequest
                }
            }
        }
        return request
    }
    
    func openLiftOnSameFloor(lift: Lift) {
    
        let liftCell : LiftCell
        
        let floorCell =  floorTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0)) as! FloorCell
        
        if lift == FloorRequest.firstLift
        {
            liftCell =  (floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? LiftCell)!
        }
        else
        {
            liftCell =  (floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as? LiftCell)!
        }
        
        MainController.openLifts.addObject(lift)
        
        liftCell.setOpenLiftImage()
    }
    
    //MARK:- 
    
    func addRequestInArray(lift: Lift, request: FloorRequest) {
        
        if request.direction == Direction.GoingUp {
            
            lift.upPressedButtons.addObject(request)
            
            lift.upPressedButtons = lift.upPressedButtons.sortAscendingOnFloorBasis()
            
            FloorRequest.upPressedOnAllFloors.addObject(request.currentFloor!)
            
            FloorRequest.upPressedOnAllFloors = FloorRequest.upPressedOnAllFloors.sortAscendingOnFloorBasis()
            
        } else {
            
            lift.downPressedButtons.addObject(request)
           
            lift.downPressedButtons = lift.downPressedButtons.sortAscendingOnFloorBasis()
            
            FloorRequest.downPressedOnAllFloors.addObject(request.currentFloor!)
            
            FloorRequest.downPressedOnAllFloors = FloorRequest.downPressedOnAllFloors.sortAscendingOnFloorBasis()
            
        }
        
    }
    
    
    func movedOneFloor(lift: Lift, reachedRequest: Bool, request: FloorRequest) {
        
     //   dispatch_sync(dispatch_get_main_queue(), {
        
            self.updatedCurrentLiftLabel(lift)
            
            if reachedRequest {
                
                self.removeRequestFromArray(lift, request: request)
                
                self.removeFloorFromTextView(lift, floorRequest: request)
                
                self.updateLiftImage(lift, request: request)
            }

   //     })
        
    }
    
    
    func removeRequestFromArray(lift: Lift, request: FloorRequest) {
        
        if request.direction == Direction.GoingUp {
            
            lift.upPressedButtons.pop(true)
            
            if FloorRequest.upPressedOnAllFloors.count > 0 {
            FloorRequest.upPressedOnAllFloors.pop(true)
            }
            
        } else {
            
            lift.downPressedButtons.pop(false)
            if FloorRequest.downPressedOnAllFloors.count > 0 {
            FloorRequest.downPressedOnAllFloors.pop(false)
            }
        }
        
    }
    
    
    func updatedCurrentLiftLabel(lift: Lift) {
    
        if lift == FloorRequest.firstLift {
            
            lblLeftCurrentFloor.text = "\(lift.currentFloor)"
            
        } else {
            
            lblRightCurrentFloor.text = "\(lift.currentFloor)"
            
        }
        
    }
 
    
    func updateLiftImage(lift: Lift, request: FloorRequest) {
  
        MainController.openLifts.addObject(lift)
        
        var liftCell : LiftCell?
        
        let visibleFloor = NSMutableArray(array: self.floorTableView.indexPathsForVisibleRows()!)
        
        if visibleFloor.containsObject(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0))
            
        {
            let floorCell =  floorTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0)) as! FloorCell
            
            
            floorCell.toggleButtonColor(request.direction!)
            
            
            if lift == FloorRequest.firstLift {
                
                liftCell =  floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? LiftCell
                
             } else {
                
                liftCell =  floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as? LiftCell
                
            }
            
            liftCell!.setOpenLiftImage()
        }
    }
    
    
    func closeLift(requestedFloor: Int?, liftNumber: Int) {
        
        var lift : Lift
        
        if liftNumber == 1
        {
            lift = FloorRequest.firstLift!
        }
        else
        {
            lift = FloorRequest.secondLift!
        }
        
        
        
        if let requestFloor = requestedFloor {
            
            let direction : Direction
            
            if requestFloor < lift.currentFloor {
                
                direction = Direction.GoingDown
                moveToNextInQueue(requestedFloor, lift: lift, direction: direction, openLiftRequest:false)
            
            } else if requestFloor > lift.currentFloor {
                
                direction = Direction.GoingUp
                moveToNextInQueue(requestedFloor, lift: lift, direction: direction, openLiftRequest:false)
            
            } else {
                
                let alert = UIAlertView(title: ":/ :/", message: "Nothing will happen", delegate: self, cancelButtonTitle: "Ok")
                
                alert.show()
                
                return
            }
        } else {
            
            let nextRequest : FloorRequest?
            
            
            
                if lift.upPressedButtons.count != 0 {
                    nextRequest = lift.upPressedButtons.pop(true) as? FloorRequest
                    
                    if FloorRequest.upPressedOnAllFloors.count != 0 {
                        FloorRequest.upPressedOnAllFloors.pop(true)
                    }
                }
                    
               else if lift.downPressedButtons.count != 0
                {
                    
                nextRequest = lift.downPressedButtons.pop(false) as? FloorRequest
                
                if FloorRequest.downPressedOnAllFloors.count != 0 {
                   FloorRequest.downPressedOnAllFloors.pop(false)
                }
                } else {
                    nextRequest = nil
                    println("NIL AT CLOSE LIFT()")
            }
            
            if let request = nextRequest {
                
               if lift.setLiftDirection(request)
               {
                moveToNextInQueue(nextRequest!.currentFloor, lift: lift, direction: nextRequest!.direction!, openLiftRequest: true)
            }
            else
            {
                checkAndSetLiftStationary(lift)
            }
        }
        
        checkAndSetLiftStationary(lift)
        }
    }
    
    
    func checkAndSetLiftStationary(lift : Lift) {
        
        if lift.upPressedButtons.count == 0 && lift.downPressedButtons.count == 0 && FloorRequest.upPressedOnAllFloors.count == 0 && FloorRequest.downPressedOnAllFloors.count == 0 {
            
            lift.currentState = Direction.Stationary
            
            MainController.openLifts.removeObject(lift)
            
            moveToNextInQueue(nil, lift: lift, direction: Direction.Stationary, openLiftRequest: false)
        }
    }
    
    
    func moveToNextInQueue(requestedFloor: Int?,lift : Lift, direction : Direction, openLiftRequest : Bool) {
        
        
        var liftCell : LiftCell
        
        let floorCell =  floorTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 10-lift.currentFloor, inSection: 0)) as! FloorCell
        
        if lift.number == 1 {
            liftCell = (floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? LiftCell)!
        } else {
            liftCell = (floorCell.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as? LiftCell)!
        }
        
        liftCell.setClosedLiftImage()
        
        if requestedFloor == nil {
            return
        }
        
        
        
        if direction != Direction.Stationary {
            
            let request = FloorRequest(floor: requestedFloor!, direction: direction)
            
            request.openLiftRequest = openLiftRequest
            
            addToRequestQueueForLift(lift, request: request)
            
            if MainController.openLifts.count != 0
            {
                MainController.openLifts.removeObject(lift)
            }
        }
  }

    
    
    
    
    //MARK:- TextView methods
    
    func removeFloorFromTextView(lift : Lift, floorRequest : FloorRequest) {
        
        if floorRequest.direction == Direction.GoingUp {

            if lift == FloorRequest.firstLift {
                
                editLeftUpStopQueue.text = lift.upPressedButtons.displayFloor()
                
            } else {
                
                editRightUpStopQueue.text = lift.upPressedButtons.displayFloor()
                
            }
            
        } else {
            
            if lift == FloorRequest.firstLift {
                
                editLeftDownStopQueue.text = lift.downPressedButtons.displayFloor()
                
            } else {
                
                editRightDownStopQueue.text = lift.downPressedButtons.displayFloor()
                
            }
            
        }
        
    }
    
    func appendFloorInTextView(lift: Lift, floor: FloorRequest) {
        
        if lift == FloorRequest.firstLift {
            
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
        cell.tag = indexPath.row + 1
        return cell
        
    }
    
}