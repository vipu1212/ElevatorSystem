//
//  ViewController.swift
//  ElevatorSystem
//
//  Created by Divyansh-Test on 09/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

class MainController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, LiftCallProtocol {

    
    @IBOutlet weak var lblLeftCurrentFloor: UILabel!
    
    @IBOutlet weak var lblRightCurrentFloor: UILabel!
    
    @IBOutlet weak var editLeftUpStopQueue: UITextView!
    
    @IBOutlet weak var editRightUpStopQueue: UITextView!
    
    @IBOutlet weak var editRightDownStopQueue: UITextView!
    
    @IBOutlet weak var editLeftDownStopQueue: UITextView!
    
    static var totalLifts : NSMutableArray = NSMutableArray(array: [])
    
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
        lift.pressedButtons.addObject(floor.currentFloor!)
        
        if lift == leftLift {
            if floor.direction == LiftState.GoingUp {
                
            editLeftUpStopQueue.text = editLeftUpStopQueue.text + ("\(floor.currentFloor!)  ")
            }
            else {
        
               editLeftDownStopQueue.text = editLeftDownStopQueue.text + ("\(floor.currentFloor!)  ")
            }
        }
        else {
            if floor.direction == LiftState.GoingUp {
                
                editRightUpStopQueue.text = editRightUpStopQueue.text + ("\(floor.currentFloor!)  ")
            }
            else {
                
                editRightDownStopQueue.text = editRightDownStopQueue.text + ("\(floor.currentFloor!)  ")
            }
        }
    }
}

