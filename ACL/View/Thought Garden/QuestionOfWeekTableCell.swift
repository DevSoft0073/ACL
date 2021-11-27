//
//  QuestionOfWeekTableCell.swift
//  ACL
//
//  Created by Gagandeep on 14/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class QuestionOfWeekTableCell: UITableViewCell {

    @IBOutlet weak var backImage1: UIImageView!
    @IBOutlet weak var backImage2: UIImageView!
    @IBOutlet weak var backImage3: UIImageView!
    @IBOutlet weak var textView1: UITextView!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var textView3: UITextView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var reportBtn3: UIButton!
    @IBOutlet weak var reportBtn2: UIButton!
    @IBOutlet weak var reportBtn1: UIButton!
    @IBOutlet weak var view1LeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var view2TrailingConstant: NSLayoutConstraint!
    @IBOutlet weak var view3LeadingConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        refresh()
        backImage1.alpha = 0.6
        backImage2.alpha = 0.6
        backImage3.alpha = 0.6
        self.textView1.indicatorStyle = .white
        self.textView2.indicatorStyle = .white
        self.textView3.indicatorStyle = .white
        self.textView1.showsVerticalScrollIndicator = true
        self.textView2.showsVerticalScrollIndicator = true
        self.textView3.showsVerticalScrollIndicator = true
        self.textView1.flashScrollIndicators()
        self.textView2.flashScrollIndicators()
        self.textView3.flashScrollIndicators()

        self.addShadow(textView: textView1)
        self.addShadow(textView: textView2)
        self.addShadow(textView: textView3)
        
        self.addShadowForBtn(textView: reportBtn1)
        self.addShadowForBtn(textView: reportBtn2)
        self.addShadowForBtn(textView: reportBtn3)
        
        self.reportBtn1.isHidden = true
        self.reportBtn2.isHidden = true
        self.reportBtn3.isHidden = true

        
    }
    
    func addShadow(textView : UITextView){
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        textView.layer.shadowOpacity = 1.0
        textView.layer.shadowRadius = 2.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        
        
        
    }
    func addShadowForBtn(textView : UIButton){
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        textView.layer.shadowOpacity = 1.0
        textView.layer.shadowRadius = 2.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    
    func refresh() {
        backImage1.image = nil
        backImage2.image = nil
        backImage3.image = nil
        
        view1.isHidden = false
        view2.isHidden = false
        view3.isHidden = false
    }

    func setup(index: Int, answers: [AnswerOfQuestion]) {
        print(answers.count)
        print("index -> \(index)")
        
        refresh()
        
        for index in 0..<answers.count {
            // get selected answer
            let selectedAnswer = answers[index]
            // check index
            if index == 0 {
                if selectedAnswer.isanonymous == "1"{
                   textView1.text = selectedAnswer.answer
                }else{
                    textView1.attributedText = setAttributedString(username: selectedAnswer.username ?? "", str: selectedAnswer.answer ?? "")
                }
//                textView1.text = selectedAnswer.answer
                backImage1.sd_setImage(with: URL(string: selectedAnswer.flower ?? ""), completed: nil)
            } else if index == 1 {
                if selectedAnswer.isanonymous == "1"{
                   textView2.text = selectedAnswer.answer
                }else{
                    textView2.attributedText = setAttributedString(username: selectedAnswer.username ?? "", str: selectedAnswer.answer ?? "")
                    //textView2.text = "\(selectedAnswer.username ?? ""): \(selectedAnswer.answer ?? "")"
                }

//                textView2.text = selectedAnswer.answer
                backImage2.sd_setImage(with: URL(string: selectedAnswer.flower ?? ""), completed: nil)
            } else {
                if selectedAnswer.isanonymous == "1"{
                   textView3.text = selectedAnswer.answer
                }else{
                    textView3.attributedText = setAttributedString(username: selectedAnswer.username ?? "", str: selectedAnswer.answer ?? "")
                }

//                textView3.text = selectedAnswer.answer
                backImage3.sd_setImage(with: URL(string: selectedAnswer.flower ?? ""), completed: nil)
            }
        }
        
        // hide empty views
        if answers.count == 1 {
            view2.isHidden = true
            view3.isHidden = true
        } else if answers.count == 2 {
            view3.isHidden = true
        }
        
        // move flowers left right
        if index % 2 == 0 {
            view1LeadingConstant.constant = 30
            view2TrailingConstant.constant = 30
            view3LeadingConstant.constant = 30
        } else {
            view1LeadingConstant.constant = UIScreen.main.bounds.width/2
            view2TrailingConstant.constant = UIScreen.main.bounds.width/2
            view3LeadingConstant.constant = UIScreen.main.bounds.width/2
        }
        
        self.textView1.flashScrollIndicators()
        self.textView2.flashScrollIndicators()
        self.textView3.flashScrollIndicators()
        
        
        
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAttributedString(username : String, str : String) -> NSAttributedString{
        let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.medium, size: 17)]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.regular, size: 14)]
        let partOne = NSMutableAttributedString(string: username, attributes: boldFontAttributes)
        let partTwo = NSMutableAttributedString(string: "\n\(str)", attributes: normalFontAttributes)

        let combination = NSMutableAttributedString()
        
        combination.append(partOne)
        combination.append(partTwo)
        return combination
    }
    @IBAction func reportBtn1(_ sender: UIButton) {
        print("report 1 clicked")
    }
    
    @IBAction func reportBtn2(_ sender: UIButton) {
        print("report 2 clicked")

    }
    
    @IBAction func reportBtn3(_ sender: UIButton) {
        print("report 3 clicked")

    }
}
