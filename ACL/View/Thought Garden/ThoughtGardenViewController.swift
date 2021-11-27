//
//  ThoughtGardenViewController.swift
//  ACL
//
//  Created by Gagandeep on 10/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class ThoughtGardenViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButtonBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    var timer : Timer?
    let learnText = "Connect with people all over the world by sharing answers to some meaningful questions.  "
    
    let welcomeText = "Welcome to the Thought Garden!  Enjoying the flowers is free"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set button UI
        signupButton.addUnderLine()
        timer = Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(callNavigation), userInfo: nil, repeats: false)
        
        
        let txt = "\(welcomeText)\n\n\(learnText)"
        titleLabel.text = txt
        let skipBtn = UIButton()
        skipBtn.frame = CGRect(x: self.view.frame.width - 70, y: 32, width: 70, height: 42)
        skipBtn.setTitle("Skip", for: .normal)
        //FFFF00
        skipBtn.setTitleColor(UIColor.colorFromHex("FFFF00"), for: .normal)
        skipBtn.addTarget(self, action: #selector(skipBtnTap(_:)), for: .touchUpInside)
        self.view.addSubview(skipBtn)

        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if DataManager.shared.isACLAccount {
            bottomView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    
    @objc func callNavigation(){
        self.pushToQstnViewController()
    }
    
    @objc func skipBtnTap(_ sender : UIButton){
        if let thoughtGardenViewController = UIStoryboard(name: "ThoughtGarden", bundle: nil).instantiateViewController(withIdentifier: "QuestionOfWeekViewController") as? QuestionOfWeekViewController {
            self.navigationController?.pushViewController(thoughtGardenViewController, animated: false)
        }

    }
    
    func pushToQstnViewController(){
        performSegue(withIdentifier: "pushToQuestion", sender: nil)
    }
    
    @IBAction func learnAbout(_ sender: UIButton) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }

    }
    
    @IBAction func signupAction(_ sender: Any) {
       showUpdateProfileScreen(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
