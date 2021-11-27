//
//  BaseViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAnalytics

class BaseViewController: UIViewController {
    // create imageview
    let backGroundImageView = UIImageView()
    var isVideoAlreadyAppend = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // add background color
        backGroundImageView.alpha = 0.7
        addBackgroundImage()
    }
    override func viewDidLayoutSubviews() {
        let screenSize = UIScreen.main.bounds
        self.backGroundImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
    }
    
   
    
    /// Setup image in background of view controller
    func addBackgroundImage() {
        backGroundImageView.contentMode = .scaleAspectFill
        // add image
        backGroundImageView.image = getBackgroundImage()
        view.insertSubview(backGroundImageView, at:0)
        
        // set contraints
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backGroundImageView.topAnchor
            .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -48).isActive = true
        backGroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 35).isActive = true
        backGroundImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        backGroundImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    /// Get image based on view controller
    func getBackgroundImage() -> UIImage? {
        if self.isKind(of: LoadingViewController.self) {
            return UIImage(named: "1. Loading Page w.quote and slideshow. shutterstock_132180743")
            //loginbackground
        }else if self.isKind(of: SignupViewController.self)  {
            return UIImage(named: "Account Setup premium screen_background")
            
        } else if self.isKind(of: UpdateProfileViewController.self) || self.isKind(of: UpdateProfileCommunityController.self) || self.isKind(of: ACLChapterRegisterViewController.self){
            return UIImage(named: "Account Setup premium screen_background")
            
        } else if self.isKind(of: SignupSuccessViewController.self)  {
            return UIImage(named: "3.Account Createdpacific-sunrise-PNZ2KBD")
            
        } else if self.isKind(of: WelcomeViewController.self)  {
            return UIImage(named: "Welcome_screen_background")
            
        } else if self.isKind(of: MainViewController.self) {
            return UIImage(named: "4. Main1 bckgrd shutterstock_334442669")
            
        } else if  self.isKind(of: MyACLViewController.self)  {
//            return UIImage(named: "Main screen background")
            return UIImage(named: "newMyACLBG")

            
        } else if self.isKind(of: LoginViewController.self) {
                  // return UIImage(named: "Login screen background")//loginbackground
            return UIImage(named: "loginbackground")

                   
        } else if  self.isKind(of: ForgotPasswordController.self) || self.isKind(of: EmailVerifiedViewController.self)  {
                return UIImage(named: "Login screen background")
            
        } else if self.isKind(of: AppSettingsViewController.self)  {
            return UIImage(named: "setting_background")
            
        } else if self.isKind(of: VideoViewController.self){
            return UIImage(named: "Video Screen_background")
            
        } else if self.isKind(of: DailyMeditationViewController.self) {
            return UIImage(named: "Daily maditation background")

        } else if  self.isKind(of: MeditationArchivesController.self) || self.isKind(of: CalendarViewController.self) {
            return UIImage(named: "Daily maditation background")
            
        } else if self.isKind(of: WeeklyChallengeViewController.self) || self.isKind(of: WeeklyChallengeCompleteController.self) {
           return UIImage(named: "Challenges Bckgrd1 shutterstock_1677690385")
            
        }  else if self.isKind(of: FindACLNearMeController.self)  || self.isKind(of: ChapterFormsViewController.self){
            return UIImage(named: "Find_ACL_group_background")
            
        } else if self.isKind(of: WeeklyChallenegDescriptionController.self) {
            return UIImage(named: "Challenges Bckgrd shutterstock_582394888")//Challenges Bckgrd1 shutterstock_1677690385
            
        } else if self.isKind(of: ThoughtGardenViewController.self) {
            return UIImage(named: "Thought Garden Bckgrd shutterstock_394106185")
            
        } else if self.isKind(of: QuestionOfWeekViewController.self) {
            return UIImage(named: "ThoughtOfGardenBackground")
//                return UIImage(named: "Thought Garden Bckgrd shutterstock_394106185")
//                   return UIImage(named: "Thought Garden Post.Plant the-clay-pots-in-gardening-retail-shop-XCRM32S")
                   
               }
        else if self.isKind(of: AnswerQuestionOfWeekController.self) {
//            let imageArray = ["Flower 1","Flower 2","Flower 3","Flower 4","Flower 5","Flower 6","Flower 7","Flower 8","Flower 9","Flower 10","Flower 11","Flower 12"]
//            let randomIndex = Int(arc4random_uniform(UInt32(imageArray.count)))
//            print(imageArray[randomIndex])
//            let image = imageArray[randomIndex]
            //return UIImage(named: image)
            return UIImage(named: "Thought Garden Post.Plant the-clay-pots-in-gardening-retail-shop-XCRM32S")

            
        } else if self.isKind(of: CreatePinViewController.self) || self.isKind(of: EnterPinViewController.self) {
           // return UIImage(named: "CreateMyJournalPinBackground")
            //newJournalBG
            return UIImage(named: "newJournalBG")

        } else if self.isKind(of: MyJournalViewController.self) {
                   return UIImage(named: "newJournlEntryBG")
                   
        }
        else if self.isKind(of: MyFavoritesViewController.self) {
            return UIImage(named: "my_favourites_background")
            
        } else if self.isKind(of: CalendarACLEventInfoController.self) {
            return UIImage(named: "CalendarACLEventInfo_background")
        } else if self.isKind(of: ACLLibraryViewController.self) {
                   return UIImage(named: "newLibraryBG")
               }
        
        else if  self.isKind(of: JoinLeaderShipViewController.self) || self.isKind(of: ChooseLocationViewController.self) || self.isKind(of: LeaderShipAgreementViewController.self) {
            return UIImage(named: "join_leadership_community_background")
        } else if self.isKind(of: SearchResultViewController.self)  {
            return UIImage(named: "JOIN_ACL_LIVE_EVENT_congratulation_background")
        }else if self.isKind(of: StartACLViewController.self){
//            return UIImage(named: "startAcl")
//            return UIImage(named: "startan_acl_chapter_own1_background")
            return UIImage(named: "Daily maditation background")
        }
        else if  self.isKind(of: StartACLCongratulationViewController.self){
            return UIImage(named: "Daily maditation background")
           

            //Daily maditation background
            
        }else if self.isKind(of: FormsDownloadViewController.self) || self.isKind(of: CongratsACLMemberViewController.self) {
            return UIImage(named: "download_stgarted-kit_background")
        }else if  self.isKind(of: RecruiteMemdersViewController.self){
            return UIImage(named: "LIBRARY _ARCHIVES_background")
        }else if    self.isKind(of: ChapterInfoFormViewController.self){
            return UIImage(named: "findacl_neear_you_bg")
        }else if      self.isKind(of: VideoUploadViewController.self) || self.isKind(of: WeekTrainingViewController.self){
            return UIImage(named: "attend_training_bg")
        }else if self.isKind(of: MyFavoritesContentViewController.self) {
            return UIImage(named: "my_favourites_background")
            
        }else if self.isKind(of: RegisterEventEnrollViewController.self) {
//            return UIImage(named: "JOIN ACL LIVE EVENT congratulation_background-1")
            return UIImage(named: "Main screen background")

            //Main screen background
        }
//        else if self.isKind(of: NewsViewController.self) || self.isKind(of: NewsDetailViewController.self) {
//            return UIImage(named: "NewsBackground")
//
//        }
        
        return UIImage()
    }

    // Change status bar color
    func changeStatusBarColor(_ color: UIColor) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath:
                "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    func setAttributedString(quote : String, author : String) -> NSAttributedString{
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.medium, size: 17)]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.regular, size: 16)]
        let partOne = NSMutableAttributedString(string: quote, attributes: normalFontAttributes)
        let partTwo = NSMutableAttributedString(string: " (\(author))", attributes: boldFontAttributes)

        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    
    
    func settingsAlert(title: String, message: String){
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
              alertController.dismiss(animated: true, completion: nil)
        
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert) in

              alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        //alertController.show()
    }
    
    /// Show error message
    func showError( _ message: String)  {
        let controller = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    //Congratulations
    func showCongratspopUp(title: String, message: String, completion :  ((UIAlertAction)->())?){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    
    // Show error message
    func showError( _ message: String, completion: ((UIAlertAction)->())?)  {
        let controller = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    // Show error message
     func showPopUpForReminder( _ message: String, completion: ((UIAlertAction)->())?)  {
         let controller = UIAlertController(title: "Reminder!", message: message, preferredStyle: .alert)
         let action = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
         controller.addAction(action)
         self.present(controller, animated: true, completion: nil)
     }
    
    func showNormalMsg( _ message: String,title: String, completion: ((UIAlertAction)->())?)  {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
        controller.addAction(action)
        self.present(controller, animated: true, completion: nil)
    }
    
    /// Move to main view controller
    func gotoMainViewController() {
        let mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        let navigationController = UINavigationController(rootViewController: mainViewController)
        navigationController.navigationBar.isHidden = true
        // get window
        guard let window = UIApplication.shared.delegate?.window else { return }
        // chenge root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    //show alert with textfield
    func showPopUpWithTextField(title: String, msg: String, placeholder: String,finished: @escaping (_ str: String) -> Void) {
       // var str = ""
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
            let textField = alertController.textFields![0] as UITextField

            if textField.text! == "" {
                return
            }
            finished(textField.text ?? "")
            //str = textField.text ?? ""
        })
        
        saveAction.isEnabled = false

        let cancelAction = UIAlertAction(title: "CANCEL", style: .default, handler: nil )
        cancelAction.setValue(UIColor.black, forKey: "titleTextColor")

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = placeholder
            textField.resignFirstResponder()
           // textField.delegate = self
            
            
            
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { note in
                if textField.text!.count > 0{
                    saveAction.isEnabled = true
                    saveAction.setValue(UIColor.black, forKey: "titleTextColor")
                }else{
                    saveAction.setValue(UIColor.gray, forKey: "titleTextColor")
                    saveAction.isEnabled = false
                }
            })
            
        }
        alertController.view.tintColor = UIColor.gray
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
    // Move to login screen
    func gotoLoginViewController() {
        UserDefaults.standard.removeObject(forKey: isSoundSelected_key)
        UserDefaults.standard.removeObject(forKey: selectedSoundURL_Key)
        UserDefaults.standard.removeObject(forKey: "defaultSound")

        //defaultSound
        if AudioPlayer.shared.isPlaying{
            AudioPlayer.shared.pause()
        }
        let loginViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true
        
        guard let window = UIApplication.shared.delegate?.window else { return }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showUpdateProfileScreen(_ moveBackOnCompletion: Bool) {
        if let updateProfileCommunityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityController") as? UpdateProfileCommunityController {
            updateProfileCommunityController.moveBackOnCompletion = moveBackOnCompletion
            self.navigationController?.pushViewController(updateProfileCommunityController, animated: true)
        }
    }
    
    /// Share app information through activity action sheet with friends
    func inviteFriend() {
        // text to share
//        let message = "Hi, I'm using ACL app and its really a good app with better services. Please find link below to download it and install it."
        let message = "Hi!  I've been using the new Living ACL app and love it!  I think you would too. You can download it here:"

        
        let link = "https://apps.apple.com/us/app/acl-dev/id1518864739"
        
        // set up activity view controller
        let textToShare = [message, link]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getCurrentDateIn(timeZone: String, newDate : Date) -> Date? {
    let dateFormatter              = DateFormatter()
    dateFormatter.dateFormat       = "yyyy-MM-dd h:mm a"
    let currentDateString : String = dateFormatter.string(from: newDate)
    guard let currentDate          = dateFormatter.date(from: currentDateString) else { return nil }
    dateFormatter.timeZone         = TimeZone.init(abbreviation: timeZone)
    let timeZoneDateString         = dateFormatter.string(from: currentDate)
    dateFormatter.timeZone         = TimeZone.current
        return dateFormatter.date(from: timeZoneDateString)
    }
    
    func addAnalytics(screenName : String , screenClass : String){
        
//        Analytics.logEvent(AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: screenName,
//                                                                  AnalyticsParameterScreenClass: screenClass])
        let parameters = ["uid": DataManager.shared.userId!,"screen_name":screenName]
        CloudDataManager.shared.reportPagesAPI(parameters) { (response, err) in
            if err == nil{
                print("page reported")
            }
        }
        
    }
    
}
