//
//  AppConstants.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

func openwebLink(controller : UIViewController, link : String){
    let vc = SFSafariViewController(url: URL(string: link)!)
    vc.delegate = controller as? SFSafariViewControllerDelegate
    controller.present(vc, animated: true, completion: nil)
}


let videoUrl = "http://www.livewithacl.org/wp-content/uploads/2018/10/welcome-acl.mp4"

let donateUrl = "https://www.paypal.com/donate?hosted_button_id=626NW7YNHPUAQ&source=url"

let reminderKey = "reminder_Key"

let learnAboutTextForAuto = "Most challenges have 3 options for the theme. Choose one, all, or skip any that don’t appeal to you! Many have a frequency request such as “Do this once a day this week.” Feel free to customize to match your schedule."

let learcnAboutTextWithClick = "These challenges are completely optional. You may choose to do some and not others or none at all. They change every week on Sunday night. Weekly challenges are intended to inspire as well as encourage ACL practice in real-life settings. Please use discretion when & if you choose a challenge by exercising self-care and awareness to recognize where your comfort zone is. See “How to practice self care while simultaneously expanding one’s comfort zone”. You might find it helpful to keep a log for & review it at the end of each exercise. Insights can be found anytime, but often come in the review. Lastly, have fun!"

let isSoundSelected_key = "isSoundSelected"
let selectedSoundURL_Key = "selectedSoundURL"
let selectedSoundName_Key = "selectedSoundName"

func displayActionSheetWithTitle(title : String,_ buttons:[String], completion:((_ index:Int, _ isCancel : Bool) -> Void)?) -> Void {
    
    let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion!(index, false)
            }
        })
        
        
      //  action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: {
        (alert: UIAlertAction!) in
        if(completion != nil){
            completion!(0, true)
        }
    })
    UILabel.appearance(whenContainedInInstancesOf:
    [UIAlertController.self]).numberOfLines = 0
    alertController.addAction(cancel)
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}

func displayALertWithTitles(title : String,message : String,_ buttons:[String], completion:((_ index:Int, _ isCancel : Bool) -> Void)?) -> Void {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    for index in 0..<buttons.count    {
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion!(index, false)
            }
        })
        
        
      //  action.setValue(UIColor.black, forKey: "titleTextColor")
        alertController.addAction(action)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
        (alert: UIAlertAction!) in
        if(completion != nil){
            completion!(0, true)
        }
    })
    
    alertController.addAction(cancel)
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}




func displayActionSheetWithCongratsVC(title : String,_ buttons:[String], completion:((_ index:Int, _ isCancel : Bool) -> Void)?) -> Void {
    
    let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
    
    
    for index in 0..<buttons.count    {
        
        
        let action = UIAlertAction(title: buttons[index], style: .default, handler: {
            (alert: UIAlertAction!) in
            if(completion != nil){
                completion!(index, false)
            }
        })
        alertController.addAction(action)
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
        (alert: UIAlertAction!) in
        if(completion != nil){
            completion!(0, true)
        }

    })
    cancel.setValue(UIColor.systemRed, forKey: "titleTextColor")

   
    UILabel.appearance(whenContainedInInstancesOf:[UIAlertController.self]).numberOfLines = 2
    alertController.addAction(cancel)
    

    
    UIApplication.shared.delegate!.window!?.rootViewController!.present(alertController, animated: true, completion:nil)
}



func getAttributedSTRWithUnderLine(str1 : String, str2 : String) -> NSAttributedString{
    let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.regular, size: 16)]
    let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: AppFont.get(.regular, size: 16), NSAttributedString.Key.underlineColor : UIColor.white, NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
    let partOne = NSMutableAttributedString(string: str1, attributes: boldFontAttributes)
    let partTwo = NSMutableAttributedString(string: str2, attributes: normalFontAttributes)

    let combination = NSMutableAttributedString()
    
    combination.append(partOne)
    combination.append(partTwo)
    return combination
}



func setDarkStatusBar(){
    if #available(iOS 13.0, *) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.darkContent
    } else {
        // Fallback on earlier versions
    }
}


func setLightStatusBar(){
    UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
}
