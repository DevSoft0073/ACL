//
//  SignupSuccessViewController.swift
//  ACL
//
//  Created by RGND on 07/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class SignupSuccessViewController: BaseViewController {

    @IBOutlet weak var buttonTop: NSLayoutConstraint!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var clickHereButton: UIButton!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editPicBtn: UIButton!
    @IBOutlet weak var noticeTextLbl: UILabel!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var noticeHeadLbl: UILabel!
    @IBOutlet weak var remianLbl: UILabel!
    @IBOutlet weak var topNoteLbl: UILabel!
    
    @IBOutlet weak var profileImgHeight: NSLayoutConstraint!
    
    
    var imagePicker: ImagePicker!
    var viewModel = SignupViewModel()
    var viewmode = UpdateProfileCommunityViewModel()
//    var welcomeText = "Hello & Welcome!  We're happy you're here for a visit!  Our Guests are invited to explore and experience most of what Living ACL has to offer.  Several features can only be accessed by signing up for the ACL Community Account (FREE).  This app is ad-free and we rely on donations - not fees.  So if you want to sign up for an account now, you can do so Here.  Otherwise, enter and enjoy!"
    
     var welcomeText = "You are welcome to try out Living ACL as our guest!  Certain features will not be available, but you will be able to enjoy many of them.  All features that involve posting or joining live events are available only to members with accounts.  You can sign up for an account any time for free!"
    var isNeedGotoMainScreen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup button
        doneButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setUpUIForGuest()
    }
    
    func setUpUIForGuest(){
        if DataManager.shared.isGuestUser{
            editPicBtn.isHidden = true
            clickHereButton.isHidden = true
            orLbl.isHidden = true
            remianLbl.isHidden = true
            noticeHeadLbl.text = "Welcome :"
            noticeTextLbl.text = welcomeText
            buttonTop.constant = 16
            usernameLabel.text = "Welcome! " + (viewModel.username ?? "")
            profileImgHeight.constant = 20
            ProfilePic.isHidden = true
            editPicBtn.isHidden = true
        }else{
            self.topNoteLbl.text = ""
            profileImgHeight.constant = 150
            ProfilePic.isHidden = false
            editPicBtn.isHidden = false
            usernameLabel.text = "Welcome! " + (viewModel.username ?? "")

        }
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        if isNeedGotoMainScreen == true{
            self.gotoMainViewController()
        }else{
            if viewModel.profileImageData != nil {
                      // Show loader
                      SwiftLoader.show(animated: true)
                      // save image to cloud
                      self.viewModel.saveProfileImage { status, message in
                          DispatchQueue.main.async {
                              // hide loader
                              SwiftLoader.hide()
                              if status {
                                  self.navigateToWelcomeScreen()
                              } else {
                                  self.showError(message)
                              }
                          }
                      }
                  } else {
                      navigateToWelcomeScreen()
                  }
        }
        
      
    }
    
    @IBAction func editPicAction(_ sender: Any) {
        
        self.imagePicker.present(from: self.view)
    }
    
    @IBAction func rememberPasswordAction(_ sender: Any) {
        viewModel.shouldSavePassword = true
        SwiftLoader.show(animated: true)
        viewModel.updateSettings { (issuccess, msg) in
            SwiftLoader.hide()
            self.showToast(message: "Done", font: AppFont.get(.medium, size: 16))
        }
    }
    
    func navigateToWelcomeScreen() {
        let welcomeViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
}

extension SignupSuccessViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.ProfilePic.image = image
        self.viewModel.profileImageData = image?.pngData()
    }
}
