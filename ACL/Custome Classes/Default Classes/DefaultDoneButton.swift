//
//  DefaultDoneButton.swift
//  ACL
//
//  Created by RGND on 20/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class DefaultDoneButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setArrow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setArrow()
    }
    
    func setArrow() {
        let image = UIImage(named: "Account white arrow")
        let arrowImage = UIImageView(image: image)
        arrowImage.contentMode = .scaleAspectFit
        self.addSubview(arrowImage)
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -16)
        let widthConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 16)
        let topConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 12)
        let bottomConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -12)
        
//        let heightConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.5, constant: 0)
//        let horizontalConstraint = NSLayoutConstraint(item: arrowImage, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:20)
        
        self.addConstraints([trailingConstraint, bottomConstraint, widthConstraint, topConstraint])
    }
}
