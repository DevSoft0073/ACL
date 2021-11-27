//
//  ACLExercisePopupTableCell.swift
//  ACL
//
//  Created by Gagandeep on 19/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

protocol ACLExercisePopupTableCellDelegate: class{
    func crossDidTap()
}

class ACLExercisePopupTableCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backView: UIView!
    
    weak var delegate: ACLExercisePopupTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
       
    }
    
    func applyGradiants() {
        print("applyGradiants called")
        backView.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        delegate?.crossDidTap()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
