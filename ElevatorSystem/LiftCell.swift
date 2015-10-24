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
        let inputFloor = floorInputTextField.text.toInt()
       
        // Input validation check
        if inputFloor >= 0 && inputFloor < 11 {
        
            setClosedLiftImage()
            delegate?.closeLift(floorInputTextField.text.toInt(), liftNumber: self.tag)
        
        }
            else if floorInputTextField.text == "" {
    
            delegate?.closeLift(nil, liftNumber: self.tag)
        }

    
        else
        {
            let alert = UIAlertView(title: "Input Warning", message: "Enter between 0 and 10 only", delegate: self, cancelButtonTitle: "Yeah Sure !")
            
            alert.show()
        }
        
         floorInputTextField.text = ""
    }
    
}