//
//  AppSettingsViewController.swift
//  ACL
//
//  Created by RGND on 07/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import WebKit

struct AppSettingsTitles {
    static let music = "Music-general"
    static let soundEffects = "Sound effects"
    static let emailNotices = "Email notices"
    static let pushNotification = "Push notifications"
    static let contactInfo = "Show my contact info"
    static let cityCountry = "Show my City & Country"
    static let premiumMember = "ACL Community Member"
    static let ACLAccount = "ACL Community Account (FREE)"
    static let updateProfile = "Current Profile Seen by Others"
    static let remainSignIn = "Remain signed in"
    static let termsNcondition = "Terms of Service"
    static let backgroundSound = "Background Sound"

}

enum AppSettingsIndexes: Int {
    case Music = 023
    case SoundEffects = 11
    case EmailNotices = 1
    case PushNotification = 2
    case ContactInfo = 42
    case CityCountry = 53
    case PremiumMember = 64
    case ACLAccount = 14
    case UpdateProfile = 3
    case RemainSignIn = 4
    case Donate = 6
    case terms = 5
    case backGroundSound = 0
}

//enum AppSettingsIndexes: Int {
//    case Music = 0
//    case SoundEffects = 1
//    case EmailNotices = 2
//    case PushNotification = 3
//    case ContactInfo = 4
//    case CityCountry = 5
//    case PremiumMember = 6
//    case ACLAccount = 14
//    case UpdateProfile = 7
//    case RemainSignIn = 8
//    case Donate = 9
//}


enum AppSettingsIndexesForGuest: Int {
    case Music = 023
    case SoundEffects = 123
    case EmailNotices = 1
    case PushNotification = 2
    case ContactInfo = 423
    case CityCountry = 523
    case PremiumMember = 63
    case ACLAccount = 3
    case UpdateProfile = 4
    case RemainSignIn = 34
    case Donate = 6
    case terms = 5
    case backGroundSound = 0
}


class AppSettingsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var donateBtn: UIButton!
    
    let viewModel = AppSettingsViewModel()
    var webview : WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        perform(#selector(getSettings)  , with: nil, afterDelay: 0.2)
        
    }
    
    
    @objc func getSettings() {
        SwiftLoader.show(animated: true)
        viewModel.getSettings { status, message in
            DispatchQueue.main.async {
                // hide loader
                SwiftLoader.hide()
                // validate status
                if status {
                    self.updateUI()
                } else {
                    self.showError(message)
                }
            }
        }
    }
    
    func updateSettings() {
        SwiftLoader.show(animated: true)
        viewModel.updateSettings { status, message in
            DispatchQueue.main.async {
                // hide loader
                SwiftLoader.hide()
                // validate status
                if status {
                    self.updateUI()
                } else {
                    self.showError(message)
                }
            }
        }
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "AppSettingsRadioButtonCell", bundle: nil), forCellReuseIdentifier: "AppSettingsRadioButtonCell")
        tableView.register(UINib(nibName: "AppSettingsACLAccountCell", bundle: nil), forCellReuseIdentifier: "AppSettingsACLAccountCell")
        tableView.register(UINib(nibName: "AppSettingsUpdateProfileCell", bundle: nil), forCellReuseIdentifier: "AppSettingsUpdateProfileCell")
        tableView.register(UINib(nibName: "AppSettingsDonateCell", bundle: nil), forCellReuseIdentifier: "AppSettingsDonateCell")
        tableView.register(UINib(nibName: "AppSettingsTermsLinkCell", bundle: nil), forCellReuseIdentifier: "AppSettingsTermsLinkCell")

        
        tableView.reloadData()
    }
    
    func updateUI() {
        tableView.reloadData()
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donateBtn(_ sender: UIButton) {
        openwebLink(controller: self, link: donateUrl)

    }
    func showSignupScreen() {
        // if user laready acl user, do not show him mesages
        if DataManager.shared.isACLAccount {
            // show pupdate rofile directly
            showUpdateProfileScreen(false)
        } else {
            // show messages
            if let updateProfileCommunityMessageController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityMessageController") as? UpdateProfileCommunityMessageController {
                updateProfileCommunityMessageController.modalPresentationStyle = .overCurrentContext
                updateProfileCommunityMessageController.delegate = self
                self.navigationController?.present(updateProfileCommunityMessageController, animated: true, completion: nil)
            }
        }
    }
    
//    func showUpdateProfileScreen() {
//        /// Navigate to success screen
//        if let updateProfileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
//            self.navigationController?.pushViewController(updateProfileViewController, animated: true)
//        }
//    }
    
}
extension AppSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if DataManager.shared.isGuestUser{
//            return 9
//        }else{
            return 6
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        if DataManager.shared.isGuestUser{
            if indexPath.row == AppSettingsIndexesForGuest.ACLAccount.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsACLAccountCell") as? AppSettingsACLAccountCell {
                    cell.titleLabel.text = AppSettingsTitles.ACLAccount
                    // do not show Signup title if user is already acl user
                    if DataManager.shared.isACLAccount {
                        cell.signupButton.setTitle("Profile", for: .normal)
                    } else {
                        cell.signupButton.setTitle("Sign up", for: .normal)
                    }
                    // button action
                    cell.buttonAction = {
                        self.showSignupScreen()
                    }
                    return cell
                }
            } else if indexPath.row == AppSettingsIndexesForGuest.UpdateProfile.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsUpdateProfileCell") as? AppSettingsUpdateProfileCell {
                    cell.titleLabel.text = AppSettingsTitles.updateProfile
                    cell.cityLabel.text = viewModel.profileSeenLocation
                    cell.dobLabel.text = viewModel.profileSeenDate
                    cell.usernameLabel.text = viewModel.profileSeenUsername
                    cell.chapterLbl.text = ""
                    cell.buttonAction = {
                        if let updateProfileCommunityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
                                  // updateProfileCommunityController.moveBackOnCompletion = moveBackOnCompletion
                                   self.navigationController?.pushViewController(updateProfileCommunityController, animated: true)
                               }
                        
                        //self.showUpdateProfileScreen(false)
                    }
                    return cell
                }
            } else if indexPath.row == AppSettingsIndexesForGuest.Donate.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsDonateCell") as? AppSettingsDonateCell {
                    cell.buttonAction = {
                        openwebLink(controller: self, link: donateUrl)
                    }
                    return cell
                }
            }else if indexPath.row == AppSettingsIndexesForGuest.terms.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsTermsLinkCell") as? AppSettingsTermsLinkCell {
                    cell.nameLbl.text = AppSettingsTitles.termsNcondition
                    cell.nameLbl.underline()
                    cell.buttonAction = {
                        self.showTermsAndCondition()
                    }
                    return cell
                }
            }
            else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsRadioButtonCell") as? AppSettingsRadioButtonCell {
                    
                    switch indexPath.row {
                    case AppSettingsIndexesForGuest.Music.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.music
                        cell.button.isSelected = viewModel.musicEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.musicEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.SoundEffects.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.soundEffects
                        cell.button.isSelected = viewModel.soundEffectsEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.soundEffectsEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.EmailNotices.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.emailNotices
                        cell.button.isSelected = viewModel.emailNoticesEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.emailNoticesEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.PushNotification.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.pushNotification
                        cell.button.isSelected = viewModel.pushNotificationEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.pushNotificationEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.ContactInfo.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.contactInfo
                        cell.button.isSelected = viewModel.contactInfoEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.contactInfoEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.CityCountry.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.cityCountry
                        cell.button.isSelected = viewModel.cityCountryEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.cityCountryEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.PremiumMember.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.premiumMember
                        cell.button.isSelected = viewModel.premiumMemberEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.premiumMemberEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.RemainSignIn.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.remainSignIn
                        cell.button.isSelected = viewModel.remainSignInEnabled
                        Singleton.sharedInstance.remainSignIn = viewModel.remainSignInEnabled
                        cell.buttonAction = { isEnabled in
                            Singleton.sharedInstance.remainSignIn = isEnabled
                            self.viewModel.remainSignInEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexesForGuest.backGroundSound.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.backgroundSound
                        cell.button.isSelected = Singleton.sharedInstance.backgroundSettingisOn
                        cell.buttonAction = { isEnabled in
                            Singleton.sharedInstance.backgroundSettingisOn = isEnabled
                            if !isEnabled{
                                if AudioPlayer.shared.isPlaying{
                                    AudioPlayer.shared.pause()
                                }
                            }
                           // self.viewModel.remainSignInEnabled = isEnabled
                           // self.updateSettings()
                        }
                    default:
                        break
                    }
                    
                    return cell
                }
            }
        }else{
            if indexPath.row == AppSettingsIndexes.ACLAccount.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsACLAccountCell") as? AppSettingsACLAccountCell {
                    cell.titleLabel.text = AppSettingsTitles.ACLAccount
                    // do not show Signup title if user is already acl user
                    if DataManager.shared.isACLAccount {
                        cell.signupButton.setTitle("Profile", for: .normal)
                    } else {
                        cell.signupButton.setTitle("Sign up", for: .normal)
                    }
                    // button action
                    cell.buttonAction = {
                        self.showSignupScreen()
                    }
                    return cell
                }
            } else if indexPath.row == AppSettingsIndexes.UpdateProfile.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsUpdateProfileCell") as? AppSettingsUpdateProfileCell {
                    cell.titleLabel.text = AppSettingsTitles.updateProfile
                    cell.cityLabel.text = viewModel.profileSeenLocation
                    cell.dobLabel.text = viewModel.profileSeenDate
                    cell.usernameLabel.text = viewModel.profileSeenUsername
                    if viewModel.ownChapter != nil && viewModel.ownChapter != ""{
                        cell.chapterLbl.text = "Chapter Leader of \(viewModel.ownChapter ?? "  ") Chapter"
                    }else{
                        cell.chapterLbl.text = ""
                    }
                    cell.buttonAction = {
                        if let updateProfileCommunityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileViewController") as? UpdateProfileViewController {
                                  // updateProfileCommunityController.moveBackOnCompletion = moveBackOnCompletion
                                   self.navigationController?.pushViewController(updateProfileCommunityController, animated: true)
                               }
                        
                        //self.showUpdateProfileScreen(false)
                    }
                    return cell
                }
            } else if indexPath.row == AppSettingsIndexes.Donate.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsDonateCell") as? AppSettingsDonateCell {
                    cell.buttonAction = {
                        openwebLink(controller: self, link: donateUrl)
                    }
                    return cell
                }
            }else if indexPath.row == AppSettingsIndexes.terms.rawValue {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsTermsLinkCell") as? AppSettingsTermsLinkCell {
                    cell.nameLbl.text = AppSettingsTitles.termsNcondition
                    cell.buttonAction = {
                        self.showTermsAndCondition()
                    }
                    cell.nameLbl.underline()
                    return cell
                }
            }
            else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "AppSettingsRadioButtonCell") as? AppSettingsRadioButtonCell {
                    
                    switch indexPath.row {
                    case AppSettingsIndexes.Music.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.music
                        cell.button.isSelected = viewModel.musicEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.musicEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.SoundEffects.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.soundEffects
                        cell.button.isSelected = viewModel.soundEffectsEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.soundEffectsEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.EmailNotices.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.emailNotices
                        cell.button.isSelected = viewModel.emailNoticesEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.emailNoticesEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.PushNotification.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.pushNotification
                        cell.button.isSelected = viewModel.pushNotificationEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.pushNotificationEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.ContactInfo.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.contactInfo
                        cell.button.isSelected = viewModel.contactInfoEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.contactInfoEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.CityCountry.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.cityCountry
                        cell.button.isSelected = viewModel.cityCountryEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.cityCountryEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.PremiumMember.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.premiumMember
                        cell.button.isSelected = viewModel.premiumMemberEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.premiumMemberEnabled = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.RemainSignIn.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.remainSignIn
                        cell.button.isSelected = viewModel.remainSignInEnabled
                        Singleton.sharedInstance.remainSignIn = viewModel.remainSignInEnabled
                        cell.buttonAction = { isEnabled in
                            self.viewModel.remainSignInEnabled = isEnabled
                            Singleton.sharedInstance.remainSignIn = isEnabled
                            self.updateSettings()
                        }
                    case AppSettingsIndexes.backGroundSound.rawValue:
                        cell.titleLabel.text = AppSettingsTitles.backgroundSound
                        cell.button.isSelected = Singleton.sharedInstance.backgroundSettingisOn
                        cell.buttonAction = { isEnabled in
                            Singleton.sharedInstance.backgroundSettingisOn = isEnabled
                            if !isEnabled{
                                if AudioPlayer.shared.isPlaying{
                                    AudioPlayer.shared.pause()
                                }
                            }
//                            self.viewModel.remainSignInEnabled = isEnabled
//                            self.updateSettings()
                        }
                    default:
                        break
                    }
                    
                    return cell
                }
            }
        }
        

        
        
        return UITableViewCell()
    }
    
 
    
    func showTermsAndCondition(){
               if let pdfUrl = Bundle.main.url(forResource: "Terms and Conditions", withExtension: "pdf", subdirectory: nil, localization: nil) {

                   do {
                       let data = try Data(contentsOf: pdfUrl)
                    let vc = UIViewController()
                    
                    
                    webview = WKWebView()
                    webview.frame = CGRect(x: 0, y: 50, width: vc.view.frame.width, height: vc.view.frame.height)
                       webview.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: pdfUrl.deletingLastPathComponent())
                       print("pdf file loading...")
                    
                    
//                    self.view.addSubview(webview)
                  
                    let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
                    navigationBar.barTintColor = UIColor.lightGray
                    //vc.view.addSubview(navigationBar)

                    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(crossBtn))

                    let navigationItem = UINavigationItem(title: "Terms of Services")
                    navigationItem.rightBarButtonItem = doneButton

                    navigationBar.items = [navigationItem]
                    
                    vc.view.addSubview(webview)
                     vc.view.addSubview(navigationBar)
                    self.present(vc, animated: true, completion: nil)
                   }
                   catch {
                       print("failed to open pdf")
                   }
                   return
               }

               print("pdf file doesn't exist")
    }
    @objc func crossBtn(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AppSettingsViewController: UpdateProfileCommunityMessageDelegate {
    func signupDidTap() {
        // Navigate to success screen
        if let updateProfileCommunityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityController") as? UpdateProfileCommunityController {
            Singleton.sharedInstance.isNeedSignupFromEventScreen = false
            self.navigationController?.pushViewController(updateProfileCommunityController, animated: true)
        }
    }
}
