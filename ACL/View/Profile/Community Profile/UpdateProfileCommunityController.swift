//
//  UpdateProfileCommunityController.swift
//  ACL
//
//  Created by RGND on 14/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
import GooglePlaces

class UpdateProfileCommunityController: BaseViewController {
    
    @IBOutlet weak var firstnameField: DefaultTextField!
    @IBOutlet weak var lastnameField: DefaultTextField!
    @IBOutlet weak var mailingAddressField: DefaultTextField!
    @IBOutlet weak var emailVerificationField: DefaultTextField!
    @IBOutlet weak var phoneNumberField: DefaultTextField!
    @IBOutlet weak var cityFld: DefaultTextField!
    @IBOutlet weak var countryFld: DefaultTextField!
    @IBOutlet weak var passwordFld: DefaultTextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var notRobotButton: UIButton!
    @IBOutlet weak var captchaView: UIView!
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var robotViewTop: NSLayoutConstraint!
    @IBOutlet weak var cityCountryView: UIView!
    @IBOutlet weak var termBtn: UIButton!
    @IBOutlet weak var termOfServiceBtn: UIButton!
    
    
    let viewModel = UpdateProfileCommunityViewModel()
    var moveBackOnCompletion: Bool = false
    var isTermSelected = false
    var webview : WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        passwordFld.delegate = self
        passwordFld.isSecureTextEntry = true
        perform(#selector(getProfile)  , with: nil, afterDelay: 0.2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if DataManager.shared.isACLAccount{
            titleLbl.text = "Edit Profile to enable ACL Community Features"
        }else{
            titleLbl.text = "Please complete the following to enable ACL Community Features (Will NOT be shared)"
        }
        
        if moveBackOnCompletion{
            self.saveButton.setTitle("      Save changes", for: .normal)

        }else{
            if viewModel.isMailVerified{
                self.saveButton.setTitle("      Save changes", for: .normal)

            }else{
                self.saveButton.setTitle("      Verify email", for: .normal)
            }
        }
       
        
        
        
    }
    
    func setupUI() {
        saveButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
       // emailVerificationField.isUserInteractionEnabled = false
        emailVerificationField.isHidden = true
        termOfServiceBtn.addUnderLine()
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone6, .iPhone7, .iPhone6S, .iPhone8 :
            topSpaceConstraint.constant = 0
        case .iPhone7Plus, .iPhone8Plus:
            topSpaceConstraint.constant = 50
        default: break
        }
        
        if DataManager.shared.isGuestUser {
            robotViewTop.constant = 250
            cityCountryView.isHidden = false
        }else{
            cityCountryView.isHidden = true
            robotViewTop.constant = 32
        }

        
    }
    
    @objc func getProfile() {
        SwiftLoader.show(animated: true)
        viewModel.getProfile { status, message in
            DispatchQueue.main.async {
                // hide loader
                SwiftLoader.hide()
                // validate status
                if status {
                    self.updateUI()
                } else {
                    self.showError(message)
                }
            }
        }
    }
    
    func updateUI() {
        firstnameField.text = viewModel.firstname
        lastnameField.text = viewModel.lastname
        mailingAddressField.text = viewModel.mailingAddress
        cityFld.text = viewModel.city
        countryFld.text = viewModel.country
       // emailVerificationField.text = viewModel.emailVerification
        phoneNumberField.text = viewModel.phoneNumber
        
        if let error = viewModel.mailingAddressError, error.count > 0 {
            self.mailingAddressField.borderColor = .red
            self.mailingAddressField.borderWidth = 1
        } else {
            self.mailingAddressField.borderColor = .clear
            self.mailingAddressField.borderWidth = 0
        }
        
        if viewModel.isEmailVerified {
            emailVerificationField.rightText = "(verified)"
        }
    }
    
        func showTermsAndCondition(){
                   if let pdfUrl = Bundle.main.url(forResource: "Terms and Conditions", withExtension: "pdf", subdirectory: nil, localization: nil) {

                       do {
                           let data = try Data(contentsOf: pdfUrl)
                        let vc = UIViewController()
                        
                        
                        webview = WKWebView()
                        webview.frame = vc.view.frame
                           webview.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfUrl.deletingLastPathComponent())
                           print("pdf file loading...")
                        
                        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
                        navigationBar.barTintColor = UIColor.lightGray
                        //vc.view.addSubview(navigationBar)

                        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(crossBtn))

                        let navigationItem = UINavigationItem(title: "Terms of Services")
                        navigationItem.rightBarButtonItem = doneButton

                        navigationBar.items = [navigationItem]
                        
                        vc.view.addSubview(webview)
                         vc.view.addSubview(navigationBar)
    //                    self.view.addSubview(webview)
                       // vc.view.addSubview(webview)
                        self.present(vc, animated: true, completion: nil)
                       }
                       catch {
                           print("failed to open pdf")
                       }
                       return
                   }

                   print("pdf file doesn't exist")
        }
    
    @objc func crossBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backAction( _ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func captchaAction(_ sender: Any) {
        notRobotButton.isSelected = !notRobotButton.isSelected
    }
    @IBAction func termsBtn(_ sender: UIButton) {
        showTermsAndCondition()
    }
    
    @IBAction func termServiceBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isTermSelected = sender.isSelected
//        showTermsAndCondition()

    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if sender == firstnameField {
            viewModel.firstname = sender.text
        } else if sender == lastnameField {
            viewModel.lastname = sender.text
        } else if sender == mailingAddressField {
            viewModel.mailingAddress = sender.text
            viewModel.validateMailingAddress = true
        } else if sender == emailVerificationField {
            // viewModel.emailVerification = sender.text
        } else if sender == phoneNumberField {
            viewModel.phoneNumber = sender.text
        }
        else if sender == passwordFld {
            viewModel.password = sender.text
        }
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        if DataManager.shared.isGuestUser{
            updateForGuestUser()
        }else{
            savechnagesForNormalUser()
        }
        
    }
    
    func updateForGuestUser(){
        viewModel.isSelectTerm = isTermSelected
        viewModel.password = passwordFld.text
        let validaion = viewModel.validateEntriesForGuest()
        if validaion.valid{
            
            if viewModel.isMailVerified{
                SwiftLoader.show(animated: true)
                viewModel.updateForGuest { (status, message) in
                                    DispatchQueue.main.async {
                        // hide loader
                        SwiftLoader.hide()
                        // validate status
                        if status {
                            if Singleton.sharedInstance.isNeedSignupFromEventScreen == true{
                                self.navigationController?.popViewController(animated: true)
                            }else{
                                self.navigateToSuccessScreen()

                            }
                            
                            
                        } else {
                            self.showError(message)
                        }
                    }
                }
            }else{
                SwiftLoader.show(animated: true)
                viewModel.getOTPfromBackend(email: self.mailingAddressField.text ?? "") { (isSucess, msg) in
                    SwiftLoader.hide()
                    if isSucess{
                        self.showNormalMsg(msg, title: "") { (action) in
                            if let emailVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EmailVerifiedViewController") as? EmailVerifiedViewController {
                                emailVC.proFileViewModel = self.viewModel
                                emailVC.isFromGuest = true
                                self.navigationController?.pushViewController(emailVC, animated: true)
                            }
                        }
                    }else{
                        self.showError(msg)
                    }
                 
                }
            }
            
            
            
            

        }else{
                self.showError(validaion.message)
        }
    }
    
    
    
    func savechnagesForNormalUser(){
        let validation = viewModel.validateEntries()
        if validation.valid {
            SwiftLoader.show(animated: true)
            viewModel.update{ status, message in
                DispatchQueue.main.async {
                    // hide loader
                    SwiftLoader.hide()
                    // validate status
                    if status {
                        if Singleton.sharedInstance.isNeedSignupFromEventScreen == true{
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            if self.moveBackOnCompletion {
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                if let updateProfileCommunityMessageController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "CongratsACLMemberViewController") as? CongratsACLMemberViewController {
                                    self.navigationController?.pushViewController(updateProfileCommunityMessageController, animated: true)
                                }
                               // self.gotoMainViewController()
                            }
                        }
                        

                    } else {
                        self.showError(message)
                    }
                }
            }
        } else {
            self.showError(validation.message)
        }

    }
    
    /// Navigate to success screen
       func navigateToSuccessScreen() {
           if let signupSuccessViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignupSuccessViewController") as? SignupSuccessViewController {
               signupSuccessViewController.viewmode = viewModel
            signupSuccessViewController.isNeedGotoMainScreen = true
               self.navigationController?.pushViewController(signupSuccessViewController, animated: true)
           }
       }
    
    
    @IBAction func cityField(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        if let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationController") as? SearchLocationController {
            vc.delegate = self
            vc.placeholder = "Enter your city to search"
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    @IBAction func countryFld(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        if let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationController") as? SearchLocationController {
            vc.delegate = self
            vc.placeholder = "Enter your country to search"
            self.navigationController?.pushViewController(vc, animated: true)
        }

        
    }
    
}

extension UpdateProfileCommunityController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailVerificationField || textField == cityFld || textField == countryFld {
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == mailingAddressField {
            viewModel.validateMailingAddress { status, message in
                DispatchQueue.main.async {
                    self.updateUI()
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstnameField {
            viewModel.firstname = textField.text
        } else if textField == lastnameField {
            viewModel.lastname = textField.text
        } else if textField == mailingAddressField {
            viewModel.mailingAddress = textField.text
        } else if textField == emailVerificationField {
            // viewModel.emailVerification = textField.text
        } else if textField == phoneNumberField {
            viewModel.phoneNumber = textField.text
        }
        else if textField == cityFld {
            viewModel.city = textField.text
        } else if textField == passwordFld {
                   viewModel.password = textField.text
               }
        else if textField == countryFld {
            viewModel.country = textField.text
        }
    }
}

extension UpdateProfileCommunityController : SearchLocationControllerDelegate{
    func placeSelected(_ place: GMSPlace) {
        // get city name
        if let name = place.name {
            debugPrint("Place name: \(name)")
            viewModel.city = name
        } else if let cityName = place.addressComponents?.first(where: { $0.type == "city" })?.name {
            debugPrint("city -> \(cityName)")
            viewModel.city = cityName
        } else if let localityName = place.addressComponents?.first(where: { $0.type == "locality" })?.name {
            debugPrint("localityName -> \(localityName)")
            viewModel.city = localityName
        }
        // get country code
        if let country = place.addressComponents?.first(where: { $0.type == "country" })?.name {
            debugPrint("country -> \(country)")
            viewModel.country = country
        }
        // get coordinates
        debugPrint("coordinate -> \(place.coordinate)")
//        viewModel.latitude = "\(place.coordinate.latitude)"
//        viewModel.longitude = "\(place.coordinate.longitude)"
        
        self.updateUI()
    }
    
    
}
