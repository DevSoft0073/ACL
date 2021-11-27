//
//  CustomLabel.swift
//  ACL
//
//  Created by Rapidsofts Sahil on 23/04/21.
//  Copyright © 2021 Gagandeep Singh. All rights reserved.
//

import Foundation
import UIKit


class ShadowLabel : UILabel{
    
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0,height: 0);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 1;
    }
}
