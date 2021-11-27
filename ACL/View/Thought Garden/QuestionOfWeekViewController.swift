//
//  QuestionOfWeekViewController.swift
//  ACL
//
//  Created by Gagandeep on 10/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class QuestionOfWeekViewController: BaseViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var bottomViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var answerButtonView: UIView!
    @IBOutlet weak var favButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    let viewModel = QuestionOfWeekViewModel()
    private var shouldScrollToBottom : Bool = false
    
    var isFromFavSection = false
    var dataFromFavSection = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup ui
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // update UI
        if DataManager.shared.isACLAccount {
            signupView.isHidden = true
            bottomViewHeightContraint.constant = 150
        }
        
        // get data
        if isFromFavSection == true{
            SwiftLoader.show(animated: true)
            viewModel.questionOfWeek = QuestionOfWeek(dataFromFavSection)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.updateView()
                SwiftLoader.hide()
            }
        }else{
          loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.flashScrollIndicators()
        self.addAnalytics(screenName: "THOUGHT_GARDEN", screenClass: "QuestionOfWeekViewController")
    }
    
    
    
    
    func loadData() {
        // show loader
        SwiftLoader.show(animated: true)
        // get question of week
        viewModel.getQuestion { status, message in
            // hide loader
            SwiftLoader.hide()
            // update ui
            self.updateView()
        }
    }
    
    func setupView() {
        tableView.register(UINib(nibName: "QuestionOfWeekTableCell", bundle: nil), forCellReuseIdentifier: "QuestionOfWeekTableCell")
        signupButton.addUnderLine()
        
        self.noDataFoundLabel.isHidden = true
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .white
        tableView.flashScrollIndicators()
    }
    
    func updateView() {
        guard let title = viewModel.questionOfWeek?.title else {
            showError("Questions are not available to answers.")
            self.favButton.isHidden = true
            self.noDataFoundLabel.isHidden = false
            self.tableView.isHidden = true
            self.answerButtonView.isHidden = true
            return
        }
        self.favButton.isHidden = false
        self.noDataFoundLabel.isHidden = true
        self.answerButtonView.isHidden = false
        self.questionLabel.text = title
        self.tableView.reloadData()
        if viewModel.questionOfWeek?.isFavorite == "0"{
            self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
        }else{
            self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
        }
        
        if shouldScrollToBottom {
            self.scrollTableToBottom()
            self.shouldScrollToBottom = false
        }
    }
    
    
    private func scrollTableToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.viewModel.numberOfRows() - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @IBAction func signupAction(_ sender: Any) {
        showUpdateProfileScreen(true)
    }
    
    @IBAction func backAction(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController?.popViewControllers(viewsToPop: 2,animated: true)
        self.gotoMainViewController()
    }
    @IBAction func favButtonclick(_ sender: UIButton) {
        SwiftLoader.show(animated: true)
        viewModel.addFavourite(id: viewModel.questionOfWeek?.id ?? "") { (isSuccess, Str) in
            SwiftLoader.hide()
            if self.favButton.imageView?.image == UIImage(named: "main_screen_star"){
                         self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
                         }else{
                         self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
                     }
        }
        
    }
    
    @IBAction func answerAction(_ sender: Any) {
        guard DataManager.shared.isACLAccount else {
            return
        }
        // mode to answer screen
        if let answerQuestionOfWeekController = UIStoryboard(name: "ThoughtGarden", bundle: nil).instantiateViewController(withIdentifier: "AnswerQuestionOfWeekController") as? AnswerQuestionOfWeekController {
            answerQuestionOfWeekController.viewModel = self.viewModel
            answerQuestionOfWeekController.delegate = self
            answerQuestionOfWeekController.question = self.questionLabel.text ?? ""
            self.navigationController?.pushViewController(answerQuestionOfWeekController, animated: true)
        }
    }
}

extension QuestionOfWeekViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionOfWeekTableCell") as? QuestionOfWeekTableCell {
            // get list of answers for current label
            if let answers = viewModel.answersForCell(at: indexPath.row) {
                cell.setup(index: indexPath.row, answers: answers)
            }

            return cell
        }
        return QuestionOfWeekTableCell()
    }

    
}

extension QuestionOfWeekViewController :AnswerQuestionOfWeekControllerDelegate {
    func answerAddedSuccessfully() {
        shouldScrollToBottom = true
        loadData()
    }
}


class QuestionOfWeekViewModel: NSObject {
    
    var questionOfWeek: QuestionOfWeek?
    var userAnswer: String?
    var flowerList: [FlowerListing] = [FlowerListing]()
    var anony = ""
    var flowerId = ""
    
    func numberOfRows() -> Int {
        guard let list = questionOfWeek?.answerList else {
            return 0
        }
        // 1 cell contains 3 items
        // get max number of cells required
        return Int(ceil(Double(list.count)/3))
    }
    
    func answersForCell(at indexPathrow: Int) -> [AnswerOfQuestion]? {
        guard let list = questionOfWeek?.answerList else {
            return nil
        }
        // used cells
        let old = (indexPathrow * 3)
        // pending cells
        let pending = list.count - old
        if pending == 1 {
            return [list[old]]
        } else if pending == 2 {
            return [list[old], list[old + 1]]
        }else {
            return [list[old], list[old + 1], list[old + 2]]
        }
    }
    
    
    func getQuestion(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = ["uid": DataManager.shared.userId!]
        CloudDataManager.shared.getWeeklyQuestion(parameters) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [String: Any] {
                // create user model
                self.questionOfWeek = QuestionOfWeek(data)
            }
            completion(true, "")
        }
    }
    
    func reportPost(postId : String,_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = ["uid": DataManager.shared.userId!,"post_id":postId,"question_id":questionOfWeek?.id ?? ""]
        CloudDataManager.shared.reportPOst(parameters) { response, error in
           
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            completion(true, "")
        }
    }
    
    func answerQuestion(_ completion: @escaping(cloudDataCompletionHandler)) {
        let parameters = ["uid": DataManager.shared.userId!, "question_id": questionOfWeek?.id ?? "", "answer": userAnswer ?? "", "flower": flowerId ,"anonymous": anony]
        CloudDataManager.shared.postAnswerForWeeklyQuestion(parameters, completion: completion)
    }
    
    func getFlowerListing(_ completion: @escaping(cloudDataCompletionHandler)) {
        CloudDataManager.shared.getFlowerListing([:]) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }
            
            if let data = response?[APIConstants.Response.data] as? [[String: Any]] {
                // create user model
                self.flowerList.removeAll()
                for response in data{
                    self.flowerList.append(FlowerListing(response))
                }
                completion(true, "")
            }
            completion(false, "")
        }
    }
    

    func addFavourite(id : String ,completion: @escaping cloudDataCompletionHandler){
        let param = ["uid": DataManager.shared.userId!, "type" : APIConstants.favType.question_ofthe_week, "item_id": id]

        CloudDataManager.shared.addFavorite(param) { response, error in
            // vaidate response
            let validation = CloudDataManager.shared.validateResponse(response, error: error)
            guard validation.isValid else {
                completion(false, validation.errorMessage)
                return
            }

            completion(true, validation.errorMessage)
        }
    }
    
    
    
    
    
    
}

