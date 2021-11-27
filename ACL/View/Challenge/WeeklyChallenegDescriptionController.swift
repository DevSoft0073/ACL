//
//  WeeklyChallenegDescriptionController.swift
//  ACL
//
//  Created by RGND on 27/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class WeeklyChallenegDescriptionController: BaseViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    var challenge:Challenge?
    var moreTExt = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.applyGradient(colours: [AppTheme.lightPurple, AppTheme.darkPurple])
        
//        if let attString = challenge?.description?.htmlToAttributedString {
//
//            self.descriptionLabel.attributedText = getAttributedDescription(from: attString, font: AppFont.get(.regular, size: 15))
//        }
        self.descriptionLabel.text = moreTExt
    }
    
    func getAttributedDescription(from: NSAttributedString, font: UIFont) -> NSMutableAttributedString {
        let range = NSRange(location: 0, length: from.length)
        
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        
        let attribute = NSMutableAttributedString.init(attributedString: from)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white , range: range)
        attribute.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle , range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        
        return attribute
    }
    
    
    @IBAction func crossAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
