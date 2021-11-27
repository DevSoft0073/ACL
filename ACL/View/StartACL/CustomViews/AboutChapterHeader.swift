//
//  AboutChapterHeader.swift
//  ACL
//
//  Created by Rakesh Verma on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

protocol ChapterHeaderTapped: class {
    func headerTapped(tag: Int)
}

class AboutChapterHeader: UITableViewHeaderFooterView {
    
    weak var delegate: ChapterHeaderTapped?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var plusMinusImageView: UIImageView!
    

    func setup(chapterHeader: ChapterHeader){
        titleLabel.text = chapterHeader.title
        plusMinusImageView.image = chapterHeader.isExpended ? UIImage(named: "about_acl_chapter_minus") :  UIImage(named: "about_acl_chapter_plus")
        
    }
    
    @IBAction func clickAction(_ sender: UIButton) {
        delegate?.headerTapped(tag: self.tag)
    }
}
