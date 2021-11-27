//
//  UpdateProfileCommunitryMessageCell.swift
//  ACL
//
//  Created by RGND on 16/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class UpdateProfileCommunitryMessageCell: FSPagerViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    var buttonction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        signupButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
    }

    @IBAction func signupAction(_ sender: Any) {
        buttonction?()
    }
}
