//
//  WeeklyChallengeViewController.swift
//  ACL
//
//  Created by RGND on 20/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class WeeklyChallengeViewController: BaseViewController {

    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var acceptChalengeButton: UIButton!
    @IBOutlet weak var iDidButton: UIButton!
    @IBOutlet weak var learbAboutThisButton: UIButton!
    @IBOutlet weak var readMoreButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var popupDetailTextView: UITextView!
    @IBOutlet weak var weekTitleLabel: UILabel!
    @IBOutlet weak var weekDescriptionLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var popUpViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var tableBackView: UIView!
    let viewmodel = WeeklyChallengeViewModel()
    var isFromLibrary = false
    var challengeDatafromLib = [String: Any]()
    
    let learnText = "Challenges provide weekly practice in living ACL in your own life outside of an ACL group meeting (Or App!)                                                                                                                                                                                                                                                             Real world practice of ACL principles and skills"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteTap))
//        starImageView.addGestureRecognizer(tapGestureRecognizer)
//        starImageView.isUserInteractionEnabled = true
        
        iDidButton.applyGradient(colours: [AppTheme.lightPurple, AppTheme.darkPurple])
        learbAboutThisButton.applyGradient(colours: [AppTheme.Transparent.darkBlue, AppTheme.Transparent.lightBlue], locations: [0, 1, 1])
        
        readMoreButton.addUnderLine()
        // hide learnAboutThis
        
        tableView.indicatorStyle = .white
//        starImageView.addGestureRecognizer(UIGestureRecognizer.init(target: self, action: #selector(favoriteTap)))
      
        
        
        
        // disable iDid button
       iDidButton.isUserInteractionEnabled = acceptChalengeButton.isSelected
        iDidButton.alpha = 0.6
        
        // set table view edge inset
//        tableView.contentInset.top = 8
        // set table view height
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone6, .iPhone7, .iPhone6S, .iPhone8,.iPhoneSE2 :
            tableViewHeightConstant.constant = 100
            popUpViewHeight.constant = 0
        case .iPhone7Plus, .iPhone8Plus:
            tableViewHeightConstant.constant = 150
            popUpViewHeight.constant = 0
        default:
            tableViewHeightConstant.constant = 150
            popUpViewHeight.constant = 0

            break
        }
        
//        if let alreadyEnter = UserDefaults.standard.bool(forKey: "alreadyEnter") as? Bool{
//            if alreadyEnter == true{
//                popupView.isHidden = true
//            }else{
//                popupView.isHidden = false
//                UserDefaults.standard.set(true, forKey: "alreadyEnter")
//
//            }
//        }
        
        
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        popupView.isHidden = false
        popupDetailTextView.text = learnAboutTextForAuto
        self.backGroundImageView.alpha = 0.1
        self.getAndSetup()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.backGroundImageView.alpha = 0.7
    }
    
    func getAndSetup(){
        if isFromLibrary == true{
            SwiftLoader.show(animated: true)
            viewmodel.challenge = Challenge(challengeDatafromLib)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.updateView()
                SwiftLoader.hide()
            }
        }else{
            SwiftLoader.show(animated: true)
            viewmodel.getChallenge { status, messages in
                 SwiftLoader.hide()
                self.updateView()
            }
        }
    }
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        SwiftLoader.show(animated: true)

        viewmodel.addFavourite { (status, msg) in
            guard status else {
                self.showError(msg)
                return
            }
            SwiftLoader.hide()
            if self.starImageView.image == UIImage(named: "main_screen_star"){
                self.starImageView.image = UIImage(named: "silverStar")
            }else{
                self.starImageView.image = UIImage(named: "main_screen_star")
            }
        }
    }
//    @objc func favoriteTap(){
//
//        SwiftLoader.show(animated: true)
//
//        viewmodel.addFavourite { (status, msg) in
//            guard status else {
//                self.showError(msg)
//                return
//            }
//            SwiftLoader.hide()
//            if self.starImageView.image == UIImage(named: "main_screen_star"){
//                self.starImageView.image = UIImage(named: "silverStar")
//            }else{
//                self.starImageView.image = UIImage(named: "main_screen_star")
//            }
//        }
//    }
    
    
    func getHtmpString(string: String, color: UIColor) -> NSAttributedString? {
        
        guard let data = string.data(using: .utf8) else { return NSAttributedString() }
        do {
             let rr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let p = NSMutableAttributedString(attributedString: rr)
            var attributes = [NSAttributedString.Key: AnyObject]()
            attributes[.foregroundColor] = UIColor.white
            p.addAttributes(attributes, range: NSMakeRange(0, string.count))
            
            return p
        } catch {
            return NSAttributedString()
        }
    }
    
    
    func updateView() {
        //  reload list
        self.tableView.reloadData()
        // set challenge title
        self.weekTitleLabel.text = (viewmodel.challenge?.weekTitle ?? "") + "\n" + (viewmodel.challenge?.name?.capitalized ?? "")
        
        // set buttons based on challenge status
        acceptChalengeButton.isSelected = viewmodel.challenge?.isCompleted ?? false
       
        if let challenge = viewmodel.challenge {
            acceptChalengeButton.isUserInteractionEnabled = !challenge.isCompleted
            
            if challenge.isCompleted {
                iDidButton.isSelected = true
                iDidButton.isUserInteractionEnabled = false
                iDidButton.alpha = 1
            } else {
                iDidButton.isSelected = false
                iDidButton.isUserInteractionEnabled = true
                iDidButton.alpha = 0.6
            }
            
//            iDidButton.isUserInteractionEnabled = true//testing
            
            
        }
        
        
        // set challenge and popup desciptions
        if let attString = viewmodel.challenge?.description?.htmlToAttributedString {
            
            self.weekDescriptionLabel.attributedText = getAttributedDescription(from: attString, font: AppFont.get(.regular, size: 16))
            if let attrLearnDescp = viewmodel.challenge?.learnDescp?.htmlToAttributedString{
//                self.popupDetailTextView.attributedText = getAttributedDescription(from: attrLearnDescp, font: AppFont.get(.regular, size: 12))

            }
            
        } else {
            self.weekDescriptionLabel.text = viewmodel.challenge?.description
//            self.popupDetailTextView.text = viewmodel.challenge?.learnDescp
        }
        if viewmodel.challenge?.isFavorite ?? false{
            starImageView.image = UIImage(named: "main_screen_star")
        }else{
            starImageView.image = UIImage(named: "silverStar")
        }
        
        //            tableViewHeightConstant.constant = 0

        if viewmodel.challenge?.pastChalenges.count == 0{
            tableViewHeightConstant.constant = 0
        }else if viewmodel.challenge?.pastChalenges.count == 1{
            tableViewHeightConstant.constant = 60
        }
        
        self.tableView.layoutIfNeeded()
        self.tableView.layoutSubviews()
    }
    
    func getAttributedDescription(from: NSAttributedString, font: UIFont) -> NSMutableAttributedString {
        
        let range = NSRange(location: 0, length: from.length)
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let attribute = NSMutableAttributedString.init(attributedString: from)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)
        attribute.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        
        return attribute
    }
    
    override func viewDidLayoutSubviews() {
        detailView.applyGradient(colours: [AppTheme.Transparent.lightPurple, AppTheme.Transparent.darkPurple])
        popupView.applyGradient(colours: [AppTheme.Transparent.lightBlue, AppTheme.Transparent.darkBlue])
        // set rounded views
        detailView.roundCorners([.topLeft, .topRight], radius: 55)
     
        tableBackView.roundCorners([.bottomLeft, .bottomRight], radius: 30)
        // set gradinant color
        backView.applyGradient(colours: [AppTheme.mustered, AppTheme.Transparent.darkBlue])
        tableView.layoutIfNeeded()
    }
    
    @IBAction func crossPopupAction(_ sender: Any) {
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5, .iPhone5S, .iPhone6, .iPhone7, .iPhone6S, .iPhone8,.iPhoneSE2 :
            popUpViewHeight.constant = 0
        case .iPhone7Plus, .iPhone8Plus:
            popUpViewHeight.constant = 0
        default:
            popUpViewHeight.constant = 0
            break
        }

        popupView.isHidden = true
        popupDetailTextView.text = learcnAboutTextWithClick
    }
    
    @IBAction func readMoreAction(_ sender: Any) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
//            weeklyChallenegDescriptionController.moreTExt = learcnAboutTextWithClick
            weeklyChallenegDescriptionController.moreTExt = self.weekDescriptionLabel.text ?? ""
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }
    }
    
    @IBAction func learnAboutThisAction(_ sender: Any) {
        // hide learnAboutThis
//        popupView.isHidden = false
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
          //  weeklyChallenegDescriptionController.challenge = viewmodel.challenge
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }

    }
    
    @IBAction func acceptChallengeAction(_ sender: Any) {
        guard let challenge = viewmodel.challenge, !challenge.isCompleted else {
            return
        }
        
        // update button view
        acceptChalengeButton.isSelected = !acceptChalengeButton.isSelected
        // enable button
        iDidButton.isUserInteractionEnabled = acceptChalengeButton.isSelected
        iDidButton.alpha = acceptChalengeButton.isSelected ? 1.0 : 0.6
    }
    
    @IBAction func IDidAction(_ sender: Any) {
        
//        if let weeklyChallengeCompleteController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallengeCompleteController") as? WeeklyChallengeCompleteController {
//            weeklyChallengeCompleteController.modalPresentationStyle = .fullScreen
//            let didItView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 50))
//            didItView.center = CGPoint(x: weeklyChallengeCompleteController.view.bounds.size.width / 2 - 10,
//                                       y: weeklyChallengeCompleteController.view.bounds.size.height - 50 / 2 - 32)
//
//            didItView.layer.cornerRadius = 25
//            didItView.backgroundColor = .clear
//            let lbl = UILabel()
//            lbl.text = "You Did It!!!"
//            lbl.center = didItView.center
//            lbl.frame = CGRect(x: 0, y: 0, width: 220, height: 42)
//            lbl.font = UIFont(name: "Zapfino", size: 20)
//            lbl.textAlignment = .center
//            lbl.textColor = .white
//            didItView.addSubview(lbl)
//            weeklyChallengeCompleteController.view.addSubview(didItView)
//
//            self.navigationController?.present(weeklyChallengeCompleteController, animated: true, completion: nil)
//        }
//
//        return
      
        
        guard let challenge = viewmodel.challenge, !challenge.isCompleted else {
            return
        }
        
        SwiftLoader.show(animated: true)
        viewmodel.completeChallenge { status, message in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
                guard status else {
                    self.showError(message)
                    return
                }
                
                if let weeklyChallengeCompleteController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallengeCompleteController") as? WeeklyChallengeCompleteController {
                    weeklyChallengeCompleteController.modalPresentationStyle = .fullScreen
                    let didItView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 50))
                    didItView.center = CGPoint(x: weeklyChallengeCompleteController.view.bounds.size.width / 2 - 10,
                                               y: weeklyChallengeCompleteController.view.bounds.size.height - 50 / 2 - 32)
                    
                    didItView.layer.cornerRadius = 25
                    didItView.backgroundColor = .clear
                    let lbl = UILabel()
                    lbl.text = "You Did It!!!"
                    lbl.center = didItView.center
                    lbl.frame = CGRect(x: 0, y: 0, width: 220, height: 42)
                    lbl.font = UIFont(name: "Zapfino", size: 20)
                    lbl.textAlignment = .center
                    lbl.textColor = .white
                    didItView.addSubview(lbl)
                    weeklyChallengeCompleteController.view.addSubview(didItView)
                    
                    self.navigationController?.present(weeklyChallengeCompleteController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension WeeklyChallengeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.challenge?.pastChalenges.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeListingCell") as? ChallengeListingCell {
            if let challenge = viewmodel.challenge?.pastChalenges[indexPath.row] {
                cell.titleLabel.text = challenge.name
            }
            return cell
        }
        
        return ChallengeListingCell()
    }
}
