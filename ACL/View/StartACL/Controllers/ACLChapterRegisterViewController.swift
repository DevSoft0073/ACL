//
//  ACLChapterRegisterViewController.swift
//  ACL
//
//  Created by Rakesh verma on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class ACLChapterRegisterViewController: BaseViewController {

    //MARK:- OutLets
    @IBOutlet private weak var descritpionTextView: UITextView!
    @IBOutlet private weak var registerButton: UIButton!
    @IBOutlet private weak var addressFeild: DefaultTextField!
    @IBOutlet private weak var phoneNumberFeild: DefaultTextField!
    @IBOutlet private weak var confirmEmailFeild: DefaultTextField!
    @IBOutlet private weak var lastNameFeild: DefaultTextField!
    @IBOutlet private weak var firstNameFeild: DefaultTextField!
    @IBOutlet private weak var userNameFeild: DefaultTextField!
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
    }

    //MARK:- Button Actions
    @IBAction private func registerAction(_ sender: UIButton) {
        if let videoUploadViewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoUploadViewController") as? VideoUploadViewController{
            self.navigationController?.pushViewController(videoUploadViewController, animated: true)
        }
    }
    
    @IBAction private func backToChapterAction(_ sender: UIButton) {
        guard let viewControllers =  self.navigationController?.viewControllers else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        for vc in viewControllers {
            if vc.isKind(of: StartACLViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    @IBAction private func backToACLAction(_ sender: UIButton) {
        guard let viewControllers =  self.navigationController?.viewControllers else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        for vc in viewControllers {
            if vc.isKind(of: MyACLViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
}
