//
//  JoinLeaderShipViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 31/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class JoinLeaderShipViewController: BaseViewController {

    @IBOutlet private weak var descriptionTtexView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = "Welcome \(DataManager.shared.userName ?? "")!"
        
        doneButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        descriptionTtexView.text = "Thank you for joining ACL movement!\nWe are helping people connect with\nthemeselves and with others all over the\nworld!\n\nLast thing we ask is that you join up\nwith other ACL Leaders who are running\n similar groups and enjoy the shared experience!\n\nPlease visit and join the ACL Leader\nCommunity at LivewithACL.org (Required).\nThere you will also find instructions on how\nto join the ACL FB page. Doin this\n together, we can support each other as we\nbuild our ACL groups and communities!"
    }

    @IBAction private func backToACLAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)

//        guard let viewControllers =  self.navigationController?.viewControllers else {
//            self.navigationController?.popToRootViewController(animated: true)
//            return
//        }
//
//        for vc in viewControllers {
//            if vc.isKind(of: MyACLViewController.self) {
//                self.navigationController?.popToViewController(vc, animated: true)
//            }
//        }
    }
    @IBAction private func doneAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
