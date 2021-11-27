//
//  UIButton+Extension.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
@IBDesignable

extension UIButton {

    func addUnderLine() {
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: self.currentTitle ?? "", attributes: attributes)
        self.titleLabel?.attributedText = attributedText
    }
    
    func addUnderLine(with color: UIColor) {
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.underlineColor: color] as [NSAttributedString.Key : Any]
        let attributedText = NSAttributedString(string: self.currentTitle ?? "", attributes: attributes)
        self.titleLabel?.attributedText = attributedText
    }
    
    func disable() {
        self.alpha = 0.6
        self.isUserInteractionEnabled = false
    }
    
    func enable() {
        self.alpha = 1.0
        self.isUserInteractionEnabled = true
    }
    
    func addShadow(){
        self.backgroundColor = UIColor(red: 171/255, green: 178/255, blue: 186/255, alpha: 1.0)
        // Shadow Color and Radius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
    }
    
}
