//
//  AppFont.swift
//  ACL
//
//  Created by RGND on 24/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import UIKit

enum AppFontType {
    case medium
    case regular
}

class AppFont {
    static func get(_ type: AppFontType, size: CGFloat) -> UIFont {
           switch type {
           case .medium:
               return UIFont(name: "Roboto-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
           case .regular:
                return UIFont(name: "Regular", size: size) ?? UIFont.systemFont(ofSize: size)
        }
       }
}
