//
//  FloorCell.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 10/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

protocol LiftButtonProtocol {
    func buttonPressed(AtFloor floor : Int, Direction : String)
}


class FloorCell: UITableViewCell {
    
    
    @IBOutlet weak var liftsCollectionView: UICollectionView!
    @IBOutlet weak var lblFloorNumber: UILabel!
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnUp: UIButton!
    
    var delegate : LiftButtonProtocol?
    
    func fillCellData(var ForFloor floor : Int) {
        
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
            } else {
                btnUp.hidden = false
                btnDown.hidden = false
            }
            lblFloorNumber.text = "Floor \(floor)"
        }
        
        checkAlreadyPressedButtons(floor)
        
        btnUp.tag = floor
        btnDown.tag = floor
    }
    
    func checkAlreadyPressedButtons(floor : Int) {
        
        for button in LiftRequest.upPressedOnAllFloors {
            if button as! Int == floor {
                
                btnUp.backgroundColor = UIColor.greenColor()
                break
            } else {
                btnUp.backgroundColor = UIColor.yellowColor()
            }
        }
        
        for button in LiftRequest.downPressedOnAllFloors {
            if (button as! Int) == floor {
                btnDown.backgroundColor = UIColor.greenColor()
                break
            } else {
                btnDown.backgroundColor = UIColor.yellowColor()
            }
        }
    }
    
    
    @IBAction func onButtonPressed(sender: UIButton) {
        
        if sender.backgroundColor != UIColor.greenColor() {
            
        (sender as UIButton).backgroundColor = UIColor.greenColor()
            
        let request = LiftRequest()
            
        self.delegate = request
            
        let mainController =  (UIApplication.sharedApplication().delegate as! AppDelegate).window!.rootViewController
            
        request.delegate = mainController as! MainController
        request.leftLift = MainController.totalLifts.objectAtIndex(0) as? Lift
        request.rightLift = MainController.totalLifts.objectAtIndex(1) as? Lift
        delegate?.buttonPressed(AtFloor: (sender.tag), Direction: sender.restorationIdentifier!)
        }
    }
 }