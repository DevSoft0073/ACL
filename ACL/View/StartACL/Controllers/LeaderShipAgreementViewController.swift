//
//  LeaderShipAgreementViewController.swift
//  ACL
//
//  Created by Rakesh verma on 31/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import SwiftlyScrollSlider

class LeaderShipAgreementViewController: BaseViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var scrollIndicatorView: SwiftlyScrollSlider!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        descriptionTextView.text = "It is long established fact that a reader will be\ndistracted by a readable content of a page when\nlooking at it's layout. The point of using.\n\nIt is long established fact that a reader will be\ndistracted by a readable content of a page when\nlooking at it's layout. The point of using.\n\nIt is long established fact that a reader will be\ndistracted by a readable content of a page when\nlooking at it's layout. The point of using.\n\nIt is long established fact that a reader will be\ndistracted by a readable content of a page when\nlooking at it's layout. The point of using."
        
        setupScrollIndicator()
    }
    
    private func setupScrollIndicator(){
        self.scrollIndicatorView.lineBackgroundWidth = 0.1
        self.scrollIndicatorView.lineBackgroundView?.layer.borderColor = UIColor.white.cgColor
        self.scrollIndicatorView.lineBackgroundView?.backgroundColor = .white
        self.scrollIndicatorView.thumbImageView?.image = UIImage(named: "whiteScrollIndicator")
    }

    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.agreeButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
            //self.backView.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightOrange])
            self.backView.applyGradientTopLeftToBottonRight(colours: [AppTheme.darkPurple.withAlphaComponent(0.5),AppTheme.lightOrange.withAlphaComponent(1.0)], locations: nil)
        }
    }

    
    @IBAction func backToACLAction(_ sender: UIButton) {
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
    
    @IBAction func backToMainAction(_ sender: Any) {
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
    
    @IBAction func agreeAction(_ sender: UIButton) {
        if let formsDownloadViewController = self.storyboard?.instantiateViewController(withIdentifier: "FormsDownloadViewController") as? FormsDownloadViewController{
            self.navigationController?.pushViewController(formsDownloadViewController, animated: true)
        }
    }
}
