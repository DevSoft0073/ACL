//
//  AppTheme.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import UIKit

class AppTheme {
    /// Colors used on buttons
    static let lightPurple = UIColor(displayP3Red: 149/255, green: 96/255, blue: 222/255, alpha: 1) //8768d5
    static let darkPurple = UIColor(displayP3Red: 83/255, green: 80/255, blue: 162/255, alpha: 1)
    static let mediumPurple = UIColor(displayP3Red: 97/255, green: 93/255, blue: 181/255, alpha: 1)
    
    static let lightDullPurple = UIColor(displayP3Red: 124/255, green: 112/255, blue: 183/255, alpha: 1)
    static let lightOrange = UIColor(displayP3Red: 222/255, green: 119/255, blue: 131/255, alpha: 1)
    static let lightGreen = UIColor(displayP3Red: 90/255, green: 172/255, blue: 104/255, alpha: 1)

    static let mustered = UIColor(displayP3Red: 108/255, green: 100/255, blue: 104/255, alpha: 1)
    static let darkBlue = UIColor(displayP3Red: 26/255, green: 30/255, blue: 47/255, alpha: 1)
    static let lightBlue = UIColor(displayP3Red: 50/255, green: 50/255, blue: 57/255, alpha: 1)
    
    static let megenta = UIColor(displayP3Red: 173/255, green: 62/255, blue: 123/255, alpha: 1)
    
    // My Journal
    static let lightSteel = UIColor(displayP3Red: 94/255, green: 117/255, blue: 184/255, alpha: 1)
    static let darkSteel = UIColor(displayP3Red: 54/255, green: 75/255, blue: 138/255, alpha: 1)
    
    // Calendar
    static let steelGray = UIColor(displayP3Red: 188/255, green: 186/255, blue: 191/255, alpha: 1)
    static let burgundyColor = UIColor(displayP3Red: 128/255, green: 0/255, blue: 32/255, alpha: 1)
    
    struct Transparent {
        static let darkBlue = UIColor(displayP3Red: 26/255, green: 30/255, blue: 47/255, alpha: 1)
        static let lightBlue = UIColor(displayP3Red: 50/255, green: 50/255, blue: 57/255, alpha: 0.8)
        static let lightPurple = UIColor(displayP3Red: 69/255, green: 68/255, blue: 97/255, alpha: 0.6)
        static let darkPurple = UIColor(displayP3Red: 57/255, green: 60/255, blue: 80/255, alpha: 0.9)
    }
}

extension UIColor {
    
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static func colorFromHex(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.magenta
        }
        
        var rgb: UInt32 = 0
        Scanner.init(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
   
}


//<color name="colorBlack_13">#131D20</color> // black
//
//<color name="colorGray_5b">#5B5B5B</color> // gray dark
//<color name="dividerColor">#2C3650</color> // navi blue
//<color name="progressColor">#FF6131</color> // orange
//
//<color name="redColor">#FF5630</color> // orange dark 1
//<color name="colorRedDark">#DD3333</color>
//
//<color name="colorPurple">#5C1DDA</color>
//<color name="colorBlueDark">#173D9E</color>
//<color name="switchBgColor">#2358a1</color>
//<color name="whiteTransparent">#60FFFFFF</color>
//<color name="inputColor">#1A1A1A</color>
//<color name="transparent">#2358a100</color>
//ƒ
//<color name="colorGreen">#82FF2F</color>
//<color name="account_pop_up_transparent">#555374</color>
//<color name="footer_color">#624d93</color>
