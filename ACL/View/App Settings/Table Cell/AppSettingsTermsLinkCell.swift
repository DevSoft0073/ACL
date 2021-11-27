//
//  AppSettingsTermsLinkCell.swift
//  ACL
//
//  Created by Aman on 21/05/21.
//  Copyright © 2021 Gagandeep Singh. All rights reserved.
//

import UIKit

class AppSettingsTermsLinkCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var termsBtn: UIButton!
    
    var buttonAction: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func termsBtn(_ sender: UIButton) {
        buttonAction?()
    }
}
