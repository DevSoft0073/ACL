//
//  ChapterInfoFormViewController.swift
//  ACL
//
//  Created by zapbuild on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import SwiftlyScrollSlider
import DatePickerDialog



class ChapterInfoFormViewController: BaseViewController {

    //MARK:- Outlets
    @IBOutlet weak var chapterMeetingFeild: DefaultTextField!
    @IBOutlet weak var firstMeetingFld: DefaultTextField!
    @IBOutlet weak var chapterAddressFeild: DefaultTextField!
    @IBOutlet weak var additionalColeader: DefaultTextField!
    @IBOutlet weak var coLeaderFld: DefaultTextField!
    @IBOutlet weak var leaderNameFeild: DefaultTextField!
    @IBOutlet weak var chapterTypeFeild: DefaultTextField!
    @IBOutlet weak var firstMonthFld: DefaultTextField!
    @IBOutlet weak var chapterNameFeild: DefaultTextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var groupStartedFld: DefaultTextField!
    @IBOutlet weak var joinLinkFld: DefaultTextField!
    @IBOutlet weak var cityFld: DefaultTextField!
    @IBOutlet weak var countryFld: DefaultTextField!
    @IBOutlet weak var aboutGrpFld: DefaultTextField!
    
    @IBOutlet weak var descriptionFld: DefaultTextField!
    
    @IBOutlet weak var scrollIndicatorView: SwiftlyScrollSlider!
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    let monthArray = ["January","February","March","April","May","June","July","August","September","October","November","December","Have not yet met as a group"]
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        descriptionLabel.text = " Now that you have a location, please complete this\nChapter Information Form. The information you provide\nwill appear on our 'Find ACL near me' map and help\npeople find and join you!"
        setupScrollIndicator()
        chapterAddressFeild.delegate = self
        chapterMeetingFeild.delegate = self
        groupStartedFld.delegate = self
        chapterTypeFeild.delegate = self
        firstMonthFld.delegate = self
        firstMeetingFld.delegate = self
    }
   
    override func viewWillAppear(_ animated: Bool) {
        if Singleton.sharedInstance.userLatLonginMY_ACL.count > 0{
            if let address = Singleton.sharedInstance.userLatLonginMY_ACL["address"]{
                self.chapterAddressFeild.text = address as? String ?? ""
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
         DispatchQueue.main.async {
             self.view.layoutIfNeeded()
             self.submitButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
         }
     }
    
    private func setupScrollIndicator(){
        self.scrollIndicatorView.lineBackgroundWidth = 0.1
        self.scrollIndicatorView.lineBackgroundView?.layer.borderColor = UIColor.white.cgColor
        self.scrollIndicatorView.lineBackgroundView?.backgroundColor = .white
        self.scrollIndicatorView.thumbImageView?.image = UIImage(named: "whiteScrollIndicator")
    }
    
    //create date picker
    func createDatePicker(title: String ,isGroupFld : Bool, isFirstMeeting : Bool){
        let picker = DatePickerDialog()
        self.additionalColeader.resignFirstResponder()
        
        if #available(iOS 13.4, *) {
            picker.datePicker.preferredDatePickerStyle = .wheels
        }
        if isFirstMeeting == false{
            if isGroupFld == true{
                picker.show(title, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", maximumDate: Date(), datePickerMode: .date) { date in
                         if let dt = date {
                             let formatter = DateFormatter()
                                formatter.dateFormat = "YYYY"
                                 Singleton.sharedInstance.userLatLonginMY_ACL["group_started"] = formatter.string(from: dt)
                                self.groupStartedFld.text = formatter.string(from: dt)
                         }
                     }
            }else{
                picker.show(title, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", minimumDate: Date(), datePickerMode: .date) { date in
                   if let dt = date {
                       let formatter = DateFormatter()
                          formatter.dateFormat = "dd MMM YYYY"
                           Singleton.sharedInstance.userLatLonginMY_ACL["enroll_date"] = formatter.string(from: dt)
                          self.chapterMeetingFeild.text = formatter.string(from: dt)
                   }
               }
            }
        }else{
            picker.show(title, doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
                if let dt = date {
                    let formatter = DateFormatter()
                       formatter.dateFormat = "dd MMM YYYY"
                        Singleton.sharedInstance.userLatLonginMY_ACL["meeting_info"] = formatter.string(from: dt)
                       self.firstMeetingFld.text = formatter.string(from: dt)
                }
            }
        }

        
     }
    
    func hideKeyboard(){
       _ = [chapterMeetingFeild, firstMeetingFld, chapterAddressFeild,additionalColeader,coLeaderFld,leaderNameFeild,chapterTypeFeild,chapterNameFeild,groupStartedFld,cityFld,countryFld,aboutGrpFld].map(){
            $0.resignFirstResponder()
        }

    }
    
    
    func showPickerView(){
        picker = UIPickerView.init()
           picker.delegate = self
           picker.dataSource = self
           picker.backgroundColor = UIColor.white
           picker.setValue(UIColor.black, forKey: "textColor")
           picker.autoresizingMask = .flexibleWidth
           picker.contentMode = .center
           picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
           self.view.addSubview(picker)
                   
           toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
           toolBar.barStyle = .blackTranslucent
           toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        
           self.view.addSubview(toolBar)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    
    
    
    func pushToFindAddressScreen(){
           if let findACLNearMeController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "FindACLNearMeController") as? FindACLNearMeController {
               Singleton.sharedInstance.isEnterfromMyACL = true
               self.navigationController?.pushViewController(findACLNearMeController, animated: true)
           }
       }
    //MARK:- Button Actions
    @IBAction func backToMainChapter(_ sender: UIButton) {
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
    
    @IBAction func chapterInfoAction(_ sender: Any) {
        if let recruiteMemdersViewController = self.storyboard?.instantiateViewController(withIdentifier: "RecruiteMemdersViewController") as? RecruiteMemdersViewController{
            self.navigationController?.pushViewController(recruiteMemdersViewController, animated: true)
        }
    }
    @IBAction func submitAction(_ sender: UIButton) {
        if chapterNameFeild.text!.isEmpty{
            self.showError("Please enter chapter name")
        }else if chapterAddressFeild.text!.isEmpty{
            self.showError("Please enter chapter address")
        }else if chapterMeetingFeild.text!.isEmpty{
            self.showError("Please enter meeting schedule")
        }else if cityFld.text!.isEmpty{
            self.showError("Please enter city name")
        }else if countryFld.text!.isEmpty{
            self.showError("Please enter country name")
        }else if leaderNameFeild.text!.isEmpty{
            self.showError("Please enter leader name")
        }else if coLeaderFld.text!.isEmpty{
            self.showError("Please enter co-leader name")
        }else if joinLinkFld.text!.isEmpty{
            self.showError("Please enter contact info")
        }else if chapterTypeFeild.text!.isEmpty{
            self.showError("Please enter type of your chapter")
        }else if descriptionFld.text!.isEmpty{
            self.showError("Please enter description")
        }
        else{
            Singleton.sharedInstance.userLatLonginMY_ACL["chapterName"] = self.chapterNameFeild.text!
            Singleton.sharedInstance.userLatLonginMY_ACL["leader"] = self.leaderNameFeild.text ?? ""
           // Singleton.sharedInstance.userLatLonginMY_ACL["leaderAbout"] = self.leaderBioFeild.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["coleader"] = self.coLeaderFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["join_link"] = self.joinLinkFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["city"] = self.cityFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["country"] = self.countryFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["additionalColeaders"] = self.additionalColeader.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["firstMeetingMonth"] = self.firstMonthFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["chapterType"] = self.chapterTypeFeild.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["firstMeetingDate"] = self.firstMeetingFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["about"] = self.aboutGrpFld.text ?? ""
            Singleton.sharedInstance.userLatLonginMY_ACL["description"] = self.descriptionFld.text ?? ""

            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ChapterInfoFormViewController : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == chapterMeetingFeild{
            self.joinLinkFld.resignFirstResponder()
            self.createDatePicker(title: "Set Schedule", isGroupFld: false, isFirstMeeting: false)
        }else if textField == chapterAddressFeild{
            textField.resignFirstResponder()
            self.pushToFindAddressScreen()
        }else if textField == groupStartedFld{
//            textField.resignFirstResponder()
            coLeaderFld.resignFirstResponder()
            additionalColeader.resignFirstResponder()
            self.createDatePicker(title: "Group Started in",isGroupFld: true, isFirstMeeting: false)
        }else if textField == chapterTypeFeild{
            textField.resignFirstResponder()
            getTypeOfChapter()
        }else if textField == firstMonthFld{
            textField.resignFirstResponder()
            showPickerView()
        }else if textField == firstMeetingFld{
//            textField.resignFirstResponder()
            self.createDatePicker(title: "First Meeting Date",isGroupFld: false, isFirstMeeting: true)

        }

    }
    
    
    
    func getTypeOfChapter(){
        let types = ["Public Regular at least 9x/yr","Public Irregular meets at least 4x/yr","Private Regular meets 9x/yr","Private Irregular meets at least 4x/yr","Specialized group-needs approval"]
        displayActionSheetWithTitle(title: "Type of Chapter", types) { (index, isCancel) in
            if isCancel == false{
                self.chapterTypeFeild.text = types[index]
            }
        }
    }
    
    
    
    
}

extension ChapterInfoFormViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
        
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthArray.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return monthArray[row]
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.firstMonthFld.text = monthArray[row]
        print(monthArray[row])
    }
}
