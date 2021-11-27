//
//  AppSettingsACLAccountCell.swift
//  ACL
//
//  Created by RGND on 07/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class AppSettingsACLAccountCell: UITableViewCell {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var buttonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        signupButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func signupAction(_ sender: Any) {
        buttonAction?()
    }
    
}
