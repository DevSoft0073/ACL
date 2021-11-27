//
//  EnrollCell.swift
//  ACL
//
//  Created by Aman on 03/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class EnrollCell: UITableViewCell {
//MARK: outlets
    @IBOutlet weak var enrollBtn: UIButton!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
