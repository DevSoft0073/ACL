//
//  String+Extension.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func isValidEmailAddress() -> Bool {

        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                return false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    func getHtmpString(color: UIColor) -> NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
             let rr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let p = NSMutableAttributedString(attributedString: rr)
            var attributes = [NSAttributedString.Key: AnyObject]()
            attributes[.foregroundColor] = UIColor.white
            p.addAttributes(attributes, range: NSMakeRange(0, self.count))
            
            return p
        } catch {
            return NSAttributedString()
        }
    }
    
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    
    
    func empty() -> String {
        return ""
    }
    
    func noMessage() -> String {
        return ""
    }
}


extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension UILabel {
    func underline() {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
    func underlineWithoutBrackets(RangeText: String) {
        if let textString = self.text {
            let range = (textString as NSString).range(of: RangeText)
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: range)
          attributedText = attributedString
        }
    }

}


class ACLTextCustom:UILabel{
    override  func awakeFromNib() {
//        self.textColor = UIColor.colorFromHex("4169c8")
        self.textColor = .black
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0,height: 0);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 1;
    }
    
}
