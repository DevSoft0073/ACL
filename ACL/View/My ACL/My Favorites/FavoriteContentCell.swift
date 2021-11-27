//
//  FavoriteContentCell.swift
//  ACL
//
//  Created by Aman on 03/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class FavoriteContentCell: UITableViewCell {

    //MARK: outlets
    @IBOutlet weak var thumbnailWidth: NSLayoutConstraint!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setUpCell(heading: String){
        if heading == "Videos" || heading == "Journal Entries"{
            thumbnailWidth.constant = 40
        }else{
            thumbnailWidth.constant = 0
        }
        
    }
    
}
