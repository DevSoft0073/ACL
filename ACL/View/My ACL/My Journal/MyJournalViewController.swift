//
//  MyJournalViewController.swift
//  ACL
//
//  Created by Gagandeep on 11/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import EventKit
import DatePickerDialog

class MyJournalViewController: BaseViewController {
    
    @IBOutlet weak var calanderButton: DefaultDoneButton!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var voiceRecordButton: UIButton!
    @IBOutlet weak var setReminderButton: UIButton!
    @IBOutlet weak var favIconImage: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    
    var eventStore = EKEventStore()
    var calendars:Array<EKCalendar> = []
    
    var isFromCalendar = false
    var textFromCalendar = ""
    var timeStampFromCal = ""
    var dictForChange = [String: Any]()
    var datePicker = DatePickerDialog()
    let learnText = "This journal is all yours in which to write or record thoughts, feelings, reminders - whatever you like!  Nobody but you can access the content  (Nope- not even us)   PLEASE SAVE YOUR PIN IN A SAFE AND SECURE LOCATION.  "
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // take permission for audio recorder
        KAudioRecorder.shared.authorise()
        // setup
        setupView()
        getReminderPermission()
    }
    
    func getReminderPermission(){
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }else{
                    
                }
        })
        self.calendars = self.eventStore.calendars(for: EKEntityType.reminder)
        if (self.calendars as [EKCalendar]).count == 0{
            
        }
        for calendar in self.calendars as [EKCalendar] {
            print("Calendar = \(calendar.title)")
        }
        
    }
    
    func setupView() {
        calanderButton.applyGradient(colours: [AppTheme.mediumPurple, AppTheme.lightOrange])
        currentDateLabel.text = Date().getString()
        setReminderButton.addUnderLine(with: AppTheme.lightOrange)
        voiceRecordButton.addUnderLine(with: AppTheme.lightOrange)
        //        favouriteButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
        favIconImage.image = UIImage(named: "main_screen_star")
        txtView.setLayer()
        
        if isFromCalendar == true{
            favouriteButton.isHidden = false
            favIconImage.isHidden = false
            txtView.text = textFromCalendar
            txtView.isUserInteractionEnabled = false
            voiceRecordButton.isHidden = true
            setReminderButton.isHidden = true
            calanderButton.alpha = 0.3
            calanderButton.isUserInteractionEnabled = false
            
            if let data = UserDefaults.standard.value(forKey: reminderKey) as? [[String : Any]]{
//                let newReminder = ["name": message, "date": timeStamp, "isFavourite" : false] as [String : Any]
                for dict in data{
                    let checkDate = checkTimeStampIsSame(data: dict)
                    if checkDate == true{
                        self.dictForChange = dict
                        let isFav = dict["isFavourite"] as? Bool
                        if isFav == true{
                            favIconImage.image = UIImage(named: "main_screen_star")

                        }else{
                            favIconImage.image = UIImage(named: "silverStar")

                        }
                    }
                }
            }
            
            
        }else{
            calanderButton.alpha = 1
            calanderButton.isUserInteractionEnabled = true
            voiceRecordButton.isHidden = false
            setReminderButton.isHidden = false
            txtView.isUserInteractionEnabled = true
           favouriteButton.isHidden = true
           favIconImage.isHidden = true
        }
        
    }
    
    
    
    func checkTimeStampIsSame(data : [String: Any]) -> Bool {
        var isSame = false
        let date = data["date"] as? String
        if date == timeStampFromCal{
            isSame = true
        }
        
        
        return isSame
    }
    
    
    func setReminder(){
        
        guard let calendar = self.eventStore.defaultCalendarForNewReminders() else {
          //  self.eventStore.calendar(withIdentifier: "My ACL Events")
            print("error")
            return
        }
        let newReminder = EKReminder(eventStore: eventStore)
        newReminder.calendar = calendar
        newReminder.title = "ACL Reminder"
        newReminder.priority = Int(EKReminderPriority.medium.rawValue)
        newReminder.notes = txtView.text
        if #available(iOS 13.4, *) {
            datePicker.datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.show("Choose Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .dateAndTime) { date in
            if let dt = date {
                newReminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dt)
                try! self.eventStore.save(newReminder, commit: true)
                SwiftLoader.show(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    SwiftLoader.hide()
                    self.showPopUpForReminder("Your reminder is set. You can check it in Reminder App.") { (action) in
                        let timeStamp = (dt.timeIntervalSince1970).cleanValue
                        let message = self.txtView.text ?? ""
                        if var dataReminder = UserDefaults.standard.value(forKey: reminderKey) as? [[String : Any]]{
                            let newReminder = ["name": message, "date": timeStamp, "isFavourite" : false] as [String : Any]
                            dataReminder.append(newReminder)
                            UserDefaults.standard.set(dataReminder, forKey: reminderKey)
                        }else{
                            var dataDict = [[String: Any]]()
                            let newReminder = ["name": message, "date": timeStamp, "isFavourite" : false] as [String : Any]
                            dataDict.append(newReminder)
                            UserDefaults.standard.set(dataDict, forKey: reminderKey)
                        }
                    }
                }
            }
        }
        
        
    }
    
    func setFavTrueFalse(isForFav : Bool){
        if dictForChange.count > 0{
            print(dictForChange)
            setFavInUserDefaults(forType: isForFav)
        }
        
    }
    
    func setFavInUserDefaults(forType : Bool){
        var reminderData = UserDefaults.standard.value(forKey: reminderKey) as! [[String : Any]]
        var index = 0
        var dict = [String: Any]()
        
        for data in reminderData{
            let date = data["date"] as? String
            if date == timeStampFromCal{
                dict = data
                reminderData.remove(at: index)
                dict["isFavourite"] = forType
                reminderData.insert(dict, at: index)
                UserDefaults.standard.removeObject(forKey: reminderKey)
                UserDefaults.standard.set(reminderData, forKey: reminderKey)
            }
            index += 1
        }
        
    }
    
    
    //Button clicks
    @IBAction func calanderAction(_ sender: Any) {
        let calendarViewController = CalendarViewController.init(nibName: "CalendarViewController", bundle: nil)
        self.navigationController?.pushViewController(calendarViewController, animated: true)
    }
    @IBAction func learnAbout(_ sender: UIButton) {
//        let alert = UIAlertController(title: "My Journal", message: "About this feature", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }
        
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        SwiftLoader.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SwiftLoader.hide()
        }
        
        favouriteButton.isSelected = !favouriteButton.isSelected
        if favIconImage.image == UIImage(named: "main_screen_star"){
            favIconImage.image = UIImage(named: "silverStar")
            setFavTrueFalse(isForFav: false)
        }else{
            setFavTrueFalse(isForFav: true)

            favIconImage.image = UIImage(named: "main_screen_star")
        }
        //        if self.favouriteButton.imageView?.image == UIImage(named: "main_screen_star"){
        //            self.favouriteButton.setImage(UIImage(named: "silverStar"), for: .normal)
        //            }else{
        //            self.favouriteButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
        //        }
    }
    
    @IBAction func back(_ sender: Any) {
        if isFromCalendar == true{
            self.navigationController?.popViewController(animated: true)
        }else{
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
    
    @IBAction func voiceRecorderAction(_ sender: Any) {
        let vc = VoiceRecorderViewController.init(nibName: "VoiceRecorderViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func setReminderClick(_ sender: UIButton) {
        setReminder()
    }
}
