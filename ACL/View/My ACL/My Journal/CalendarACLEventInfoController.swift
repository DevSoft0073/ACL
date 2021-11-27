//
//  CalendarACLEventInfoController.swift
//  ACL
//
//  Created by Gagandeep on 13/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class CalendarACLEventInfoController: BaseViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var msgLbl: UILabel!
    var dateText = ""
    var isFromEnroll = false
    var linkText = ""
    
    let msg = "Please use the link below to complete the registration for the ACL live zoom event. Once approved, you will receive a unique link invitation In your EMAIL You will join from this link – not in the app. If you do not receive the invite, please contact us at aclappmgmt@aclglobal.org.\n"
    
//    let msg = "Please use the link below to register for the ACL live zoom event.  Once approved, you will receive a unique link invite to the event.  Please check your email inbox (& junk) for this email. If you do not receive it, feel free to contact us at aclappmgmt@aclglobal.org.\n"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if dateText != ""{
            dateLabel.text = dateText
        }
        if UIDevice().isRegularModel() {
            topConstraint.constant = 100
        } else if UIDevice().isPlusModel() {
            topConstraint.constant = 140
        }
        
        if isFromEnroll{
            addFeedbackLInk(text: msg, link: linkText)
        }
    }
    
    func addFeedbackLInk(text: String,link: String){
        let fullText = "\(text) LINK: \(link)"
        let string  = fullText
        var  range = NSRange()
        range   = (string as NSString).range(of: link)
        
        let attributedString  = NSMutableAttributedString(string: string)

        //attributedString.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "\(feedbackLink)")!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.white, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.white, range: range)

        msgLbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feedBackBtnTap))
        msgLbl.attributedText = attributedString
        msgLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func feedBackBtnTap(){
        if let url = URL(string: linkText), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
