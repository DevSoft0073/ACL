//
//  RecruiteMemdersViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 01/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class RecruiteMemdersViewController: BaseViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = "\u{22}New groups and established alike can in-\nspire new members to join in a number of\nways! Below is a link to an ever growing\nnumber of tips on how to attract members\u{22}"
    }
    @IBAction func backToACLAction(_ sender: Any) {
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
    
    @IBAction func backToStartMainAction(_ sender: Any) {
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
    
    @IBAction func tipsListAction(_ sender: Any) {
        
    }
}
