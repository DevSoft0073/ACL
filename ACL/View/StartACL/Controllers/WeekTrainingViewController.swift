//
//  WeekTrainingViewController.swift
//  ACL
//
//  Created by Aman on 13/11/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class WeekTrainingViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource {

    //MARK: outlets
    
    @IBOutlet weak var weekTableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    
    private var  weeksList : [NSMutableDictionary] = [["title": "Week 1 - Modules 1-3 plus Experiential I","isSelected": false,"isEnableForSelect": true], ["title": "Week 2 - Modules 4-5","isSelected": false,"isEnableForSelect": false], ["title": "Week 3 - Modules 6-7","isSelected": false,"isEnableForSelect": false], ["title": "Week 4 - Modules 8-10 Plus Experiential II","isSelected": false,"isEnableForSelect": false], ["title": "Week 5 - Modules 11-13","isSelected": false,"isEnableForSelect": false], ["title": "Week 6 - Modules 14 -16","isSelected": false,"isEnableForSelect": false], ["title": "Week 7 - Modules 17 Experiential III","isSelected": false,"isEnableForSelect": false],["title": "Week 8 - Graduation & Forms Ghost","isSelected": false,"isEnableForSelect": false]]
    
//    Week 1 - Modules 1-3 plus Experiential I Week 2 - Modules 4-5 Week 3 - Modules 6-7 Week 4 - Modules 8-10 Plus Experiential II Week 5 - Modules 11-13 Week 6 - Modules 14 -16 Week 7 - Modules 17 Experiential III Week 8 - Graduation & Forms Ghost week 1 - Ghost week 2 -
//
    var selectedIndexForWeek = 0

    var nextIndexForAvailable = 0
    let viewModel = StartACLViewModal()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftLoader.show(animated: true)
        viewModel.getWeekListApproval { (isSucess, str) in
            SwiftLoader.hide()
            DispatchQueue.main.async {
                self.weekTableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.doneBtn.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        }
    }

    
    func checkAllpointsDone(isFromDone: Bool){
        SwiftLoader.show(animated: true)
        var count = 0
        for data in weeksList{
            let isSelectedValue = data.value(forKey: "isSelected") as? Bool
            if isSelectedValue == true{
                count += 1
            }
        }
        if count == weeksList.count{
            print("All week selected")
            Singleton.sharedInstance.userLatLonginMY_ACL["allWeekListSelected"] = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                SwiftLoader.hide()
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            SwiftLoader.hide()
            if isFromDone == true{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
//MARK: button actions
    
    @IBAction func doneAction(_ sender: UIButton) {
        checkAllpointsDone(isFromDone: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    func changeCheckBoxes(){
                  var index = 0
                  for data in weeksList{
                      if selectedIndexForWeek == index{
                          data["isSelected"] = true
                      }
                      index += 1
                  }
            DispatchQueue.main.async {
                self.weekTableView.reloadData()
            }
        checkAllpointsDone(isFromDone: false)
    }
    
    func nextWeekAvailable(){
        var currentIndex = 0
        for data in weeksList{
            if nextIndexForAvailable == currentIndex{
                data["isEnableForSelect"] = true
            }
            currentIndex += 1
        }
        DispatchQueue.main.async {
            self.weekTableView.reloadData()
        }
    }
    
    // table view delegate and data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeksList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterCheckTableViewCell") as? ChapterCheckTableViewCell {
            cell.chapterLabel.text = weeksList[indexPath.row]["title"] as? String ?? ""
            cell.isSelected = weeksList[indexPath.row]["isSelected"] as? Bool ?? true
            let data = viewModel.weekTraining?.weekDictionary
            let isApprove = checkWeekIsApprovedOrNot(index: indexPath.row, dict: data ?? [:])
            if isApprove == false{
                cell.chapterLabel.textColor = UIColor.white.withAlphaComponent(0.4)
                weeksList[indexPath.row]["isEnableForSelect"] = false
                
            }else{
                weeksList[indexPath.row]["isEnableForSelect"] = true
                cell.chapterLabel.textColor = UIColor.white.withAlphaComponent(1)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if weeksList[indexPath.row]["isEnableForSelect"] as? Bool == true{
            selectedIndexForWeek = indexPath.row
            changeCheckBoxes()
//            nextIndexForAvailable = indexPath.row + 1
//            nextWeekAvailable()
        }else{
            showError("You are not eligible to check this week, please contact with admin.")
        }
        
    }
    
    func checkWeekIsApprovedOrNot(index : Int, dict : [String: Any]) -> Bool{
        
        let key = "week\(index + 1)"
        var indexKey = 0
        var isApproved = false
        for title in dict.keys{
            if title == key{
                let val = dict["\(key)"] as? String ?? ""
                if val == "1"{
                    isApproved = true
                }
            }
            indexKey += 1
        }
        
        return isApproved
    }
    
    
    
}

