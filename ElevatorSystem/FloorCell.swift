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
    
    func fillCellData(ForFloor floor : Int) {
        
        if floor == 10
        {
            lblFloorNumber.text = "Ground Floor"
            btnDown.hidden = true
            
        }
        else
        {
            if floor == 0
            {
            btnUp.hidden = true
        }
            lblFloorNumber.text = "Floor \(10-floor)"
        }
        btnUp.tag = floor
        btnDown.tag = floor
    }
    
    
    @IBAction func onButtonPressed(sender: UIButton) {
        
        if sender.backgroundColor != UIColor.greenColor() {
            
        (sender as UIButton).backgroundColor = UIColor.greenColor()
        let request = LiftRequest()
        self.delegate = request
        request.delegate = MainController()
        request.leftLift = MainController.totalLifts.objectAtIndex(0) as? Lift
        request.rightLift = MainController.totalLifts.objectAtIndex(1) as? Lift
        delegate?.buttonPressed(AtFloor: (10-sender.tag), Direction: sender.restorationIdentifier!)
        }
    }
 }