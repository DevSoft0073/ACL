//
//  ACLExercisesViewController.swift
//  ACL
//
//  Created by Gagandeep on 18/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

enum ACLExercisesType: Int {
    case awareness = 1
    case courage
    case love
}

class ACLExercisesViewController: BaseViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var noticeLbl: UILabel!
    
    @IBOutlet weak var favLbl: UILabel!
    let viewModel = ACLExercisesViewModel()
    var viewtype: ACLExercisesType = ACLExercisesType.awareness
    var isDetailSelected: Bool = false
    var selectedText = ""
    var exerciseId = ""
    var isFav = false
    var isFromCross = false
    var isFromFavSection = false
    let learnText = "These exercises are designed to help in the exploration and discovery of your truest self.  "
    var titleTExt = ""
    
    let noticeText = "click exercise to see Full Text popup"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.register(UINib(nibName: "ACLExercisesTableCell", bundle: nil), forCellReuseIdentifier: "ACLExercisesTableCell")
        
        tableview.register(UINib(nibName: "ACLExercisePopupTableCell", bundle: nil), forCellReuseIdentifier: "ACLExercisePopupTableCell")
        var img = ""
        if viewtype.rawValue == 1{
            img = "awareness"
        }else if viewtype.rawValue == 2{
            img = "Courage"
        }else if viewtype.rawValue == 3{
            img = "LoveExercise"
        }
        
        titleImageView.image = UIImage(named: img)
        if !self.isFromFavSection{
            getData()
           
        }else{
            self.noticeLbl.text = ""
            self.titleLabel.text = self.titleTExt
            self.tableview.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.isFromFavSection{
           // getData()
        }else{
            DispatchQueue.main.async {
                self.tableview.reloadData()

            }
        }
        if viewtype.rawValue == 1{
            self.addAnalytics(screenName: "AWARENESS_EXERCISE", screenClass: "ACLExercisesViewController")
        }else if viewtype.rawValue == 2{
            self.addAnalytics(screenName: "COURAGE_EXERCISE", screenClass: "ACLExercisesViewController")
        }else if viewtype.rawValue == 3{
            self.addAnalytics(screenName: "LOVE_EXERCISE", screenClass: "ACLExercisesViewController")

        }
        

    }
    
    func getData(){
        SwiftLoader.show(animated: true)
        
        viewModel.getExcercises(type: viewtype) { status, message in
//            SwiftLoader.hide()
            guard status else {
                self.showError(message)
                return
            }
                self.updateView()
            
        }
    }
    
    // Update view
    func updateView() {
        self.titleLabel.text = self.viewModel.exercise?.name
        self.noticeLbl.text = noticeText
        if let imageName = viewModel.exercise?.image {
            var img = ""
            if viewtype.rawValue == 1{
                img = "awareness"
            }else if viewtype.rawValue == 2{
                img = "Courage"
            }else if viewtype.rawValue == 3{
                img = "LoveExercise"
            }
            
            titleImageView.sd_setImage(with: URL(string: imageName), placeholderImage: UIImage(named: img))
        }
            self.tableview.reloadData()
        
        if self.isFromCross == true{
            self.tableview.isHidden = false

        }else{
            self.isDetailSelected = true
            self.tableview.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isDetailSelected = false
            self.tableview.isHidden = false
            self.tableview.reloadData()
            SwiftLoader.hide()
        }
    }
    
    @IBAction func favButtonClick(_ sender: UIButton) {
        SwiftLoader.show(animated: true)
        viewModel.addFavourite(id: exerciseId) { (isSuccess, str) in
            SwiftLoader.hide()
            if self.favButton.imageView?.image == UIImage(named: "main_screen_star"){
                self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
                }else{
                self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
            }
        }
    }
    @IBAction func learnAbtBtn(_ sender: UIButton) {
//        let alert = UIAlertController(title: "Exercise", message: "About this feature", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ACLExercisesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDetailSelected {
            return 1
        }
        
        return viewModel.exercise?.exercises.count ?? 0
    }
    
    
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isDetailSelected {
            
            if let cell = tableview.dequeueReusableCell(withIdentifier: "ACLExercisePopupTableCell") as? ACLExercisePopupTableCell {
                // get exercise for row
                cell.delegate = self
                
                cell.applyGradiants()
                cell.textView.text = selectedText
                self.favButton.isHidden = false
                self.favLbl.isHidden = false
                self.favouriteBtn.isHidden = false
                if self.isFav == true{
                self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
                }else{
                self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
                }
                cell.layoutIfNeeded()
                return cell
            }
            return ACLExercisePopupTableCell()
        }
        
        if let cell = tableview.dequeueReusableCell(withIdentifier: "ACLExercisesTableCell") as? ACLExercisesTableCell {
            // setup delegate

            cell.checkButton.tag = indexPath.row
            cell.checkButton.addTarget(self, action: #selector(checkButtonclick(sender:)), for: .touchUpInside)
            cell.delegate = self
            // get exercise for row
            self.favButton.isHidden = true
            self.favouriteBtn.isHidden = true
            self.favLbl.isHidden = true
            //isChecked
            if let exercise = viewModel.exercise?.exercises[indexPath.row] {
                cell.setup(exercise)
            }
            return cell
        }
        return ACLExercisesTableCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    @objc func checkButtonclick(sender: UIButton){
        let data = viewModel.exercise?.exercises[sender.tag]
        SwiftLoader.show(animated: true)
        viewModel.markCheck(item_id: data?.id ?? "") { (isSuccess, str) in
            SwiftLoader.hide()
            self.getData()
        }
        
    }
}

extension ACLExercisesViewController: ACLExercisesTableCellDelegate, ACLExercisePopupTableCellDelegate {
   
    func titleDidTap(selectedText: String,selectedTitleId : String,isFav : String) {
        self.isDetailSelected = true
        self.selectedText = selectedText
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
        self.exerciseId = selectedTitleId
        if isFav == "0"{
            self.isFav = false
        }else{
            self.isFav = true
        }
    }
    
    func crossDidTap() {
        self.isFromCross = true
        getData()
        self.isDetailSelected = false
        noticeLbl.text = noticeText
        self.tableview.reloadData()
    }
}
