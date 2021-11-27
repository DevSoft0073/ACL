//
//  SignupViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import GooglePlaces
import WebKit



class SignupViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: DefaultTextField!
    @IBOutlet weak var usernameTextField: DefaultTextField!
    @IBOutlet weak var passwordTextField: DefaultTextField!
    @IBOutlet weak var cityTextField: DefaultTextField!
    @IBOutlet weak var countryTextField: DefaultTextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var clickHereButton: UIButton!
    @IBOutlet weak var pwdFldHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var firstNameLbl: DefaultTextField!
    @IBOutlet weak var lastNameLbl: DefaultTextField!
    @IBOutlet weak var phoneLbl: DefaultTextField!
    
    @IBOutlet weak var phoneNoticeLbl: UILabel!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var fNameHeight: NSLayoutConstraint!
    @IBOutlet weak var lNameHeight: NSLayoutConstraint!
    @IBOutlet weak var termsButton: UIButton!
    
    
    let viewModel = SignupViewModel()
    var isTermSelected = false
    var webview : WKWebView!
    var isFromGuest = false
    var isTermsVisible = false
    var isRobotSelected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create button
        createButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        createButton.alpha = 1
        createButton.isEnabled = true
        
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: "click here", attributes: attributes)
        clickHereButton.titleLabel?.attributedText = attributedText
        
        // update status bar
        setNeedsStatusBarAppearanceUpdate()
        setupPageForGuest()
        phoneLbl.delegate = self
        self.termsButton.addUnderLine()
        self.viewModel.isMailVerified = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if isFromGuest == true{
          
        }else{
            if viewModel.isMailVerified ?? false{
                self.createButton.setTitle("Create", for: .normal)
                
            }else{
                self.createButton.setTitle("Verify email", for: .normal)
            }
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //setup UI fro guest
   func setupPageForGuest(){
    if isFromGuest == true{
        welcomeLbl.text = "You are welcome to try out Living ACL as our guest!  Certain features will not be available, but you will be able to enjoy many of them.  All features that involve posting or joining live events are available only to members with accounts.  You can sign up for an account any time for free!"

        pwdFldHeight.constant = 0
        usernameTextField.isUserInteractionEnabled = false
        usernameTextField.text = "Guest\(randomInt(min: 100, max: 99999))"
        viewModel.username = usernameTextField.text
        passwordTextField.setLeftView(UIImage(named: ""), frame: .zero)
        backGroundImageView.image = UIImage(named: "signupGuestBG")
        usernameTextField.textColor = .lightGray
        titleLbl.text = "ACL Guest Login"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.backGroundImageView.alpha = 0.6
        }
        self.phoneHeight.constant = 0
        self.fNameHeight.constant = 0
        self.lNameHeight.constant = 0
        self.phoneLbl.isHidden = true
        self.firstNameLbl.isHidden = true
        self.lastNameLbl.isHidden = true
        phoneNoticeLbl.isHidden = true

    }else{
        phoneNoticeLbl.isHidden = false
        self.phoneLbl.isHidden = false
        self.firstNameLbl.isHidden = false
        self.lastNameLbl.isHidden = false

        self.phoneHeight.constant = 60
        self.fNameHeight.constant = 60
        self.lNameHeight.constant = 60
        welcomeLbl.text = ""
        titleLbl.text = "ACL Community Account Setup"

        backGroundImageView.alpha = 1
        usernameTextField.textColor = .black
        usernameTextField.isUserInteractionEnabled = true
        pwdFldHeight.constant = 60
    }
    }
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
    func updateUI() {
        self.cityTextField.text = viewModel.city
        self.countryTextField.text = viewModel.country
    }

    func showTermsAndCondition(){
               if let pdfUrl = Bundle.main.url(forResource: "Terms and Conditions", withExtension: "pdf", subdirectory: nil, localization: nil) {

                   do {
                       let data = try Data(contentsOf: pdfUrl)
                    let vc = UIViewController()
                    
                    
                    webview = WKWebView()
                    webview.frame = CGRect(x: 0, y: 50, width: vc.view.frame.width, height: vc.view.frame.height)
                       webview.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfUrl.deletingLastPathComponent())
                       print("pdf file loading...")
                    
                    
//                    self.view.addSubview(webview)
                  
                    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
                    navigationBar.barTintColor = UIColor.lightGray
                    //vc.view.addSubview(navigationBar)

                    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(crossBtn))

                    let navigationItem = UINavigationItem(title: "Terms of Services")
                    navigationItem.rightBarButtonItem = doneButton

                    navigationBar.items = [navigationItem]
                    
                    vc.view.addSubview(webview)
                     vc.view.addSubview(navigationBar)
                    self.isTermsVisible = true
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
    
    @IBAction func createAction(_ sender: Any) {
        if isFromGuest == true{
           signupGuestUser()
        }else{
            signupUser()
        }
    }
    
    func signupUser(){
//        self.navigateToEmailVerifyVC()
//        return
        if firstNameLbl.text!.isEmpty || lastNameLbl.text!.isEmpty || usernameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty || cityTextField.text!.isEmpty || countryTextField.text!.isEmpty{
                 showError("You must fill in all of the fields")
             }else if isTermSelected == false{
                 showError("Please check Terms of Services")
             }else if isRobotSelected == false{
                showError("Please confirm that you are not robot")

             }else if viewModel.isMailVerified == false{
               // showError("Please verify your email")
                self.navigateToEmailVerifyVC()
             }else{
                 let validation = viewModel.validateEntries()
                 if validation.valid {
                     SwiftLoader.show(animated: true)
                     viewModel.signup{ status, message in
                         DispatchQueue.main.async {
                             // hide loader
                             SwiftLoader.hide()
                             // validate status
                             if status {
                                 self.navigateToSuccessScreen()
                             } else {
                                 self.showError(message)
                             }
                         }
                     }
                 } else {
                     self.showError(validation.message)
                 }
             }
    }
    
    func signupGuestUser(){
        if  usernameTextField.text!.isEmpty || emailTextField.text!.isEmpty || cityTextField.text!.isEmpty || countryTextField.text!.isEmpty{
                 showError("You must fill in all of the fields")
             }else if isTermSelected == false{
                 showError("Please check Terms of Services")
             }else if isRobotSelected == false{
                showError("Please confirm that you are not robot")

             }  else{
                 let validation = viewModel.validateEntriesForGuest()
                 if validation.valid {
                     SwiftLoader.show(animated: true)
                     viewModel.guest_signup{ status, message in
                         DispatchQueue.main.async {
                             // hide loader
                             SwiftLoader.hide()
                             // validate status
                             if status {
                                 self.navigateToSuccessScreen()
                             } else {
                                 self.showError(message)
                             }
                         }
                     }
                 } else {
                     self.showError(validation.message)
                 }
             }
    }
    
    
    
    
    
    @IBAction func textChanged(_ sender: UITextField) {
        if sender == usernameTextField {
            viewModel.username = sender.text
        } else if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        }else if sender == firstNameLbl{
            viewModel.firstName = sender.text
        }else if sender == lastNameLbl{
            viewModel.lastName = sender.text
        }else if sender == phoneLbl{
            viewModel.phone = sender.text
        }
    }
    
    
    @IBAction func iAcceptBtn(_ sender: UIButton) {
        if isTermsVisible == false{
            self.showNormalMsg("Please check Terms and Conditions", title: "", completion: nil)
        }else{
            sender.isSelected = !sender.isSelected
            isTermSelected = sender.isSelected

        }
    }
    
    
    @IBAction func robotBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isRobotSelected = sender.isSelected
    }
    
    @IBAction func termsButtonAction(_ sender: UIButton) {
       
        showTermsAndCondition()
//        if sender.isSelected {
//            createButton.alpha = 1
//            createButton.isEnabled = true
//        } else {
//            createButton.alpha = 0.3
//            createButton.isEnabled = false
//        }
    }
    
    @IBAction func CountryFieldDidSelect(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        if let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationController") as? SearchLocationController {
            vc.delegate = self
            if sender == cityTextField{
                vc.placeholder = "Enter your city to search"
            }else{
                vc.placeholder = "Enter your country to search"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func clickAction( _ sender: Any) {
        if let vc = UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    /// Navigate to success screen
    func navigateToSuccessScreen() {
        if let signupSuccessViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignupSuccessViewController") as? SignupSuccessViewController {
            signupSuccessViewController.viewModel = viewModel
            self.navigationController?.pushViewController(signupSuccessViewController, animated: true)
        }
    }
    
    func navigateToEmailVerifyVC() {
        
        SwiftLoader.show(animated: true)
        viewModel.getOTPfromBackend(email: self.emailTextField.text ?? "") { (isSucess, msg) in
            SwiftLoader.hide()
            if isSucess{
                self.showNormalMsg(msg, title: "") { (action) in
                    if let emailVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "EmailVerifiedViewController") as? EmailVerifiedViewController {
                        emailVC.viewModel = self.viewModel
                        emailVC.mailVerifiedDelegate = self
                        self.navigationController?.pushViewController(emailVC, animated: true)
                    }
                }
            }else{
                self.showError(msg)
            }
         
        }
        
       
    }
    
    @IBAction func backAction(_ sender: Any) {
        backGroundImageView.alpha = 1
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SignupViewController: UITextFieldDelegate,MailVerifiedProtcol {
    func mailVerified(isConfirmed: Bool) {
        if isConfirmed{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.isFromGuest == true{
                    self.signupGuestUser()
                }else{
                    self.signupUser()
                }
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cityTextField || textField == countryTextField {
            return false
        }else if textField == phoneLbl{
            let allowingChars = "+0123456789"
            let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
            let validString = string.rangeOfCharacter(from: numberOnly) == nil
            return validString
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == cityTextField || textField == countryTextField {
            // open places api
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            viewModel.username = textField.text
        } else if textField == emailTextField {
            viewModel.email = textField.text
        } else if textField == passwordTextField {
            viewModel.password = textField.text
        }
    }
}

extension SignupViewController: SearchLocationControllerDelegate {
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
        viewModel.latitude = "\(place.coordinate.latitude)"
        viewModel.longitude = "\(place.coordinate.longitude)"
        
        self.updateUI()
    }
}

