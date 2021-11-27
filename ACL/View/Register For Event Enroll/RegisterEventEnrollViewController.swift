//
//  RegisterEventEnrollViewController.swift
//  ACL
//
//  Created by Aman on 03/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import SafariServices
import EventKit


class RegisterEventEnrollViewController: BaseViewController{

    //MARK: outlets
    @IBOutlet weak var enrollTableView: UITableView!
    @IBOutlet weak var noticeView: UIView!
    @IBOutlet weak var noticeLbl: UILabel!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var noticeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var underDonateLbl: UILabel!
    
    var viewModal = RegisterEventViewModal()
    var isFromLiveEvent = false
    let eventStore = EKEventStore()
    @IBOutlet weak var noticeHideView: UIView!
    var clickedLink = ""
//    let learnText = "A donation of $10, or whatever amount you can afford, is requested (Donate Button), but all members are welcome regardless of ability to pay*"
    
    let learnText = "Please help support ACL Live Events! A donation of whatever amount you like is requested but all members are welcome reglardless of ability to donate at this time.  You will have another opportunity to make a donation after the event if you prefer."
    
    let popUpText = "Registrations will be processed up to 24 hours prior to the event. We will do our best to include everyone who has registered, but cannot promise that late registrations will be done in time to attend. If you miss the deadline, don't worry! You can register early for next week's event!"
    
    
    let feedbackLink = "https://forms.gle/9eG6n1SVXn2W4QkT9"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clickHereTapped(_:)))
        noticeLbl.isUserInteractionEnabled = true
        noticeLbl.addGestureRecognizer(gesture)
//        noticeHideView.backgroundColor = UIColor.colorFromHex("234283")//234283
//        noticeHideView.applyGradient(colours: [UIColor.colorFromHex("2b488a"),UIColor.colorFromHex("2a4888")])
//        noticeHideView.cornerRadius = 10
        noticeHideView.backgroundColor = .clear
        if !isFromLiveEvent{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showNormalMsg(self.popUpText, title: "NOTE", completion: nil)
            }
            underDonateLbl.text = "Please help support ACL Live Events! A donation of whatever amount you like is requested but all members are welcome regardless of ability to donate at this time.  You will have another opportunity to make a donation after the event if you prefer."
        }else{
            if DataManager.shared.isGuestUser{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.pushForregister(isFromGuest: true)
                }
            }
            underDonateLbl.text = "Please help support ACL Live Events! A donation of whatever amount you like is requested but all members are welcome regardless of ability to donate at this time."

        }
//        underDonateLbl.text = "Please help support ACL Live Events! A donation of whatever amount you like is requested but all members are welcome reglardless of ability to donate at this time.  You will have another opportunity to make a donation after the event if you prefer."
       // gesture.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        if DataManager.shared.isGuestUser{
//            noticeLbl.text = "if non premium member  You must have ACL Premium to Enroll"
                noticeLbl.attributedText = getAttributedSTRWithUnderLine(str1: "You must have a full ACL Community account (FREE) to enroll in live events. ", str2: "Click here to create account")
        }else{
            noticeLbl.text = "ACL Community Member"
            if isFromLiveEvent{
                self.addFeedbackLInk(text: "Please return here to complete a feedback form after your event.  It truly helps us to improve the live experience!'  Enjoy your event ❤️. CLICK HERE TO SHARE FEEDBACK", isFromLive: true)
                noticeViewHeight.constant = 150
            }else{
               // noticeLbl.text = "You must be a full Living ACL Member to attend live events"
                self.addFeedbackLInk(text: "Registration for ACL live zoom meetings is FREE!\nStep 1: Complete the ACL Global Project Shared Agreement here:  click here  **This stays in effect so only needs to be done once**\nStep 2: Choose your event below by clicking 'enroll now' next to your choice.\n*You must have a full Living ACL account to attend live events (free). Guests, you can change to full account in settings*", isFromLive: false)
//                noticeLbl.text = ""
                noticeViewHeight.constant = 264
            }
        }
        

          SwiftLoader.show(animated: true)
              viewModal.getEventList { (isSuccess, str) in
                  SwiftLoader.hide()
                DispatchQueue.main.async {
                    self.enrollTableView.reloadData()
                }
              }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        eventStore.requestAccess(
            to: EKEntityType.event, completion: {(granted, error) in
                if !granted {
                    print("Access to store not granted")
//                    print(error!.localizedDescription)
                } else {
                    print("Access granted")
                    
                }
            })
    }
    
    override func viewDidLayoutSubviews() {

        if isFromLiveEvent{
            feedbackBtn.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        }else{
            feedbackBtn.applyGradient(colours: [AppTheme.lightGreen, AppTheme.lightGreen])
        }
    }
    
    
    
     //MARK: register nibs
       func registerNib(){
           enrollTableView.register(UINib(nibName: "EnrollCell", bundle: nil), forCellReuseIdentifier: "EnrollCell")
           enrollTableView.tableFooterView = UIView()
        //setup view
        noticeView.layer.borderWidth = 1
        noticeView.layer.borderColor = UIColor.white.cgColor
        noticeView.layer.cornerRadius = 17
        if isFromLiveEvent == false{
            self.enrollTableView.estimatedRowHeight = 70
        }else{
            self.enrollTableView.estimatedRowHeight = 100

        }
       }
    

    @objc func clickHereTapped(_ tapGesture : UITapGestureRecognizer){
        if DataManager.shared.isGuestUser{
            self.pushForregister(isFromGuest: false)
        }
    }
    
//MARK: Butotn actions
    
    @IBAction func donateBtn(_ sender: UIButton) {
        openwebLink(controller: self, link: donateUrl)
    }
    
    
    @IBAction func learnMore(_ sender: UIButton) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }
    }
    @IBAction func BackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func feedbackBtn(_ sender: UIButton) {
        openwebLink(controller: self, link: "https://forms.gle/9eG6n1SVXn2W4QkT9")

    }
    
    @IBAction func learnAboutBtn(_ sender: UIButton) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }
    }
    
    func addFeedbackLInk(text: String,isFromLive : Bool){
        let string  = text
        var  range = NSRange()
        if isFromLive{
             range   = (string as NSString).range(of: "CLICK HERE TO SHARE FEEDBACK")
        }else{
             range   = (string as NSString).range(of: "click here")
        }
        
        let attributedString  = NSMutableAttributedString(string: string)

        //attributedString.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "\(feedbackLink)")!, range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.white, range: range)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.white, range: range)

        noticeLbl.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(feedBackBtnTap))
        noticeLbl.attributedText = attributedString
        noticeLbl.addGestureRecognizer(tapGesture)
    }
    
    @objc func feedBackBtnTap(){
        if isFromLiveEvent{
            openwebLink(controller: self, link: "https://forms.gle/9eG6n1SVXn2W4QkT9")

        }else{
            //https://forms.gle/KnRT4si8ZKbaRHNs8
            openwebLink(controller: self, link: "https://forms.gle/KnRT4si8ZKbaRHNs8")
        }

    }
    
}

extension RegisterEventEnrollViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.eventList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnrollCell") as! EnrollCell
        cell.eventTitle.text = viewModal.eventList[indexPath.row].title
       // print(viewModal.eventList[indexPath.row].title)
        cell.eventDate.text = viewModal.eventList[indexPath.row].event_date
        if isFromLiveEvent == true{
            cell.copyBtn.tag = indexPath.row
            cell.enrollBtn.isHidden = true
            cell.copyBtn.isHidden = false
            cell.copyBtn.addTarget(self, action: #selector(copyBtnClick(_:)), for: .touchUpInside)
            cell.urlLabel.isHidden = true
            cell.urlLabel.text = ""
            cell.eventTitle.numberOfLines = 0

        }else{
            
            cell.urlLabel.isHidden = false
            cell.urlLabel.text = viewModal.eventList[indexPath.row].zoomLink
            cell.urlLabel.textColor = UIColor.colorFromHex("2196F3")
            if viewModal.eventList[indexPath.row].zoomLink?.count ?? 0 > 0{
                cell.urlLabel.underline()
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkClicked(_:)))
            cell.urlLabel.isUserInteractionEnabled = true
            cell.urlLabel.addGestureRecognizer(tapGesture)
            clickedLink = cell.urlLabel.text ?? ""
            cell.copyBtn.isHidden = true
            cell.enrollBtn.isHidden = false
            cell.enrollBtn.setImage(UIImage(named: ""), for: .normal)
            cell.eventTitle.numberOfLines = 0
            if viewModal.eventList[indexPath.row].isEnrolled == true{
                cell.enrollBtn.setTitle("Add to Calendar", for: .normal)
                cell.enrollBtn.titleLabel?.lineBreakMode = .byWordWrapping
                cell.enrollBtn.contentMode = .center
                cell.enrollBtn.titleLabel?.textAlignment = .center
            }else{
                cell.enrollBtn.isUserInteractionEnabled = true
                cell.enrollBtn.setTitle("Enroll Now", for: .normal)
            }

        }
        cell.enrollBtn.tag = indexPath.row
        cell.enrollBtn.addTarget(self, action: #selector(enrollBtnClick(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromLiveEvent == true{
          // return 85
            return UITableView.automaticDimension

        }else{
            return UITableView.automaticDimension
        }
    }
    
    
    
    
    
    func setReminder(desc: String, timestamp : Double,title: String){
        
        let authorizationStatus = EKEventStore.authorizationStatus(for: .event);
                            switch authorizationStatus {
                            case .notDetermined:
                                print("notDetermined");
                            case .restricted:
                                print("restricted");
                            case .denied:
                                print("denied");
                            case .authorized:
                                print("authorized");
                            }
        
        if authorizationStatus == .authorized{
            
            self.createReminder(in: eventStore, Descpriction: desc, timestamp: timestamp,title: title)
        }else{
         
            displayALertWithTitles(title: "Alert!",message: "Allow ACL to access Calendar", ["Settings"]) { (index, iscancel) in
                if !iscancel{
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        }
       
    }
    
    func createReminder(in eventStore: EKEventStore, Descpriction : String,timestamp:Double, title: String) {
        
        
        guard let calendar = eventStore.defaultCalendarForNewEvents else {
            print("error")
            
            return
        }
        
        
        
        let newReminder = EKEvent(eventStore: eventStore)
        newReminder.calendar = calendar
        newReminder.title = title
        
        newReminder.startDate = Date.init(timeIntervalSince1970: timestamp)
        newReminder.endDate = Date.init(timeIntervalSince1970: timestamp + 3600)

        newReminder.notes = Descpriction
        
        var eventExist = false
        let predicate = eventStore.predicateForEvents(withStart: Date.init(timeIntervalSince1970: timestamp), end: Date.init(timeIntervalSince1970: timestamp + 3600), calendars: nil)
        let existingEvents = eventStore.events(matching: predicate)
        for singleEvent in existingEvents {
            if singleEvent.title == title && singleEvent.startDate == Date.init(timeIntervalSince1970: timestamp) {
                eventExist = true
            }
        }
        
        if eventExist == true{
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Notice!", message: "Already added", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }

        }else{
            
            try! eventStore.save(newReminder, span: .thisEvent)
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "ACL", message: "Added succesfully", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)

            }
        }
    }
    
    
    
    func pushForregister(isFromGuest : Bool){
        if let updateProfileCommunityMessageController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityMessageController") as? UpdateProfileCommunityMessageController {
            updateProfileCommunityMessageController.modalPresentationStyle = .overCurrentContext
            updateProfileCommunityMessageController.delegate = self
            updateProfileCommunityMessageController.isFromEnroll = true
            if isFromGuest{
                updateProfileCommunityMessageController.isGuestFirstPopup = true
            }else{
                updateProfileCommunityMessageController.isGuestFirstPopup = false
            }
            self.navigationController?.present(updateProfileCommunityMessageController, animated: true, completion: nil)
        }

    }
    
    @objc func linkClicked(_ sender: UITapGestureRecognizer){
        
        if DataManager.shared.isGuestUser{
            pushForregister(isFromGuest: false)
        }else{
            guard let label = sender.view as? UILabel else {
                  print("Error not a label")
                  return
              }
            if label.text != ""{
                let urlFromStr = URL(string: label.text ?? "")
                guard let url = urlFromStr else { return }
                UIApplication.shared.open(url)

            }
        }
    
    }
    
    
  @objc func copyBtnClick(_ sender : UIButton){
    if DataManager.shared.isGuestUser{
        pushForregister(isFromGuest: false)
    }else{
        let data = viewModal.eventList[sender.tag]
        UIPasteboard.general.string = data.zoomLink
        self.showToast(message: "Link copied!", font: AppFont.get(.medium, size: 16))

    }

    }
    
    
    @objc func enrollBtnClick(_ sender : UIButton){
        if DataManager.shared.isGuestUser{
            pushForregister(isFromGuest: false)
        }else{
            let data = viewModal.eventList[sender.tag]
                if data.isEnrolled == true{
                    //
                    self.setReminder(desc: data.description ?? "", timestamp: data.originalTimeStamp ?? 0, title: data.title ?? "")

                }else{
                    SwiftLoader.show(animated: true)
                    viewModal.joinEvent(event_Id: "\(data.id ?? 0)") { (IsSuccess, str) in
                        SwiftLoader.hide()
                        if IsSuccess == true{
                            if let appSettingsViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "CalendarACLEventInfoController") as? CalendarACLEventInfoController {
                                appSettingsViewController.isFromEnroll = true
                                appSettingsViewController.dateText = data.event_date ?? ""
                                appSettingsViewController.linkText = data.zoomLink ?? ""
                                self.navigationController?.pushViewController(appSettingsViewController, animated: true)
                            }
                        }else{
                            self.showError(str)
                        }
                    }
                }

        }


    }
    
}

extension RegisterEventEnrollViewController : UpdateProfileCommunityMessageDelegate{
    func signupDidTap() {
        if let updateProfileCommunityController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "UpdateProfileCommunityController") as? UpdateProfileCommunityController {
            Singleton.sharedInstance.isNeedSignupFromEventScreen = true
            self.navigationController?.pushViewController(updateProfileCommunityController, animated: true)
        }

    }
    
    
}
