//
//  CalendarCell.swift
//  ACL
//
//  Created by Gagandeep on 12/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dotLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dotLbl.layer.cornerRadius =  dotLbl.frame.width/2
        dotLbl.layer.masksToBounds = true
        dotLbl.backgroundColor = .red
    }

}
