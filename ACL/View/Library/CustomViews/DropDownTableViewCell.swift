//
//  DropDownTableViewCell.swift
//  ACL
//
//  Created by Rakesh Verma on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class DropDownTableViewCell: UITableViewCell {
    @IBOutlet var dropDownLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
