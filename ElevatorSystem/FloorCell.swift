//
//  FloorCell.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 10/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

class FloorCell: UITableViewCell {
    
    @IBOutlet weak var liftsCollectionView: UICollectionView!
    
    @IBOutlet weak var lblFloorNumber: UILabel!
    
    @IBOutlet weak var btnDown: UIButton!
    @IBOutlet weak var btnUp: UIButton!
    
    func fillCellData(ForFloor floor : Int) {
        
        if floor == 10 {
            lblFloorNumber.text = "Ground Floor"
            btnDown.hidden = true
        } else {
            if floor == 0 {
                btnUp.hidden = true
            }
        lblFloorNumber.text = "Floor \(10-floor)"
        }
    }
    
    
    @IBAction func onButtonPressed(sender: AnyObject) {
            (sender as! UIButton).backgroundColor = UIColor.greenColor()
    }
 }