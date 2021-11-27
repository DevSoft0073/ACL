//
//  UpdateProfileCommunityMessageController.swift
//  ACL
//
//  Created by RGND on 16/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

protocol UpdateProfileCommunityMessageDelegate: class {
    func signupDidTap()
}

class UpdateProfileCommunityMessageController: UIViewController {

    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    
    weak var delegate: UpdateProfileCommunityMessageDelegate?
    var isFromMYACL = false
    var guestText = ""
    var isFromJournal = false
    var isFromEnroll = false
    var isGuestFirstPopup = false
    var guestFeedbackText = "Guests cannot complete feedback or attend live meetings. Please click here to convert to an ACL Community account to enjoy these features: click here to sign up for free. If you need to contact us for another reason, please use our Contact Us form here: Click here"
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(UINib(nibName: "UpdateProfileCommunitryMessageCell", bundle: nil), forCellWithReuseIdentifier: "UpdateProfileCommunitryMessageCell")
        }
    }
    
    func setupPagerView() {
        pagerView.transformer = FSPagerViewTransformer(type: .cubic)
        pagerView.itemSize = FSPagerView.automaticSize // CGSize(width: pagerView.bounds.width - 40, height: 200)
        
        pagerView.interitemSpacing = 20
        pagerView.decelerationDistance = 2
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.numberOfPages = 2
        pageControl.currentPage = 0
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 10
        pageControl.setFillColor(UIColor.white, for: .selected)
        pageControl.setStrokeColor(UIColor.white, for: .normal)
    }
    
    func setupPagerViewForACL() {
        pagerView.transformer = FSPagerViewTransformer(type: .cubic)
        pagerView.itemSize = FSPagerView.automaticSize // CGSize(width: pagerView.bounds.width - 40, height: 200)
        
//        pagerView.interitemSpacing = 20
//        pagerView.decelerationDistance = 2
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.numberOfPages = 1
        pageControl.isHidden = true
        pageControl.currentPage = 0
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 10
        pageControl.setFillColor(UIColor.white, for: .selected)
        pageControl.setStrokeColor(UIColor.white, for: .normal)
    }
    
    func setupPagerViewForFirstPopupForGuest() {
        pagerView.transformer = FSPagerViewTransformer(type: .cubic)
        pagerView.itemSize = FSPagerView.automaticSize // CGSize(width: pagerView.bounds.width - 40, height: 200)
        
//        pagerView.interitemSpacing = 20
//        pagerView.decelerationDistance = 2
        pagerView.delegate = self
        pagerView.dataSource = self
        pageControl.numberOfPages = 1
        pageControl.isHidden = true
        pageControl.currentPage = 0
        pageControl.itemSpacing = 10
        pageControl.interitemSpacing = 10
        pageControl.setFillColor(UIColor.white, for: .selected)
        pageControl.setStrokeColor(UIColor.white, for: .normal)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isGuestFirstPopup{
            self.setupPagerViewForFirstPopupForGuest()
        }else{
            if isFromMYACL{
               setupPagerViewForACL()
            }else{
                setupPagerView()

            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        pagerView.applyGradient(colours: [AppTheme.lightPurple, AppTheme.darkPurple])
    }
    
    @IBAction func crossAction(_ sender: Any) {
        if isFromJournal{
            Singleton.sharedInstance.isGuestCheckedNotice = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func addFeedbackLInk(text: String , lbl : UILabel){
        let string  = text
        var  range = NSRange()
      
        range   = (string as NSString).range(of: "Click here")
        
        
        let attributedString  = NSMutableAttributedString(string: string)

        //attributedString.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "\(feedbackLink)")!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.white, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.white, range: range)

        lbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feedBackBtnTap))
        lbl.attributedText = attributedString
        lbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func feedBackBtnTap(){
            openwebLink(controller: self, link: "https://forms.gle/3dBU4WMQq7uWLTfb9")

    }
    
    
}
extension UpdateProfileCommunityMessageController: FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        if isFromMYACL || isGuestFirstPopup{
            return 1
        }else{
            return 2
        }
       
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        if let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "UpdateProfileCommunitryMessageCell", at: index) as? UpdateProfileCommunitryMessageCell {
            if isFromMYACL || isGuestFirstPopup{
                if isFromMYACL{
                    cell.titleLabel.text = guestText

                }else{
                    self.addFeedbackLInk(text: self.guestFeedbackText, lbl: cell.titleLabel)
                }
            }else{
                if index == 0 {
                    var txt = ""
                    if isFromEnroll{
                        txt = "Living ACL "
                    }else{
                        txt = "ACL Community Member "
                    }
                    cell.titleLabel.text = "\(txt)invites you to participate in the Live ACL Events, Post in the Thought Garden, gives access to all current & future communicative features of the ACL App"
                    //pagerView.itemSize = CGSize(width: pagerView.bounds.width - 40, height: 200)
                } else if index == 1 {
                    cell.titleLabel.text = "These privileges are Free, and we will need to know you are a real person. Please provide a few additional details for your ACL Community Account"
                    // pagerView.itemSize = CGSize(width: pagerView.bounds.width - 40, height: 300)
                }
            }
            
            
            cell.buttonction = {
                self.dismiss(animated: true) {
                    self.delegate?.signupDidTap()
                }
            }
            
            return cell
        }

        return FSPagerViewCell()
    }
    
}


extension UpdateProfileCommunityMessageController: FSPagerViewDelegate {
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
       // pageControl.currentPage = pagerView.currentIndex
       
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        guard let customCell = cell as? UpdateProfileCommunitryMessageCell else {
            return
        }
        
        if isFromMYACL || isGuestFirstPopup{
          
            customCell.messageView.isHidden = false
            customCell.buttonView.isHidden = false

        }else{
            if index == 0 {
                customCell.messageView.isHidden = true
                customCell.buttonView.isHidden = true
            } else if index == 1 {
                customCell.messageView.isHidden = false
                customCell.buttonView.isHidden = false
            }

        }
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        pageControl.currentPage = pagerView.currentIndex
    }
}
