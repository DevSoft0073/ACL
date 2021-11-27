//
//  AnswerQuestionOfWeekController.swift
//  ACL
//
//  Created by Gagandeep on 10/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import SDWebImage

protocol AnswerQuestionOfWeekControllerDelegate: class {
    func answerAddedSuccessfully()
}

class AnswerQuestionOfWeekController: BaseViewController {

    @IBOutlet weak var postButton: DefaultDoneButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var anonymouslyButton: UIButton!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var signupSectionView: UIView!
    
    @IBOutlet weak var signupSectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var flowerCollectionView: UICollectionView!
    
    let defaultText = "Type here up to 250 characters"
    let maxTextLength = 250
    var viewModel = QuestionOfWeekViewModel()
    
    weak var delegate: AnswerQuestionOfWeekControllerDelegate?
    var question = ""
    var selectedFlowerId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup Ui
        setupUI()
        flowerCollectionView.delegate = self
        flowerCollectionView.dataSource = self
        self.flowerCollectionView.reloadData()
        SwiftLoader.show(animated: true)
        viewModel.getFlowerListing { (isSuccess, msg) in
            SwiftLoader.hide()
            if isSuccess{
                DispatchQueue.main.async {
                        self.flowerCollectionView.reloadData()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide signup section if user is acl user
        if DataManager.shared.isACLAccount {
            signupSectionView.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.flowerCollectionView.flashScrollIndicators()
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.flowerCollectionView.flashScrollIndicators()
        }
    }
    func setupUI() {
       
        // update height
        if UIDevice().isRegularModel() {
            textViewHeightConstaint.constant = 145
        } else if UIDevice().isPlusModel() {
            textViewHeightConstaint.constant = 180
        }
        
        questionLabel.text = question
        // disable button
        postButton.disable()
    }
    
    override func viewDidLayoutSubviews() {
        // setup colors
        signupButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        postButton.applyGradient(colours: [AppTheme.megenta, AppTheme.darkPurple])
        bottomView.applyGradient(colours: [AppTheme.darkPurple, AppTheme.megenta])
    }

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func signupAction(_ sender: Any) {
        showUpdateProfileScreen(true)
    }
    
    @IBAction func postAction(_ sender: Any) {
        // update answer
        viewModel.userAnswer = textView.text
        viewModel.flowerId = selectedFlowerId
        if anonymouslyButton.isSelected{
           viewModel.anony = "1"
        }else{
            viewModel.anony = "0"
        }
        
        // save answer on cloud
        SwiftLoader.show(animated: true)
        viewModel.answerQuestion { status, message in
            // check status if true
            SwiftLoader.hide()
            if status {
                // update answer delegate
                self.delegate?.answerAddedSuccessfully()
                // show success message
                self.showError("Answer posted successfully", completion: { action in
                    self.navigationController?.popViewController(animated: true)
                })
                // remove text entered
                self.textView.text = self.defaultText
                // disable post button
                self.postButton.disable()
            } else {
                // show message
                self.showError(message)
            }
        }
    }
    
    @IBAction func AnonymousAction(_ sender: Any) {
        anonymouslyButton.isSelected = !anonymouslyButton.isSelected
        
    }

}

extension AnswerQuestionOfWeekController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // set default text if no text added by user
        if textView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count == 0 {
            // set text
            textView.text = defaultText
            // diable post button
            postButton.disable()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // remove default text
        if textView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == defaultText {
            textView.text = ""
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        // get text string length
      //  let textLength = textView.text.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines).count
        // get currentLength of string
      //  let currentLength = textLength + (textLength - range.length)
        // check currentLength
        
        if text.contains(UIPasteboard.general.string ?? "") {
            if textView == self.textView{
             if text.count > maxTextLength{
                 return false
             }
         }
         }
        
        
        let currentLength = (self.textView.text as NSString).replacingCharacters(in: range, with: text).count

        
        if currentLength > 0 {
            if checkAtleastOneSelected() == true{
             postButton.enable()
            }
           // postButton.enable()
        } else {
            postButton.disable()
        }
        // Compare current with max length
        return currentLength <= maxTextLength
    }
    
}

extension AnswerQuestionOfWeekController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.flowerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlowerCell", for: indexPath) as? FlowerCell
//        cell?.contentView.backgroundColor = .blue
        let img = viewModel.flowerList[indexPath.row].image ?? ""
        DispatchQueue.main.async {
            cell?.flowerImgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
//            imgView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell?.flowerImgView.sd_setImage(with: URL(string: img), completed: nil)

        }
        
        if viewModel.flowerList[indexPath.row].isSelected == false{
            cell?.tickImageview.image = UIImage(named: "question_screen_checkmark")
        }else{
            cell?.tickImageview.image = UIImage(named: "question_screen_checkmark_selected")

        }
        
        return cell!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let data = viewModel.flowerList[indexPath.row]
        self.setupDataImages(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80 , height: 80)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    func setupDataImages(index : Int){
        let selectedData = viewModel.flowerList[index]
        for data in viewModel.flowerList{
            if data.id == selectedData.id{
                postButton.enable()
                data.isSelected = true
                self.selectedFlowerId = data.id ?? ""
            }else{
                data.isSelected = false
            }
        }
        DispatchQueue.main.async {
//            self.flowerCollectionView.reloadData()
            self.flowerCollectionView.performBatchUpdates {
                self.flowerCollectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            } completion: { (_) in
                //
            }

        }
    }
    
    func checkAtleastOneSelected() -> Bool{
        var isOneSelected = false
        for data in viewModel.flowerList{
            if data.isSelected == true{
                isOneSelected = true
            }
        }
        return isOneSelected
    }
    
    
}


class FlowerCell : UICollectionViewCell{
    
    @IBOutlet weak var tickImageview: UIImageView!
    @IBOutlet weak var flowerImgView: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
