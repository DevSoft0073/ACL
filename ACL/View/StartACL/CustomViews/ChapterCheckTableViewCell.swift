//
//  ChapterCheckTableViewCell.swift
//  ACL
//
//  Created by Rakesh Verma on 28/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class ChapterCheckTableViewCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet private weak var checkImageView: UIImageView!
    @IBOutlet  weak var chapterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override var isSelected: Bool{
        didSet{
            UIView.animate(withDuration: 0.30) {
                
                self.checkImageView.image = self.isSelected ? UIImage(named: "startan_acl_chapter_own1_checked") : UIImage(named: "startan_acl_chapter_own1_unchecked")
                self.layoutIfNeeded()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
