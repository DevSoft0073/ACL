//
//  EmailVerifiedViewController.swift
//  ACL
//
//  Created by Aman on 12/05/21.
//  Copyright © 2021 Gagandeep Singh. All rights reserved.
//

import UIKit

protocol MailVerifiedProtcol {
    func mailVerified(isConfirmed:Bool)
}

class EmailVerifiedViewController : BaseViewController{
    //MARK: outlets
    
    @IBOutlet weak var emailTextField: DefaultTextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var noteLbl: UILabel!
    
    
    var mailVerifiedDelegate : MailVerifiedProtcol?
    var viewModel = SignupViewModel()
    var isFromGuest = Bool()
    var proFileViewModel = UpdateProfileCommunityViewModel()
    
    let noteText = "If you do not see an email from us within a minute, please check your spam/junk folder"
    
    override func viewDidLoad() {
        if isFromGuest{
            print("here is otp",proFileViewModel.otp as Any)

        }else{
            print("here is otp",viewModel.OTP as Any)

        }
        doneBtn.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        self.addBackgroundImage()
        self.configureCreatePinView()
        
    }
    
  
    
    func configureCreatePinView() {
        pinView.pinLength = 4
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 10
        pinView.textColor = UIColor.white
        pinView.backgroundColor = .clear
        pinView.shouldSecureText = true
        pinView.style = .box
        pinView.borderLineColor = UIColor.white
        pinView.activeBorderLineColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 1
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .numberPad
        // pinView.pinIinputAccessoryView = UIView()
        // pinView.placeholder = "******"
        pinView.becomeFirstResponderAtIndex = 0
        
        pinView.didFinishCallback = { [weak self] pin in
            self?.doneBtn.isEnabled = true
            self?.doneBtn.alpha = 1
        }
        
        pinView.didChangeCallback = { [weak self] pin in
//            self?.proceedButton.isEnabled = false
//            self?.proceedButton.alpha = 0.6
        }
        self.noteLbl.attributedText = setNoteLbl(note: "Note: ", text: noteText)
    }
    
    func setNoteLbl(note : String, text : String) -> NSAttributedString{
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.medium, size: 17)]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.regular, size: 16)]
        let partOne = NSMutableAttributedString(string: note, attributes: boldFontAttributes)
        let partTwo = NSMutableAttributedString(string: text, attributes: normalFontAttributes)

        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    
    //MARK: Button actions
    
    @IBAction func doneBtn(_ sender: UIButton) {
        let pin = pinView.getPin()
        if isFromGuest{
            if pin == ""{
                showError("Please enter OTP")
            }else if pin != self.proFileViewModel.otp{
                showError("Invalid OTP")
            }else{
            
                self.proFileViewModel.isMailVerified = true
                self.mailVerifiedDelegate?.mailVerified(isConfirmed: true)
                self.navigationController?.popViewController(animated: true)

            }
        }else{
            if pin == ""{
                showError("Please enter OTP")
            }else if pin != self.viewModel.OTP{
                showError("Invalid OTP")
            }else{
                self.mailVerifiedDelegate?.mailVerified(isConfirmed: true)
                self.viewModel.isMailVerified = true
                self.navigationController?.popViewController(animated: true)

            }
        }
        
       
        

        
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
