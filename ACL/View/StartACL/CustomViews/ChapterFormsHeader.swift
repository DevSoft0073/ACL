//
//  ChapterFormsHeader.swift
//  ACL
//
//  Created by Rakesh Verma on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

protocol FormsHeaderTapped: class {
    func headerTapped(tag: Int)
}

class ChapterFormsHeader: UITableViewHeaderFooterView {

     weak var delegate: FormsHeaderTapped?
      
      @IBOutlet weak var backView: UIView!
      @IBOutlet weak var titleLabel: UILabel!
      @IBOutlet weak var plusMinusImageView: UIImageView!
      

      func setup(formsHeader: FormsHeader){
          titleLabel.text = formsHeader.title
          plusMinusImageView.image = formsHeader.isExpended ? UIImage(named: "about_acl_chapter_minus") :  UIImage(named: "acl_group_form_plus")
          
      }
      
      @IBAction func clickAction(_ sender: UIButton) {
          delegate?.headerTapped(tag: self.tag)
      }
}
