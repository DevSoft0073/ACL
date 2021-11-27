//
//  EnterPinViewController.swift
//  ACL
//
//  Created by Gagandeep on 12/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class EnterPinViewController: BaseViewController {

    @IBOutlet weak var pinBackGroundView: UIView!
    @IBOutlet weak var pinView: SVPinView!
    
    @IBOutlet weak var proceedButton: DefaultDoneButton!
    
    @IBOutlet weak var resetPin: DefaultDoneButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proceedButton.isEnabled = true
        proceedButton.alpha = 1
        
        configureCreatePinView()
    }
    
    override func viewDidLayoutSubviews() {
        proceedButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        resetPin.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])

        pinBackGroundView.applyGradient(colours: [AppTheme.lightSteel, AppTheme.darkSteel])
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
            self?.proceedButton.isEnabled = true
            self?.proceedButton.alpha = 1
        }
        
        pinView.didChangeCallback = { [weak self] pin in
//            self?.proceedButton.isEnabled = false
//            self?.proceedButton.alpha = 0.6
        }
    }

    func movetoCreatePinVC() {
        if let myJournalViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "CreatePinViewController") as? CreatePinViewController {
            self.navigationController?.pushViewController(myJournalViewController, animated: true)
        }
    }

    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resetPin(_ sender: DefaultDoneButton) {
        resetPinToCloud("")
    }
    
    @IBAction func Proceed(_ sender: Any) {
        let pin = pinView.getPin()
        if pin == ""{
            showError("Please enter Passcode")

        }else{
            guard let code = DataManager.shared.myJournalPasscode, code == pinView.getPin() else {
                      showError("Incorrect Passcode")
                
                pinView.becomeFirstResponderAtIndex = 0
                
                      return
                  }
                 
                  if let myJournalViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "MyJournalViewController") as? MyJournalViewController {
                    myJournalViewController.isFromCalendar = false

                      self.navigationController?.pushViewController(myJournalViewController, animated: true)
                  }
        }
        
      
    }
    
}

extension EnterPinViewController{
    func resetPinToCloud(_ pin: String) {
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
                self.movetoCreatePinVC()
            } else {
                self.showError(message)
            }
        }
    }
}
