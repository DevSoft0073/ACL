//
//  MyACLViewController.swift
//  ACL
//
//  Created by Gagandeep on 11/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class MyACLViewController: BaseViewController,UpdateProfileCommunityMessageDelegate {
   
    

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    let learnText = "Click here for more ways to explore ACL activities and practices."
    let myJournalGuestText = "As a guest, you may use the journal, but your entries will be lost upon closing the app. To keep your entries, please convert to a full ACL Community account"
    
    let myFavGuestText = "As a guest, you may use the favorites, but your entries will be lost upon closing the app. To keep your entries, please convert to a full ACL Community account"
    var isGuestCheckedNotice = false
    var blackView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice().isRegularModel() {
            titleLabelTopConstraint.constant = 32
        } else if UIDevice().isPlusModel() {
            titleLabelTopConstraint.constant = 48
        }
        self.backBtn.addShadow()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        blackView.backgroundColor = .black
//        blackView.layer.opacity = 0.4
//        blackView.frame = self.view.frame
//        self.backGroundImageView.addSubview(blackView)
        Singleton.sharedInstance.isGuestCheckedNotice = false
//        self.backGroundImageView.alpha = 0.5
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        self.backGroundImageView.alpha = 1
        self.blackView.removeFromSuperview()
    }
    
    
    @IBAction func settings(_ sender: Any) {
        if let appSettingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppSettingsViewController") as? AppSettingsViewController {
            self.navigationController?.pushViewController(appSettingsViewController, animated: true)
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        DataManager.shared.clear()
        gotoLoginViewController()
    }
    
    @IBAction func message(_ sender: Any) {
        openwebLink(controller: self, link: "https://forms.gle/7pzDLq8aS2m7XffY7")

    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func learnAbout(_ sender: UIButton) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }

    }
    
    @IBAction func myJournal(_ sender: Any) {
        if DataManager.shared.isGuestUser{
//            self.showError("guest user")
            if Singleton.sharedInstance.isGuestCheckedNotice{
                self.pushToJournal()
            }else{
                
            
            if let updateProfileCommunityMessageController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityMessageController") as? UpdateProfileCommunityMessageController {
                updateProfileCommunityMessageController.isFromMYACL = true
                updateProfileCommunityMessageController.guestText = myJournalGuestText
                updateProfileCommunityMessageController.isFromJournal = true
                updateProfileCommunityMessageController.modalPresentationStyle = .overCurrentContext
                updateProfileCommunityMessageController.delegate = self
                self.navigationController?.present(updateProfileCommunityMessageController, animated: true, completion: nil)
            }
                
            }
        }else{
          
            self.pushToJournal()
        }
        
    }
    
    
    func pushToJournal(){
        if let code = DataManager.shared.myJournalPasscode, !code.isEmpty {
            if let enterPinViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "EnterPinViewController") as? EnterPinViewController {
                self.navigationController?.pushViewController(enterPinViewController, animated: true)
            }
        } else {
            if let createPinViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "CreatePinViewController") as? CreatePinViewController {
                self.navigationController?.pushViewController(createPinViewController, animated: true)
            }
        }
    }
    
    func signupDidTap() {
        if let updateProfileCommunityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityController") as? UpdateProfileCommunityController {
            Singleton.sharedInstance.isNeedSignupFromEventScreen = false
            self.navigationController?.pushViewController(updateProfileCommunityController, animated: true)
        }
    }
    
    @IBAction func myFavourite(_ sender: Any) {
        if DataManager.shared.isGuestUser{
            if let updateProfileCommunityMessageController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityMessageController") as? UpdateProfileCommunityMessageController {
                updateProfileCommunityMessageController.isFromMYACL = true
                updateProfileCommunityMessageController.guestText = myFavGuestText
                updateProfileCommunityMessageController.isFromJournal = false
                updateProfileCommunityMessageController.modalPresentationStyle = .overCurrentContext
                updateProfileCommunityMessageController.delegate = self
                self.navigationController?.present(updateProfileCommunityMessageController, animated: true, completion: nil)
            }
        }else{
            if let myFavoritesViewController = UIStoryboard(name: "MyFavorites", bundle: nil).instantiateViewController(withIdentifier: "MyFavoritesViewController") as? MyFavoritesViewController {
                self.navigationController?.pushViewController(myFavoritesViewController, animated: true)
            }
        }
        
      
    }
    
    @IBAction func awarenessExercise(_ sender: Any) {
        if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
            aclExercisesViewController.viewtype = .awareness
            self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
        }
    }
    
    
    @IBAction func courageExcercise(_ sender: Any) {
        if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
            aclExercisesViewController.viewtype = .courage
            self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
        }
    }
    
    @IBAction func loveExercise(_ sender: Any) {
        if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
            aclExercisesViewController.viewtype = .love
            self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
        }
    }
    
    @IBAction func library(_ sender: Any) {
        if let libraryViewController = UIStoryboard(name: "Library", bundle: nil).instantiateViewController(withIdentifier: "ACLLibraryViewController") as? ACLLibraryViewController {
            self.navigationController?.pushViewController(libraryViewController, animated: true)
        }
    }
    
    @IBAction func startOwnACL(_ sender: Any) {
        if let startACLViewController = UIStoryboard(name: "StartACL", bundle: nil).instantiateViewController(withIdentifier: "StartACLViewController") as? StartACLViewController {
            Singleton.sharedInstance.userLatLonginMY_ACL.removeAll()
            self.navigationController?.pushViewController(startACLViewController, animated: true)
        }
    }
    
    @IBAction func findACLNearMe(_ sender: Any) {
        if let findACLNearMeController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "FindACLNearMeController") as? FindACLNearMeController {
                  self.navigationController?.pushViewController(findACLNearMeController, animated: true)
              }
    }
    
    @IBAction func connectWithOtherACL(_ sender: Any) {
        if let myACLViewController = UIStoryboard(name: "EnrollStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RegisterEventEnrollViewController") as? RegisterEventEnrollViewController {
                  self.navigationController?.pushViewController(myACLViewController, animated: true)
              }
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
        self.inviteFriend()
    }
}
