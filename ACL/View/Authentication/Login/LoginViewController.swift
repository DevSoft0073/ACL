//
//  LoginViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var emailTextField: DefaultTextField!
    @IBOutlet weak var passwordTextField: DefaultTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginButtonArrow: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var clickHereButton: UIButton!
    @IBOutlet weak var guestButton: UIButton!
    @IBOutlet weak var noticeLbl: UILabel!
    
    let viewModel = SigninViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        signUpButton.applyGradient(colours: [AppTheme.lightSteel, AppTheme.lightDullPurple])
        loginButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        guestButton.applyGradient(colours: [AppTheme.lightOrange, AppTheme.lightPurple])

        self.enableLoginButton(true)
        
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: "click here", attributes: attributes)
        clickHereButton.titleLabel?.attributedText = attributedText
        noticeLbl.text = String("Due to the Covid-19 pandemic, we are reminding everyone to practice social interaction and ACL safely. Please adapt all ACL activities to online interactions to be most safe. If you are in an area with moderate or eased lockdowns and choose to engagie in person, please practice safely distanced/appropriately masked interactions that follow your local Health authority recommendations. As always, honor your own and others' sense of safety boundaries!").uppercased()
        noticeLbl.underline()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        }
        
        // enable/disable login button
      //  self.enableLoginButton(viewModel.validateEntries().valid)
    }
    
    func enableLoginButton(_ flag: Bool) {
        loginButton.isEnabled = flag
        loginButton.alpha = flag ? 1 : 0.3
        loginButtonArrow.alpha = flag ? 1: 0.3
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        
        passwordTextField.resignFirstResponder()
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
          showError("You must fill in all of the fields")
        }else{
            let validation = viewModel.validateEntries()
                   if validation.valid {
                       SwiftLoader.show(animated: true)
                       viewModel.signin{ status, message in
                           DispatchQueue.main.async {
                               // hide loader
                               SwiftLoader.hide()
                               // validate status
                               if status {
                                
                                self.gotoMainViewController()
//                                   self.navigateToWelcomeScreen()
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
    
    @IBAction func guestAction(_ sender: UIButton) {
        pushToSignup(isguest: true)
    }
    
    
    @IBAction func singup(_ sender: Any) {
       pushToSignup(isguest: false)
    }
    
    @IBAction func clickAction( _ sender: Any) {
        
        if let vc = UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    func navigateToWelcomeScreen() {
        let welcomeViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "WelcomeViewController")
        self.navigationController?.pushViewController(welcomeViewController, animated: true)
    }
    
    func pushToSignup(isguest :Bool){
        let signupViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
               signupViewController.isFromGuest = isguest
                
               self.navigationController?.pushViewController(signupViewController, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.email = textField.text
        } else if textField == passwordTextField {
            viewModel.password = textField.text
        }
    }
}
