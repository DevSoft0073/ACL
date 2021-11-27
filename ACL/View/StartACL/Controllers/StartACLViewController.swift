//
//  StartACLViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 28/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import SafariServices
import WebKit
import DatePickerDialog

class StartACLViewController: BaseViewController, SFSafariViewControllerDelegate, WKNavigationDelegate {
   
    

    //MARK:- Outlets
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var chaptersTable: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    
    //MARK:- Variables

//    private var  chapters : [NSMutableDictionary] = [["title": "About ACL Chapters & Leaders","isSelected": false], ["title": "Register","isSelected": false], ["title": "Zoom session with Emily (Not in app)","isSelected": true], ["title": "Complete ACL Chapter Leader Agreement","isSelected": false], ["title": "Unlock Forms","isSelected": false], ["title": "Chapter info page compeleted","isSelected": false], ["title": "Join Leadership community","isSelected": false],["title": "Enter your assigned Cohort # here","isSelected": false],["title": "Complete Application here","isSelected": false],["title": "Test link and explore Chapter Leader Intranet site","isSelected": false],["title": "Attend 1 ACL zoom meeting","isSelected": false],["title": "Training week 1-8","isSelected": false],["title": "Test link and explore Chapter Leader Intranet site","isSelected": false],["title": "Complete Chapter Info Form","isSelected": false]]
    private var  chapters : [NSMutableDictionary] = [["title": "Attend 1 ACL meeting","isSelected": false,"isEnableForSelect": true],["title": "Read About ACL Chapters and Leaders","isSelected": false,"isEnableForSelect": false],["title": "Complete Application here","isSelected": false,"isEnableForSelect": false],["title": "Enter your assigned Cohort # here","isSelected": false,"isEnableForSelect": false],["title": "Training weeks 1-8 (Admin must verify completed. Once verified, see next step)","isSelected": false,"isEnableForSelect": false], ["title": "Complete ACL Chapter Leader Agreement; ACL Shared Agreement; ACL Photo Release; Chapter Info   (Admin must verify completed. Once verified, see next step)","isSelected": false,"isEnableForSelect": false],["title": "Successfully accept invite to and explore Chapter Leader Teams site","isSelected": false,"isEnableForSelect": false],["title": "Submit the date of your first meeting to ACLGP Admin  (Admin must verify completed. Once verified, see next step)","isSelected": false,"isEnableForSelect": false]]
    
    
    
    //Test link and explore Chapter Leader Intranet site  //https://forms.gle/3j8VUtkd1XeKLvZC8
    let googleFormLink = "https://forms.gle/CWf2H493vz976oPF6"
    var selectedIndexForWeb = 0
    let completeAppFormLink = "https://forms.gle/znPYkN8gzeQ7HZyq9"
    
    var congratsMSg = "Your chapter is now active & will appear on the map within 24 hours!"
    
    let leaderAboutAcl = "https://docs.google.com/document/d/1kikQuYIzwue3myFcSx6xngpzF9RehDp1X2tH3PLs7lI/edit?usp=sharing"
    let viewModal = StartACLViewModal()
    var meetingInfo = ""
    var cohotNumber = ""
    var lat = ""
    var long = ""
    var address = ""
    var chapterName = ""
    var enroll_date = ""
    var isAPicalled = false
    let learnText = ""
    var congratsView : CongratsView?
    
    var nextIndexForAvailable = 0

    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //‘\(Singleton.sharedInstance.totalChapters)’
        descriptionLabel.attributedText = NSAttributedString.init(string: " on choosing to bring ACL to your community!\n\nYou will be joining a growing movement of\npeople accross the globe who are coming\ntogether in their communities to deepen\nhuman connections. We currently are (live - right now \(Singleton.sharedInstance.totalChapters)) chapters located in\ncities all over the world. There are over 200 ACL chapter leaders and leaders in training!")
        descriptionLabel.setLineSpacing(lineSpacing: 1.1, lineHeightMultiple: 1.1)
        self.registerNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chaptersTable.reloadData()
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.chaptersTable.contentSize.height
        }
        //checkAllPointsDone()
        if Singleton.sharedInstance.userLatLonginMY_ACL.count > 0{
            if let weekSelected = Singleton.sharedInstance.userLatLonginMY_ACL["allWeekListSelected"] as? Bool{
                                   if weekSelected == true{
                                       selectedIndexForWeb = 4
                                       self.changeCheckBoxes()
                                   }
                               }
            if let lattitude = Singleton.sharedInstance.userLatLonginMY_ACL["lat"] as? String{
                if lattitude != ""{
                    self.lat = Singleton.sharedInstance.userLatLonginMY_ACL["lat"] as? String ?? ""
                    self.long = Singleton.sharedInstance.userLatLonginMY_ACL["lng"] as? String ?? ""
                    self.address = Singleton.sharedInstance.userLatLonginMY_ACL["address"] as? String ?? ""
                   // self.meetingInfo = Singleton.sharedInstance.userLatLonginMY_ACL["meetingInfo"] as? String ?? ""
                    self.chapterName = Singleton.sharedInstance.userLatLonginMY_ACL["chapterName"] as? String ?? ""
                    self.enroll_date = Singleton.sharedInstance.userLatLonginMY_ACL["enroll_date"] as? String ?? ""
                    selectedIndexForWeb = 7
                    self.changeCheckBoxes()
                   
                }
            }
        }
    }
    
    //MARK add nibs
    func registerNibs(){
        self.congratsView = Bundle.main.loadNibNamed("CongratsView", owner: self, options: nil)?.first as? CongratsView
        self.congratsView?.frame = self.view.frame
        self.congratsView?.isHidden = false
        self.congratsView?.hideWithAnimation(hidden: true)
        self.congratsView?.buttonAction = {
            self.congratsView?.hideWithAnimation(hidden: true)
            self.navigationController?.popViewController(animated: true)
           
        }
        self.view.addSubview(self.congratsView!)
    }
    
    
    func checkAllPointsDone(){
        var count = 0
        for data in chapters{
            let isSelectedValue = data.value(forKey: "isSelected") as? Bool
            if isSelectedValue == true{
                count += 1
            }
        }
        if isAPicalled == false{
            if count == chapters.count{
                isAPicalled = true
                SwiftLoader.show(animated: true)

                viewModal.createChapter(meeting_info: meetingInfo, cohot_no: cohotNumber, lat: lat, lng: long, address: address,chaptername: chapterName,enroll_date: enroll_date) { (isSuccess, str) in
                    SwiftLoader.hide()
                    if isSuccess == true{
                        self.congratsView?.hideWithAnimation(hidden: false)
//                        self.congratsView?.isHidden = false
//                        self.showCongratspopUp(title: "Congratulations", message: self.congratsMSg, completion: { (action) in
//                            self.navigationController?.popViewController(animated: true)
//                        })
                        
                    }else{
                        self.showError(str)
                    }
                }
            }
        }
    }
    
  //  create date picker
    func createDatePicker(){
        let picker = DatePickerDialog()
        if #available(iOS 13.4, *) {
            picker.datePicker.preferredDatePickerStyle = .wheels
        }
        picker.show("Date of Meeting", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) { date in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMM YYYY"
                Singleton.sharedInstance.userLatLonginMY_ACL["enroll_date"] = formatter.string(from: dt)
                self.changeCheckBoxes()
            }else{
                self.showError("You need to enter information")
            }
        }

    }
    
    
    
//    func pushToFindAddressScreen(){
//        if let findACLNearMeController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "FindACLNearMeController") as? FindACLNearMeController {
//            Singleton.sharedInstance.isEnterfromMyACL = true
//            self.navigationController?.pushViewController(findACLNearMeController, animated: true)
//        }
//    }

    //MARK:- Button Actions
    @IBAction private func liveMapAction(_ sender: UIButton) {
   
       
       if let findACLNearMeController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "FindACLNearMeController") as? FindACLNearMeController {
            self.navigationController?.pushViewController(findACLNearMeController, animated: true)
        }
    }
    
    @IBAction func learnAbout(_ sender: UIButton) {
//        let alert = UIAlertController(title: "ACL", message: "About this feature", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
          //  weeklyChallenegDescriptionController.challenge = viewmodel.challenge
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }

    }
    @IBAction private func backToMyACLAction(_ sender: UIButton) {
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
    
    @IBAction func congratulationAction(_ sender: Any) {
//        if let startACLCongratulationViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartACLCongratulationViewController") as? StartACLCongratulationViewController{
//            self.navigationController?.pushViewController(startACLCongratulationViewController, animated: true)
//        }
    }
    
    @IBAction private func clickHereAction(_ sender: UIButton) {
        if let startACLCongratulationViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartACLCongratulationViewController") as? StartACLCongratulationViewController{
            self.navigationController?.pushViewController(startACLCongratulationViewController, animated: true)
        }

    }
}

extension StartACLViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 5{
            return 60
        }else{
            return 40
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCheckTableViewCell") as? ChapterCheckTableViewCell {
            cell.chapterLabel.text = chapters[indexPath.row]["title"] as? String ?? ""
            if indexPath.row == 4 {
                let txt = chapters[indexPath.row]["title"] as? String
                let rngText = txt?.index(of: "(")
                let subRng = txt?.prefix(upTo: rngText!)
                cell.chapterLabel.underlineWithoutBrackets(RangeText: subRng?.description ?? "")
            } else if indexPath.row == 5 || indexPath.row == 7{
                
            }else{
                cell.chapterLabel.underline()
            }
            
            if chapters[indexPath.row]["isEnableForSelect"] as! Bool == true{
                cell.contentView.alpha = 1
                cell.isUserInteractionEnabled = true
            }else{
                cell.contentView.alpha = 0.6
                cell.isUserInteractionEnabled = false
            }
            cell.isSelected = chapters[indexPath.row]["isSelected"] as? Bool ?? true
            return cell
        }
        return UITableViewCell()
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            selectedIndexForWeb = 0
            self.showPopUpWithTextField(title: "Information", msg: "Enter leader name", placeholder: "Leader name") { (leaderName) in
                if leaderName != ""{
                    let arr = ["Yes","No"]
                    let indexVal = ["1","0"]
                    displayActionSheetWithTitle(title: "Was it via the App?", arr) { (index, isCancel) in
                        if isCancel{
                            self.showError("You need to enter information")

                        }else{
                            Singleton.sharedInstance.userLatLonginMY_ACL["via_app"] = indexVal[index]
                            self.createDatePicker()
                        }
                    }
                    //save leader name in singleton
                  //  Singleton.sharedInstance.userLatLonginMY_ACL["leader"] = leaderName
//                            self.createDatePicker()
                }else{
                    self.showError("You need to enter information")
                }
            }

            
            
           
        case 1:
//            selectedIndexForWeb = 1
//                       changeCheckBoxes()
//                       if let aboutChapterViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutChapterViewController") as? AboutChapterViewController{
//                           self.navigationController?.pushViewController(aboutChapterViewController, animated: true)
//                       }
            selectedIndexForWeb = 1
            openwebLink(controller: self, link: leaderAboutAcl)

//            if let chapterRegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "ACLChapterRegisterViewController") as? ACLChapterRegisterViewController{
//                self.navigationController?.pushViewController(chapterRegisterViewController, animated: true)
 //       }
           

        case 2:
            selectedIndexForWeb = 2
            openwebLink(controller: self, link: "https://forms.gle/3j8VUtkd1XeKLvZC8")

            
//            if let chapterInfoFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChapterInfoFormViewController") as? ChapterInfoFormViewController{
//                           self.navigationController?.pushViewController(chapterInfoFormViewController, animated: true)
//                       }
            
            

            
        case 3:
//                        selectedIndexForWeb = 3
//                        openwebLink(controller: self, link: "https://forms.gle/e2Wqu9vuDWMi2aqS9")
            selectedIndexForWeb = 3
                       self.showPopUpWithTextField(title: "Information", msg: "Enter your assigned Cohort # here", placeholder: "") { (str) in
                           if str != ""{
                               self.cohotNumber = str
                               self.changeCheckBoxes()
                           }else{
                               self.showError("You need to enter information")
                           }
                       }

            case 4:
            
//            selectedIndexForWeb = 4
            if let videoUploadViewController = self.storyboard?.instantiateViewController(withIdentifier: "WeekTrainingViewController") as? WeekTrainingViewController{
                                             self.navigationController?.pushViewController(videoUploadViewController, animated: true)
                                         }
//                openwebLink(controller: self, link: googleFormLink)

            
        case 5:
            if let weekSelected = Singleton.sharedInstance.userLatLonginMY_ACL["allWeekListSelected"] as? Bool{
                if weekSelected == true{
                    selectedIndexForWeb = 5
                    openwebLink(controller: self, link: "https://forms.gle/e2Wqu9vuDWMi2aqS9")
                }else{
                    self.showError("Please complete training week 1-8")
                }
            }else{
                self.showError("Please complete training week 1-8")
            }
            
            
        case 6:
            selectedIndexForWeb = 6
                               openwebLink(controller: self, link: googleFormLink)
//            if let videoUploadViewController = self.storyboard?.instantiateViewController(withIdentifier: "WeekTrainingViewController") as? WeekTrainingViewController{
//                                  self.navigationController?.pushViewController(videoUploadViewController, animated: true)
//                              }
//            selectedIndexForWeb = 6
//            changeCheckBoxes()
//            if let joinLeaderShipViewController = self.storyboard?.instantiateViewController(withIdentifier: "JoinLeaderShipViewController") as? JoinLeaderShipViewController{
//                self.navigationController?.pushViewController(joinLeaderShipViewController, animated: true)
//            }

         case 7:
            if let chapterInfoFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChapterInfoFormViewController") as? ChapterInfoFormViewController{
                self.navigationController?.pushViewController(chapterInfoFormViewController, animated: true)
            }
//            selectedIndexForWeb = 7
//                    openwebLink(controller: self, link: googleFormLink)
//            selectedIndexForWeb = 7
//            self.showPopUpWithTextField(title: "Information", msg: "Enter your assigned Cohort # here", placeholder: "") { (str) in
//                if str != ""{
//                    self.cohotNumber = str
//                    self.changeCheckBoxes()
//                }else{
//                    self.showError("You need to enter information")
//                }
//            }

        case 8:
            if let chapterInfoFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChapterInfoFormViewController") as? ChapterInfoFormViewController{
                             self.navigationController?.pushViewController(chapterInfoFormViewController, animated: true)
                         }
//            selectedIndexForWeb = 8
//            openwebLink(controller: self, link: googleFormLink)
//            selectedIndexForWeb = 8
//            openwebLink(controller: self, link: googleFormLink)

        case 9:

            selectedIndexForWeb = 9
            openwebLink(controller: self, link: googleFormLink)
//        case 10:
            
//                                              selectedIndexForWeb = 10
//                            self.showPopUpWithTextField(title: "Information", msg: "Enter meeting information", placeholder: "") { (str) in
//                                if str != ""{
//                                    self.meetingInfo = str
//            //                        Singleton.sharedInstance.userLatLonginMY_ACL["meetingInfo"] = str
//                                    self.changeCheckBoxes()
//            //                        self.createDatePicker()
//                                   //
//                                }else{
//                                    self.showError("You need to enter information")
//                                }
//                            }

//        case 11:
//
//                        if let videoUploadViewController = self.storyboard?.instantiateViewController(withIdentifier: "WeekTrainingViewController") as? WeekTrainingViewController{
//                            self.navigationController?.pushViewController(videoUploadViewController, animated: true)
//                        }
       
           case 12:
            selectedIndexForWeb = 12
            openwebLink(controller: self, link: googleFormLink)
           
            case 13:
                       selectedIndexForWeb = 13
                       openwebLink(controller: self, link: googleFormLink)
                       
        default:
            break
        }
       // checkAllPointsDone()
        
    }
    
    
    //Safari Deligate method
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
       // print("Done")
      changeCheckBoxes()
    }
    
    func changeCheckBoxes(){
                  var index = 0
                var newIndex = 0
                  for data in chapters{
                      if selectedIndexForWeb == index{
                          data["isSelected"] = true
                      }
                    
                      index += 1
                  }
        
        for data in chapters{
            if selectedIndexForWeb + 1 == newIndex{
                data["isEnableForSelect"] = true
            }
          
            newIndex += 1
        }

        chaptersTable.reloadData()
              
        checkAllPointsDone()
    }
    
//    func openWebView(){
//
//        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        self.view.addSubview(webView)
//        let url = URL(string: googleFormLink)
//        webView.load(URLRequest(url: url!))
//    }
    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        <#code#>
//    }
   
    
}
extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = .center
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // (Swift 4.2 and above) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))


        // (Swift 4.1 and 4.0) Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
  
