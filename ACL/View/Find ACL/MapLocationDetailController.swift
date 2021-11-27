//
//  MapLocationDetailController.swift
//  ACL
//
//  Created by RGND on 25/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import MessageUI

class MapLocationDetailController: BaseViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var meetLabel: UILabel!
    
    @IBOutlet weak var leaderNameLabel: UILabel!
    @IBOutlet weak var leaderView: UIStackView!
    
    @IBOutlet weak var coLeaderNameLabel: UILabel!
    @IBOutlet weak var coLeaderView: UIStackView!
    
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeView: UIStackView!
    
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var joinLinkLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var crossButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var wecomeBottomConstraint: NSLayoutConstraint!
     @IBOutlet weak var wecomeTopConstraint: NSLayoutConstraint!
    
    
    var viewModel = FinalACLViewModel()
    var mail = ""
    var isFromFavList = false
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromFavList == true{
            viewModel.selectedACLId = selectedId
        }
        
        SwiftLoader.show(animated: true)
        viewModel.getACLInfo { status, message in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                self.setupView()
            }
        }
        
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone6, .iPhone7, .iPhone6S, .iPhone8 :
            bottomViewHeightConstraint.constant = 40
            topViewHeightConstraint.constant = 160
            placeLabelTopConstraint.constant = 60
            crossButtonTopConstraint.constant = 20
            wecomeBottomConstraint.constant = 5
            wecomeTopConstraint.constant = 5
            
        case .iPhone7Plus, .iPhone8Plus:
            bottomViewHeightConstraint.constant = 50
            topViewHeightConstraint.constant = 180
            placeLabelTopConstraint.constant = 70
            crossButtonTopConstraint.constant = 30
            wecomeBottomConstraint.constant = 10
            wecomeTopConstraint.constant = 20
            
        default: break
        }
        
        // Do any additional setup after loading the view.
        joinLinkLabel.isUserInteractionEnabled = true
        joinLinkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnJoinLink(_:))))
        
    }
    
    
    
    func setupView() {
        guard let acl = viewModel.selectedACL else {
            return
        }
        
        if let imageName = acl.image {
            self.titleImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: "Madrid Event screen_top_banner"), completed: nil)
        }
//        let time = acl.group_started?.westernArabicNumeralsOnly
//        let now = Date.init(timeIntervalSinceReferenceDate: Double(time ?? "0") ?? 0)
//        let formatter = DateFormatter()
//        formatter.timeZone = TimeZone.current
//        formatter.dateFormat = "MM-dd-yyyy"
//        let dateString = formatter.string(from: now)
        
//        self.startTimeLabel.text = "Group Started \(dateString)"
        self.startTimeLabel.text = acl.group_started ?? ""

        self.meetLabel.text = "Meets " + (acl.meet ?? "")
        self.leaderNameLabel.text = acl.leader
        self.coLeaderNameLabel.text = acl.co_leader
        let txt = acl.place?.html2String
        self.placeAddressLabel.text = txt
        self.contactButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.contactButton.titleLabel?.numberOfLines = 2
        self.contactButton.setTitle(acl.join_link, for: .normal)
        //self.joinLinkLabel.text = acl.join_link
        self.welcomeLabel.text = acl.welcomeText
        if acl.chapterType?.rawValue == 1{
            self.placeView.isHidden = true
            self.meetLabel.isHidden = true
            self.startTimeLabel.isHidden = true
            self.contactButton.setTitle("Private Chapter", for: .normal)
            self.contactButton.isUserInteractionEnabled = false
            self.welcomeLabel.isHidden = true
            self.messageLabel.isHidden = true
            
        }
       // self.messageLabel.text = "If u Want to Connect More Deeply, With Yourself with Others and want more meaningful and passionate life.."
        self.mail = acl.contact ?? ""
        if acl.isFavourite == "0"{
           self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
        }else{
            self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
        }
        
        // set underline text on acl title
        self.placeLabel.text = acl.name
        // set html text on bottom message label
        if let attString = acl.aclDescription?.htmlToAttributedString {
            self.messageLabel.attributedText = getAttributedDescription(from: attString, font: AppFont.get(.regular, size: 14))
        }
        if acl.aclDescription != nil{
            self.messageLabel.text = acl.aclDescription ?? ""
        }
        
        
    }
    
    func canOpenURL(_ string: String?) -> Bool {
        guard let urlString = string,
            let url = URL(string: urlString)
            else { return false }

        if !UIApplication.shared.canOpenURL(url) { return false }

        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    @objc func handleTapOnJoinLink(_ tap: UITapGestureRecognizer){
        if joinLinkLabel.text?.contains("http") ?? false{
            if  canOpenURL(joinLinkLabel.text ?? "") == true{
                let url = URL(string: joinLinkLabel.text!)
                UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                    print("Open url : \(success)")
                })
            }
        }else{
            let txt = "http://\(joinLinkLabel.text ?? "")"
            if  canOpenURL(txt) == true{
                          let url = URL(string: txt)
                     UIApplication.shared.open(url!, options: [:], completionHandler: { (success) in
                            print("Open url : \(success)")
                })
            }
        }
        
    }
    
    
    @IBAction func crossAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func emailAction(_ sender: Any) {
        
    }
    @IBAction func favBtnClick(_ sender: UIButton) {
        SwiftLoader.show(animated: true)
        
        viewModel.addFavourite(id: viewModel.selectedACLId ?? "") { (isSucess, str) in
            SwiftLoader.hide()
            if isSucess{
                if self.favButton.imageView?.image == UIImage(named: "main_screen_star"){
                self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
                }else{
                self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
                }
            }
        }
    }
    
    
    
    
    @IBAction func contactAction(_ sender: Any) {
        guard let acl = viewModel.selectedACL else {
            return
        }
        
        if acl.join_link != nil && acl.join_link != ""{
            
            let trimmedString = acl.join_link!.components(separatedBy: .whitespacesAndNewlines).joined()
            if isValidUrl(str: trimmedString){
                let url = URL(string: trimmedString)
                if isValidEmail(trimmedString){
                    getMail(address: trimmedString)
                }else{
                    if  UIApplication.shared.canOpenURL(url!){
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                }
                
            }else{
                getMail(address: trimmedString)
            }
        }else if acl.contact != nil && acl.contact != ""{
            let url:URL = URL(string: "tel://\(acl.contact!)")!
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    
            } else {
                 // Put your error handler code...
            }
        }else{
            getMail(address: acl.contact ?? "")
        }
        
        
    }
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    func getMail(address:String){
        if MFMailComposeViewController.canSendMail(){
            let composeVC = MFMailComposeViewController()
               composeVC.mailComposeDelegate = self
               composeVC.setToRecipients([address])
//               composeVC.setSubject("Message Subject")
//               composeVC.setMessageBody("Message content.", isHTML: false)

               // Present the view controller modally.
               self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    
    func getAttributedDescription(from: NSAttributedString, font: UIFont) -> NSMutableAttributedString {
        // get text range
        let range = NSRange(location: 0, length: from.length)
        // create attributed string
        let attribute = NSMutableAttributedString.init(attributedString: from)
        // set text color
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkGray , range: range)
        // set text font
        attribute.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        
        // set text alignment
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        attribute.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle , range: range)
        
        return attribute
    }
    
    func isValidUrl(str: String) -> Bool {
        var isTrue = false
        do{
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
         
            if let match = detector.firstMatch(in: str, options: [], range: NSRange(location: 0, length: str.utf16.count)) {
                // it is a link, if the match covers the whole string
                 isTrue = match.range.length == str.utf16.count
            } else {
                isTrue = false
            }

        }
        catch{
            print("error")
        }
        return isTrue
    }
}

extension MapLocationDetailController{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)

//        switch result{
//
//        case .cancelled:
//            <#code#>
//        case .saved:
//            <#code#>
//        case .sent:
//            <#code#>
//        case .failed:
//            <#code#>
//        }
    }
}
extension String {
    var validURL: Bool {
        get {
            let regEx = "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
            let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
            return predicate.evaluate(with: self)
        }
    }
}

extension String {
    var westernArabicNumeralsOnly: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
                        .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
}
