//
//  ACLExercisesTableCell.swift
//  ACL
//
//  Created by Gagandeep on 19/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

protocol  ACLExercisesTableCellDelegate: class{
    func titleDidTap(selectedText : String,selectedTitleId : String, isFav : String)
}

class ACLExercisesTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var checkButton: UIButton!
    
    weak var delegate: ACLExercisesTableCellDelegate?
    
    var selectedId = ""
    var isFavourite = ""
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @objc func titleDidTap() {
        delegate?.titleDidTap(selectedText: textView.text, selectedTitleId: selectedId, isFav: isFavourite)
    }
    
    func setup(_ excercise: Exercise) {
        titleLabel.text = excercise.title
        if let text = excercise.summary {
            textView.text = text
            textViewHeight.constant = 85
        } else {
            textViewHeight.constant = 0
        }
        self.selectedId = excercise.id ?? ""
        isFavourite = excercise.isFavourite ?? "0"
        let tap = UITapGestureRecognizer(target: self, action: #selector(titleDidTap))
        tap.numberOfTapsRequired = 1
        
        titleLabel.addGestureRecognizer(tap)
        titleLabel.isUserInteractionEnabled = true
        textView.addGestureRecognizer(tap)
        textView.isUserInteractionEnabled = true
        
        if excercise.isChecked == true{
            self.checkButton.setBackgroundImage(UIImage(named: "acl_exercise_checkmark"), for: .normal)
        }else{
            self.checkButton.setBackgroundImage(UIImage(named: "question_screen_checkmark"), for: .normal)
        }
        
    }
}
