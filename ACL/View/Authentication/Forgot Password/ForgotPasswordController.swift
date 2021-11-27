//
//  ForgotPasswordController.swift
//  ACL
//
//  Created by RGND on 13/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class ForgotPasswordController: BaseViewController {

    @IBOutlet weak var emailTextField: DefaultTextField!
    @IBOutlet weak var resetButton: UIButton!
    
    let viewModel = ForgotPasswordViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        resetButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
         resetButton.isEnabled = true
        resetButton.alpha = 1
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        
        // enable/disable login button
//        if viewModel.validateEntries().valid {
//            resetButton.isEnabled = true
//            resetButton.alpha = 1
//        } else {
//            resetButton.isEnabled = false
//            resetButton.alpha = 0.3
//        }
    }
    
    @IBAction func backAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ResetAction(_ sender: Any) {
        if emailTextField.text!.isEmpty{
            showError("Please enter your email")
        }else{
            let validation = viewModel.validateEntries()
            if validation.valid {
                SwiftLoader.show(animated: true)
                viewModel.resetPassword{ status, message in
                    DispatchQueue.main.async {
                        // hide loader
                        SwiftLoader.hide()
                        // validate status
                        if status {
                            self.showSuccessPopUp()
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

    /// Success alert messaage
    func showSuccessPopUp() {
        let controller = UIAlertController(title: "Alert", message: "Reset password link has been sent on mail. Please check there.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { action in
            self.navigationController?.popViewController(animated: true)
        }
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
}

extension ForgotPasswordController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.email = textField.text
        }
    }
}
