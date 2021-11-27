//
//  StartACLCongratulationViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 01/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class StartACLCongratulationViewController: BaseViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        descriptionLabel.text = "Not sure yet? that's ok,\nclick here for some other\ngreat ideas!"
        //"Not sure you want to start your group yet? That’s OK 😊/n Here’s what you can do now!"
        descriptionLabel.text = "Not sure you want to start your group yet? That’s OK 😊\n Here’s what you can do now!"

    }
    
    
    //Functions
    
    
    
    //MARK: Button actions

    @IBAction func backToACLAction(_ sender: UIButton) {
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
    
    @IBAction func backToMainChapterAction(_ sender: UIButton) {
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
    
    
    @IBAction func clickHereBtn(_ sender: UIButton) {
        
        displayActionSheetWithCongratsVC(title: "Choose an option", ["Share & Practice ACL wherever you go","Donate to ACL","Invite a friend to experience ACL Meetup, App and or Live ACL event on your app!"]) { (index, isCancel) in
            if index == 0{

            }else if index == 1{
                openwebLink(controller: self, link: donateUrl)
            }else if index == 2{
                self.inviteFriend()
            }
        }
       //call kr mainu
        
    }
    
    
    @IBAction func crossAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
