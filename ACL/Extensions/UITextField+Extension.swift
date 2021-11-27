//
//  UITextField+Extension.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

@IBDesignable
extension UITextField {
    
    @IBInspectable
    var leftIcon: UIImage {
        get {
            return UIImage()
        }
        set {
            setLeftView(newValue, width: 60)
        }
    }
    @IBInspectable
    var leftIconWidth: CGFloat {
           get {
            return 0.0
           }
           set {
            self.leftView?.frame.size.width = newValue
           }
       }
    
    @IBInspectable
    var leftIconSize: CGFloat {
        get {
            return 20
        }
        set {
            self.leftView?.subviews.filter({$0.isKind(of: UIImageView.self)}).first?.frame = CGRect(x: 20, y: (20-newValue)/2, width: newValue, height: newValue)
        }
    }
    
    @IBInspectable
    var placeHolderColor: UIColor {
        get {
            return UIColor.white
        }
        set {
            // change color if placeholder text provided
            if let placeHolderText = self.placeholder {
                attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: [NSAttributedString.Key.foregroundColor: newValue])
            }
        }
    }
    
    @IBInspectable
    var rightText: String {
        get {
            return ""
        }
        set {
            rightLabel(newValue)
        }
    }
    
    @IBInspectable
    var rightIcon: UIImage {
        get {
            return UIImage()
        }
        set {
            setRighttView(newValue)
        }
    }
    
//    @IBInspectable
//    var rightTextFont: UIFont {
//        get {
//            return UIFont.systemFont(ofSize: 10)
//        }
//        set {
//            (self.rightView?.subviews.filter({$0.isKind(of: UILabel.self)}).first as? UILabel)?.font.si = rightTextFont
//        }
//    }
    
    func rightLabel(_ text: String)  {
        let width: CGFloat = 120
        let gap: CGFloat = 20
        let label = UILabel(frame: CGRect(x: self.bounds.maxX - (width + gap), y: 0, width: width, height: 20))
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .lightGray
        self.rightView = label
        self.rightViewMode = .always
    }
    
    /// setup left view
    func setRighttView(_ icon: UIImage?) {
        // create left view
        let rightview = UIView(frame: CGRect(x: 20, y: 0, width: 60, height: 20))
        // create image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        // set frame
        imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        
        // set icon
        if let image = icon {
            imageView.image = image
        }
        rightview.addSubview(imageView)
        // set left view
        self.rightView = rightview
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.rightViewDidTap))
        tapGesture.numberOfTapsRequired = 1
        
        self.rightView?.isUserInteractionEnabled = true
        self.rightView?.addGestureRecognizer(tapGesture)
        
        rightViewMode = .always
    }
    
    @objc func rightViewDidTap() {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("TextFieldRightViewTapped"), object: nil)
    }
    
    
    /// setup left view
    func setLeftView(_ icon: UIImage?, width: CGFloat) {
        // create left view
        let leftview = UIView(frame: CGRect(x: 20, y: 0, width: width, height: 20))
        // create image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        // set frame
        imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        
        // set icon
        if let image = icon {
            imageView.image = image
        }
        leftview.addSubview(imageView)
        // set left view
        leftView = leftview
        leftViewMode = .always
    }
    
    /// setup left view
    func setLeftView(_ icon: UIImage?, frame: CGRect?) {
        // create left view
        let leftview = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 20))
        // create image view
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        // set frame
        if let imageViewFrame = frame {
            imageView.frame = imageViewFrame
        } else {
            imageView.frame = CGRect(x: 15, y: 0, width: 20, height: 20)
        }
        
        // set icon
        if let image = icon {
            imageView.image = image
        }
        leftview.addSubview(imageView)
        // set left view
        leftView = leftview
        leftViewMode = .always
    }
    
    /// setup left view
    func setLeftView( _ space: Double? = 0) {
        // create left view
        let leftview = UILabel(frame: CGRect(x: space ?? 0, y: 0, width: 20, height: 20))
        leftview.contentMode = .scaleAspectFit
        // set left view
        leftView = leftview
        leftViewMode = .always
    }
    
}
