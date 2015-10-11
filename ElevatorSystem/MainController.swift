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
    
    @IBOutlet weak var editLeftStopQueue: UITextView!
    
    @IBOutlet weak var editRightStopQueue: UITextView!
    
    static var totalLifts : NSMutableArray = NSMutableArray(array: [])
    
    var leftLift = Lift(LiftNumber: 1)
    var rightLift = Lift(LiftNumber: 2)
    
    var liftCallSystem = LiftCallSystem()
    
    override func viewDidAppear(animated: Bool) {
        
        MainController.totalLifts.addObjectsFromArray([leftLift.number, rightLift.number])
        liftCallSystem.delegate = self
        liftCallSystem.leftLift = leftLift
        liftCallSystem.rightLift = rightLift
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
        cell.delegate = liftCallSystem
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
    
    func addToRequestQueueForLift(lift: Int) {
        
    }
}

