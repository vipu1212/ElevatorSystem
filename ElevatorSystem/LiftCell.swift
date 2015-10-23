//
//  LiftCell.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 10/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//


import UIKit

protocol LiftFloorSelectProtocol {
    func closeLift(requestedFloor : Int?, liftNumber : Int)
}


class LiftCell: UICollectionViewCell {

    
    @IBOutlet weak var liftImage: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var floorInputTextField: UITextField!
    
    
    var delegate : LiftFloorSelectProtocol?
    

    func setOpenLiftImage() {
        
        liftImage.image = UIImage(named: "openlift")
        
        cancelButton.hidden = false
        
        floorInputTextField.hidden = false
    }
    
    
    
    func setClosedLiftImage() {
        
        liftImage.image = UIImage(named: "closedlift")
        
        cancelButton.hidden = true
        
        floorInputTextField.hidden = true
    }
    
    
    
    @IBAction func onCancel(sender: AnyObject) {
        
        floorInputTextField.resignFirstResponder()
        
        if floorInputTextField.text != "" {
            setClosedLiftImage()
            delegate?.closeLift(floorInputTextField.text.toInt(), liftNumber: self.tag)
        } else {
            delegate?.closeLift(nil, liftNumber: self.tag)
        }
        
        floorInputTextField.text = ""
    }
    
}