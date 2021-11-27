//
//  AppSettingsUpdateProfileCell.swift
//  ACL
//
//  Created by RGND on 07/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class AppSettingsUpdateProfileCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var profilePicImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var chapterLbl: UILabel!
    
    var buttonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        updateButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        buttonAction?()
    }
    
}
