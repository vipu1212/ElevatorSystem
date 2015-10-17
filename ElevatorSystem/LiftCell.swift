//
//  LiftCell.swift
//  ElevatorSystem
//
//  Created by Divyansh Singh on 10/10/15.
//  Copyright (c) 2015 Divyansh-Test. All rights reserved.
//

import UIKit

class LiftCell: UICollectionViewCell {
    
    @IBOutlet weak var liftImage: UIImageView!
    
    func setOpenLiftImage() {
            liftImage.image = UIImage(named: "openlift")
    }
    
    func setClosedLiftImage() {
        liftImage.image = UIImage(named: "closedlift")
    }
}