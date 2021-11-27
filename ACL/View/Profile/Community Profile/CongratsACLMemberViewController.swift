//
//  CongratsACLMemberViewController.swift
//  ACL
//
//  Created by Aman on 09/10/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class CongratsACLMemberViewController: BaseViewController {
    //MARK: outlets
    @IBOutlet weak var profileBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileBtn.addUnderLine()
        // Do any additional setup after loading the view.
    }
    

    func popToProfile(){
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: AppSettingsViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        popToProfile()
    }
    @IBAction func newProfileBtn(_ sender: UIButton) {
        popToProfile()
    }
    
    @IBAction func crossBtn(_ sender: UIButton) {
        popToProfile()
    }
}
