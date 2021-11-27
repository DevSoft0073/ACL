//
//  CreatePinViewController.swift
//  ACL
//
//  Created by Gagandeep on 11/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit


class CreatePinViewController: BaseViewController {

    @IBOutlet weak var pinView: SVPinView!
    @IBOutlet weak var confirmView: SVPinView!
    @IBOutlet weak var pinBackGroundView: UIView!
    @IBOutlet weak var confirmBackGroundView: UIView!
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private var pinEntered: String = ""
    private var confirmedPin: String = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCreatePinView()
        configureConfirmPinView()
        
        setupUI()
        // disable button
        createButton.enable()
    }
    
    func setupUI() {
        
        if UIDevice().isRegularModel() {
            topConstraint.constant = 20
        } else if UIDevice().isPlusModel() {
            topConstraint.constant = 40
        }
    }
    
    override func viewDidLayoutSubviews() {
        pinBackGroundView.applyGradient(colours: [AppTheme.lightSteel, AppTheme.darkSteel])
        confirmBackGroundView.applyGradient(colours: [AppTheme.lightSteel, AppTheme.darkSteel])
        createButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
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
            self?.pinEntered = pin
          //  self?.validatePinEntry()
        }
        
        pinView.didChangeCallback = { [weak self] pin in
            self?.pinEntered = pin
          //  self?.validatePinEntry()
        }
    }
    
    func configureConfirmPinView() {
        confirmView.pinLength = 4
        confirmView.secureCharacter = "\u{25CF}"
        confirmView.interSpace = 10
        confirmView.textColor = UIColor.white
        confirmView.backgroundColor = .clear
        confirmView.shouldSecureText = true
        confirmView.style = .box
        confirmView.borderLineColor = UIColor.white
        confirmView.activeBorderLineColor = UIColor.white
        confirmView.borderLineThickness = 1
        confirmView.activeBorderLineThickness = 1
        confirmView.font = UIFont.systemFont(ofSize: 15)
        confirmView.keyboardType = .numberPad
        // pinView.pinIinputAccessoryView = UIView()
        // pinView.placeholder = "******"
        confirmView.becomeFirstResponderAtIndex = 0
        
        confirmView.didFinishCallback = { [weak self] pin in
            self?.confirmedPin = pin
           // self?.validatePinEntry()
        }
        
        confirmView.didChangeCallback = { [weak self] pin in
            self?.confirmedPin = pin
          //  self?.validatePinEntry()
        }
    }

    /// Validate pin entered
    func validatePinEntry() {
        // check empty
        guard !confirmedPin.isEmpty, !pinEntered.isEmpty else {
            createButton.disable()
            return
        }
        // match
        if confirmedPin == pinEntered {
            createButton.enable()
        } else {
            createButton.disable()
        }
    }
    
    /// Move to my journal screen
    func movetoJournal() {
        if let myJournalViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "MyJournalViewController") as? MyJournalViewController {
            myJournalViewController.isFromCalendar = false
            self.navigationController?.pushViewController(myJournalViewController, animated: true)
        }
    }
    
    
    @IBAction func back(_ sender: Any) {
        guard let viewControllers =  self.navigationController?.viewControllers else {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        for vc in viewControllers {
            if vc.isKind(of: MyACLViewController.self) {
                self.navigationController?.popToViewController(vc, animated: true)
            }
        }
        //self.navigationController?.popViewController(animated: true)
    }
   
    
    @IBAction func create(_ sender: Any) {
       
        // check empty
              guard !confirmedPin.isEmpty, !pinEntered.isEmpty else {
                 showError("Please enter Passcode")
                //createButton.disable()
                  return
              }
              // match
              if confirmedPin == pinEntered {
//                  createButton.enable()
                self.updatePinToCloud(pinEntered)

              } else {
//                  createButton.disable()
                showError("Passcodes do not match")

              }
    }
}

extension CreatePinViewController {
    
    func updatePinToCloud(_ pin: String) {
        SwiftLoader.show(animated: true)
        // create parameters
        let parameters = ["uid": DataManager.shared.userId!, "journal_pin": pin]
        // update pin to cloud
        CloudDataManager.shared.updateJournalPin(parameters) { status, message in
            // hide loader
            SwiftLoader.hide()
            // check status
            if status {
                // save locally
                DataManager.shared.myJournalPasscode = pin
                // move to my journal
                self.movetoJournal()
            } else {
                self.showError(message)
            }
        }
    }
}
