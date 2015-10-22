//
//  FloorCell.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 10/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

protocol LiftButtonProtocol {
    func buttonPressed(ForFloor floor : Int, Direction : String)
}


class FloorCell: UITableViewCell {
    
    
    @IBOutlet weak var liftsCollectionView: UICollectionView!
    @IBOutlet weak var lblFloorNumber: UILabel!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnUp: UIButton!
    
    
    var delegate : LiftButtonProtocol?
    
    func fillCellData(var floor : Int) {
        
        floor = 10 - floor
        
        if floor == 0
        {
            lblFloorNumber.text = "Ground Floor"
            btnDown.hidden = true
            
        }
        else
        {
            if floor == 10
            {
                btnUp.hidden = true
            } else
            {
                btnUp.hidden = false
                btnDown.hidden = false
            }
            lblFloorNumber.text = "Floor \(floor)"
        }
        
        checkAlreadyPressedButtons(floor)
        checkOpenLifts(floor)
        btnUp.tag = floor
        btnDown.tag = floor
        
    }
    
    
    func checkAlreadyPressedButtons(floor : Int) {
        
        for button in FloorRequest.upPressedOnAllFloors {
            if button as! Int == floor {
                btnUp.backgroundColor = UIColor.greenColor()
                break
            } else {
                btnUp.backgroundColor = UIColor.yellowColor()
            }
        }
        
        for button in FloorRequest.downPressedOnAllFloors {
            if (button as! Int) == floor {
                btnDown.backgroundColor = UIColor.greenColor()
                break
            } else {
                btnDown.backgroundColor = UIColor.yellowColor()
            }
        }
    }
    
    func checkOpenLifts(floor : Int) {
        
        for openLift in MainController.openLifts {
            
            var liftCell : LiftCell
            
            if (openLift as! Lift).currentFloor == floor {
                
                if (openLift as! Lift).number == 1 {
                    
                    liftCell = (self.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? LiftCell)!
                    liftCell.setOpenLiftImage()
                    break
                } else {
                    liftCell = (self.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 0)) as? LiftCell)!
                    liftCell.setOpenLiftImage()
                    break
                }
            } else {
                
                var visibleLifts = self.liftsCollectionView.visibleCells()
                
                for lift in visibleLifts {
                    
                var liftPosition = lift.tag - 1
                    
                liftCell = (self.liftsCollectionView.cellForItemAtIndexPath(NSIndexPath(forItem: liftPosition, inSection: 0)) as? LiftCell)!
                
                liftCell.setClosedLiftImage()
                }
            }
        }
    }

    
    @IBAction func onButtonPressed(sender: UIButton) {
        
        if sender.backgroundColor != UIColor.greenColor() {
        
            if FloorRequest.firstLift?.currentFloor != sender.tag && FloorRequest.secondLift?.currentFloor != sender.tag
            {
                (sender as UIButton).backgroundColor = UIColor.greenColor()
            }
            
            
            
        
            
        let request = FloorRequest()
            
        self.delegate = request
            
        let mainController =  (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController
            
        request.delegate = mainController as! MainController

        delegate?.buttonPressed(ForFloor: (sender.tag), Direction: sender.restorationIdentifier!)
        }
    }
    
    func toggleButtonColor(direction : Direction) {
        
        if direction == Direction.GoingUp {
        btnUp.backgroundColor = UIColor.yellowColor()
        } else {
        btnDown.backgroundColor = UIColor.yellowColor()
        }
    }
 }