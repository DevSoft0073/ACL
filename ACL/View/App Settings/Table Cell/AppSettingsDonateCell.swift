//
//  AppSettingsDonateCell.swift
//  ACL
//
//  Created by RGND on 15/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class AppSettingsDonateCell: UITableViewCell {

    var buttonAction: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func donateAction(_ sender: Any) {
        buttonAction?()
    }
    
}
