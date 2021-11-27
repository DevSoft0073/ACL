//
//  CongratsView.swift
//  ACL
//
//  Created by Aman on 09/06/21.
//  Copyright © 2021 Gagandeep Singh. All rights reserved.
//

import UIKit

class CongratsView: UIView {

    var buttonAction: (()->())?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBAction func donateBtnAction(_ sender: UIButton) {
        buttonAction?()
    }
    
}
