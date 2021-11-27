//
//  CalendarViewController.swift
//  ACL
//
//  Created by Gagandeep on 12/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: BaseViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var eventInfoLabel: UILabel!
    @IBOutlet weak var evenInfoViewTopContraint: NSLayoutConstraint!
    @IBOutlet weak var eventInfoView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    var selectedDates: [Date] = [Date(), Date()]
    var preSelectedCell: CalendarCell?
    
    var viewModal = CalenderViewModel()
    var selectedDate = ""
    var needNavigation = false
    var datesForSelected = [Date]()
    var userReminders = [[String: Any]]()
    var needNavigationOnJournal = false
    var selectedReminderTExt = ""
    var selectedReminderTimeStamp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCalendar()
        setupUI()
        
        SwiftLoader.show(animated: true)
        viewModal.getData { (IsSucess, str) in
            //SwiftLoader.hide()
            self.getAlldatesAndSetup()
        }
        
    }
    
    func getAlldatesAndSetup(){
        for data in viewModal.calender{
            let dateStr = Double(data.enroll_date ?? "")?.getOnlyDateStringFromUTC()
            let date = getDateFromString(str: dateStr ?? "")
            selectedDates.append(date)
        }
        
        if let reminderDates = UserDefaults.standard.value(forKey: reminderKey) as? [[String: Any]]{
            userReminders = reminderDates
            for dates in reminderDates{
                
                let date = dates["date"] as? String ?? ""
                let getDate = Double(date)?.getOnlyDateStringFromUTC()
                let dateFormat = getDateFromString(str: getDate ?? "")
                selectedDates.append(dateFormat)
            }
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
        
        calendarView.selectDates(selectedDates)
        eventInfoView.isHidden = true
        DispatchQueue.main.async {
                       self.calendarView.reloadData()
                   }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            self.calendarView.reloadData()
//        })
        
     //   SwiftLoader.show(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            SwiftLoader.hide()
               // self.calendarView.reloadData()
        }
    }
    
    func getDateFromString(str: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone

         let date = dateFormatter.date(from: str)
        print("here is dates --->",date as Any)
        return date ?? Date()
    }
    
    func configureCalendar() {
        calendarView.ibCalendarDelegate = self
        calendarView.ibCalendarDataSource = self
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.allowsDateCellStretching = true
        // keep single selection only
        calendarView.allowsMultipleSelection = true
    }
    
    func setupUI() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.moveToInfo))
        tap.numberOfTapsRequired = 1
        eventInfoLabel.addGestureRecognizer(tap)
        eventInfoLabel.isUserInteractionEnabled = true
        // set date on top
        monthLabel.text = Date().getString()
        // set calendar cell
        calendarView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
        calendarView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        calendarView.scrollToDate(Date(), triggerScrollToDateDelegate: true, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0, completionHandler: nil)
        // hide detail view
        eventInfoView.isHidden = true
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        // hide info view
        eventInfoView.isHidden = true
        // scroll
        calendarView.scrollToSegment(SegmentDestination.next)
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        // hide info view
        eventInfoView.isHidden = true
        // scroll
        calendarView.scrollToSegment(SegmentDestination.previous)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToACL(_ sender: Any) {
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
    
    func getDate(From: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter.string(from: From)
    }
    
    func pushToJournalVC(text : String,timeStamp : String){
        if let myJournalViewController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "MyJournalViewController") as? MyJournalViewController {
            myJournalViewController.isFromCalendar = true
            myJournalViewController.textFromCalendar = text
            myJournalViewController.timeStampFromCal = timeStamp
            self.navigationController?.pushViewController(myJournalViewController, animated: true)
        }
    }
    
    @objc func moveToInfo() {
        if needNavigation == true{
            if self.needNavigationOnJournal == false{
                if let calendarACLEventInfoController = UIStoryboard(name: "MyJournal", bundle: nil).instantiateViewController(withIdentifier: "CalendarACLEventInfoController") as? CalendarACLEventInfoController {
                    let date = selectedDate.replacingOccurrences(of: "-", with: " ")
                    calendarACLEventInfoController.dateText = date
                    self.navigationController?.pushViewController(calendarACLEventInfoController, animated: true)
                }
            }else{
                self.pushToJournalVC(text: self.selectedReminderTExt, timeStamp: self.selectedReminderTimeStamp)
            }
        }
        
    }
}


extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = dateByAddingDays(inDays: 365)
        return ConfigurationParameters(startDate: startDate,endDate: endDate,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfRow,
                                       firstDayOfWeek: .monday)
    }
    
    func dateByAddingDays(inDays: Int) -> Date {
        let today = Date()
        return Calendar.current.date(byAdding: .day, value: inDays, to: today)!
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        DispatchQueue.main.async {
            if calendar.cellStatus(for: date)?.isSelected ?? false{
                cell.dotLbl.isHidden = false
            }else{
                cell.dotLbl.isHidden = true
            }
        }
        
        setupCell(cell: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let calCell = cell as? CalendarCell else { return }
        calCell.dateLabel.text = cellState.text
        setupCell(cell: calCell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return true 
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let calCell = cell as? CalendarCell {
            handleCellSelected(cell: calCell, cellState: cellState)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if let calCell = cell as? CalendarCell {
            handleCellSelected(cell: calCell, cellState: cellState)
        }
    }
    
    func setupCell(cell: CalendarCell, cellState: CellState) {
        cell.backView.isHidden = true
        if cellState.dateBelongsTo == .thisMonth {
            // make thode dates selected if that are in selected array
            if selectedDates.contains(cellState.date) {
                cell.backView.isHidden = true
//                cell.backView.backgroundColor = AppTheme.lightOrange
                cell.dateLabel.textColor = .white
            } else {
                cell.backView.isHidden = true
                cell.dateLabel.textColor = .white
            }
        } else {
            cell.dateLabel.textColor = AppTheme.steelGray
            cell.backView.isHidden = true
        }
    }
    
    func handleCellSelected(cell: CalendarCell, cellState: CellState) {
        guard cellState.dateBelongsTo == .thisMonth else {
            return
        }
        // check if this is new cell tapped
        if preSelectedCell != cell {
            // cell colors and title
            cell.backView.isHidden = false
            // for tap, keep color to white
            cell.backView.backgroundColor = .white
            cell.dateLabel.textColor = .black
//            cell.dateLabel.textColor = AppTheme.mediumPurple

            
            // update date on month label
            monthLabel.text = cellState.date.getString()
            // move event info view according to selected date
            moveDetailView(to: self.view.convert(cell.frame, from: calendarView))
            // update date on info view
            dateLabel.text = cell.dateLabel.text
            let selectedDate = "\(cell.dateLabel.text ?? "")-\(cellState.date.onlyMonthString())-\(cellState.date.onlyYearString())"
            
            
          //  let timeStamp = getTimeStamp(date: selectedDate)
            let dfmatter = DateFormatter()
            dfmatter.dateFormat="dd-MMMM-yyyy"
            //dfmatter.locale = Locale(identifier: "en_US_POSIX")
            dfmatter.timeZone = TimeZone.current
//            dfmatter.timeZone = TimeZone(identifier:"GMT")


            if  let date : NSDate? = (dfmatter.date(from: selectedDate) as! NSDate) {
            let dateStamp = date?.timeIntervalSince1970
                print("here is timestamp--->>>",dateStamp?.cleanValue)
                let hasEvent = dateHasEvent(date: dateStamp!.cleanValue)
                let hasReminder = dateHasReminder(date: dateStamp!.cleanValue)
            if hasEvent == true{
                self.selectedDate = selectedDate
                self.needNavigation = true
                self.needNavigationOnJournal = false
                eventInfoLabel.textColor = AppTheme.mediumPurple
                eventInfoLabel.text = getEventName(date: dateStamp!.cleanValue)
            }else if hasReminder.0 == true{
               self.selectedDate = selectedDate
                self.needNavigation = true
                self.needNavigationOnJournal = true
                eventInfoLabel.textColor = AppTheme.mediumPurple
                eventInfoLabel.text = hasReminder.1
                self.selectedReminderTExt = hasReminder.1
                self.selectedReminderTimeStamp = hasReminder.2
                
            } else{
                self.selectedDate = ""
                self.needNavigation = false
                eventInfoLabel.textColor = .lightGray
                eventInfoLabel.text = "My ACL Event"
            }}
            // unhide event info view
            eventInfoView.isHidden = false
            
            // change state to default for pre selected cell
            if let preCell = preSelectedCell {
                preCell.backView.isHidden = true
                preCell.dateLabel.textColor = .white
            }
            
            // update new cell's referance
            preSelectedCell = cell
        } else {
            cell.backView.isHidden = true
            cell.dateLabel.textColor = .white
            monthLabel.text = cellState.date.monthYearString()
            
            // hide event info view
            eventInfoView.isHidden = true
            preSelectedCell = nil
        }
    }
    
    func getTimeStamp(date: String) -> Double{
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="dd-MMMM-yyyy"
        let date = dfmatter.date(from: date)
        let dateStamp = date!.timeIntervalSince1970
        return Double(dateStamp)
    }
    
    
    func dateHasEvent(date: String) -> Bool{
        var hasValue = false
        for data in viewModal.calender{
            let selectDate = Double(date)?.getOnlyDateStringFromUTC()
            let calendarDate = Double(data.enroll_date ?? "")?.getOnlyDateStringFromUTC()
            
            if selectDate == calendarDate{
               hasValue = true
            }
        }
        return hasValue
    }
    
    func dateHasReminder(date: String) -> (Bool,String,String){
           var hasValue = false
            var reminder = ""
            var timeStamp = ""
           for data in userReminders{
            let reminderDate = data["date"] as? String ?? ""
            
            let title = data["name"] as? String ?? ""
               let selectDate = Double(date)?.getOnlyDateStringFromUTC()
               let calendarDate = Double(reminderDate)?.getOnlyDateStringFromUTC()
               
               if selectDate == calendarDate{
                timeStamp = reminderDate
                  hasValue = true
                reminder = title
               }
           }
           return (hasValue, reminder,timeStamp)
       }
    
    
    
      func getEventName(date: String) -> String{
          var name = ""
          for data in viewModal.calender{
            let selectDate = Double(date)?.getOnlyDateStringFromUTC()
            let calendarDate = Double(data.enroll_date ?? "")?.getOnlyDateStringFromUTC()
              if selectDate == calendarDate{
                name = data.name ?? ""
              }
          }
          return name
      }
    
    
    func moveDetailView(to frame: CGRect) {
        evenInfoViewTopContraint.constant =  frame.origin.y + 4
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        if let last = visibleDates.monthDates.last?.date {
            monthLabel.text = last.monthYearString()
        }
    }
}
