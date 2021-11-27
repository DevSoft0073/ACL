//
//  ChallengeListingCell.swift
//  ACL
//
//  Created by RGND on 23/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class ChallengeListingCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
