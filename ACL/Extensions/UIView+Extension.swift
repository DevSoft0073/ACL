//
//  UIView+Extension.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    // Corner radius
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // Border width
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // Border color
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    // Shadow radius
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    // Shadow opactity
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    // Shadow offset
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    // Shadow color
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func setLayer(){
        self.layer.cornerRadius = 7
           self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
           self.layer.borderWidth = 0.7
           self.clipsToBounds = true
    }
    
    func fadeIn(duration: TimeInterval = 2, delay: TimeInterval = 4, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 2, delay: TimeInterval = 3, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
    
}

extension NSObject {
    var classname: String {
       return String(describing: self)
    }
}

extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = self.cornerRadius
        gradient.colors = colours.map { $0.cgColor }
        if let loc = locations {
            gradient.locations = loc
        } else {
            gradient.startPoint = CGPoint(x: 0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1, y: 0.5)
        }
        
        if let subLayers = self.layer.sublayers {
            for sublayer in  subLayers {
                if sublayer.isKind(of: CAGradientLayer.self) {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
        
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    @discardableResult
     func applyGradientTopLeftToBottonRight(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
         let gradient: CAGradientLayer = CAGradientLayer()
         gradient.frame = self.bounds
         gradient.cornerRadius = self.cornerRadius
         gradient.colors = colours.map { $0.cgColor }
         if let loc = locations {
             gradient.locations = loc
         } else {
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1)
         }
         
         if let subLayers = self.layer.sublayers {
             for sublayer in  subLayers {
                 if sublayer.isKind(of: CAGradientLayer.self) {
                     sublayer.removeFromSuperlayer()
                 }
             }
         }
         
         self.layer.insertSublayer(gradient, at: 0)
         return gradient
     }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
         
         var viewsDictionary = [String: UIView]()
         
         for (index, view) in views.enumerated() {
             let key = "v\(index)"
             view.translatesAutoresizingMaskIntoConstraints = false
             viewsDictionary[key] = view
         }
         
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
         
     }
}



extension UIView{
    func animShow(backView : UIView){
        self.alpha = 0.1
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.alpha = 1
                        self.center.y = backView.center.y
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
         self.alpha = 0.2
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()
        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}


extension UIView {
func hideWithAnimation(hidden: Bool) {
    if hidden == true{
        self.alpha = 0
    }else{
        self.alpha = 1
    }
        UIView.transition(with: self, duration: 0.4, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    }
}
