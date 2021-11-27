//
//  ChooseLocationViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 31/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class ChooseLocationViewController: BaseViewController {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
         descriptionTextView.text = "Venues for your group can be anywhere that\nprivacy can be honored, quiet can be reason-\nably assured & is accessible. Someplace a\nsafe space can be created.\n\nIdeally, same location is availble on a\nregular basis.\n\nPrivate Homes are not recommended for\npublic groups. Libraries, churches, class or\nConference spaces at locat schools are often\nfree or low cost. Please have a look at tips\nwe have collected regarding locating a good\nACL space."
    }
    

    @IBAction func doneAction(_ sender: UIButton) {
        if let chapterInfoFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChapterInfoFormViewController") as? ChapterInfoFormViewController{
            self.navigationController?.pushViewController(chapterInfoFormViewController, animated: true)
        }

    }
    
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
}
