//
//  FormsDownloadViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 01/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class FormsDownloadViewController: BaseViewController {

    //MARK:- Outlets
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var chapterFormsButton: UIButton!
    @IBOutlet private weak var chapterInfoButton: UIButton!
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var printButton: UIButton!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionLabel.text = "You are now an official ACL Chapter\nLeader!\n\nYour Chapter Code is:xxxx\n\n\nAs such, you now have access to\nseveral resources"
    }
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.chapterFormsButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
            self.chapterInfoButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
            self.downloadButton.applyGradient(colours: [AppTheme.lightPurple, AppTheme.darkPurple])
            self.printButton.applyGradient(colours: [AppTheme.lightPurple, AppTheme.darkPurple])
        }
    }


    
    func savePdf(urlString:String, fileName:String, isFromPrint : Bool) {
        let urlString = urlString
        let documentsUrl:URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as! URL
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName).pdf")
           let fileURL = URL(string: urlString)
           let sessionConfig = URLSessionConfiguration.default
           let session = URLSession(configuration: sessionConfig)
           let request = URLRequest(url:fileURL!)
           let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
               if let tempLocalUrl = tempLocalUrl, error == nil {
                   // Success
                   if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                       print("Successfully downloaded. Status code: \(statusCode)")
                   }
                   do {
                    try FileManager.default.removeItem(at: destinationFileUrl)
                    do {
                     print("deleted old file")
                    }
                    
                    catch (let error){
                        print(error)
                    }
                       try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                       do {
                        
                        DispatchQueue.main.async {
                            SwiftLoader.hide()
                        }
                        if isFromPrint == true{
                            if UIPrintInteractionController.canPrint(destinationFileUrl) {
                                let printInfo = UIPrintInfo(dictionary: nil)
                                printInfo.jobName = destinationFileUrl.lastPathComponent
                                printInfo.outputType = .general
                                let printController = UIPrintInteractionController.shared
                                printController.printInfo = printInfo
                                printController.showsNumberOfCopies = false
                                printController.printingItem = destinationFileUrl
                                DispatchQueue.main.async {
                                    printController.present(animated: true, completionHandler: nil)
                                }
                            }
                        }else{
                               let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                            
                               for indexx in 0..<contents.count {
                                   if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                       let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                                    DispatchQueue.main.async {
                                         self.present(activityViewController, animated: true, completion: nil)
                                       }
                                   }
                               }
                        }
                       }
                       catch (let err) {
                        DispatchQueue.main.async {
                          SwiftLoader.hide()
                        }
                        print("error: \(err)")
                       }
                   } catch (let writeError) {
                    DispatchQueue.main.async {
                      SwiftLoader.hide()
                    }
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                   }
               } else {
                DispatchQueue.main.async {
                  SwiftLoader.hide()
                }
                   print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
               }
           }
           task.resume()
        DispatchQueue.main.async {
          SwiftLoader.hide()
        }
       }
    
//MARK:- Button actions
    @IBAction private func backToStartMainAction(_ sender: UIButton) {
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
    
    @IBAction private func backToACLAction(_ sender: UIButton) {
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
    
    @IBAction private func downloadAction(_ sender: Any) {
        DispatchQueue.main.async(execute: {
            SwiftLoader.show(title: "Downloading...", animated: true)
            self.savePdf(urlString: "http://www.africau.edu/images/default/sample.pdf", fileName: "ACL", isFromPrint: false)
        })
    }
    
    @IBAction private func chapterFormAction(_ sender: UIButton) {
        if let chooseLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLocationViewController") as? ChooseLocationViewController{
            self.navigationController?.pushViewController(chooseLocationViewController, animated: true)
        }
    }
    
    @IBAction private func printAction(_ sender: UIButton) {
        DispatchQueue.main.async(execute: {
                  SwiftLoader.show(title: "Downloading...", animated: true)
                  self.savePdf(urlString: "http://www.africau.edu/images/default/sample.pdf", fileName: "ACL", isFromPrint: true)
              })
        
    }
    
    @IBAction private func chapterInfoAction(_ sender: UIButton) {
        if let chooseLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseLocationViewController") as? ChooseLocationViewController{
            self.navigationController?.pushViewController(chooseLocationViewController, animated: true)
        }
    }
}
