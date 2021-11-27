//
//  LoadingViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    
    @IBOutlet weak var quoteLbl: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    var slideImages = ["Account Created. pacific-sunrise-PNZ2KBD","C1 Seattle ACL","C2 rear-view-of-silhouetted-male-and-female-couple-in-CJV8CA7","C3 Seattle ACL","C4 shutterstock_196930781","C5 Seattle ACL","C6 heart-felt-friendship-4PMWEC7","C7 Seattle ACL","C8 Seattle ACL"]
    
    var timer : Timer?
    var slideTimer : Timer?
    var currentIndex = 1
    var progressVal = 0.0
    let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        setupPagerView()
        self.progressView.setProgress(Float(self.progressVal), animated: true)

        SwiftLoader.show(animated: true)
        viewModel.getData { (isSuccess, msg) in
            SwiftLoader.hide()
            self.quoteLbl.attributedText = self.setAttributedString(quote: self.viewModel.quote?.quote ?? "", author: self.viewModel.quote?.author ?? "")

            //self.quoteLbl.text = self.viewModel.quote?.quote
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(callNavigation), userInfo: nil, repeats: false)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
//       self.gotoMainViewController()
//
//        }
        slideTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animatePage), userInfo: nil, repeats: true)
    }
    
    
    
    
    @objc func callNavigation(){
        if DataManager.shared.userId != nil {
            if DataManager.shared.isGuestUser{
                gotoLoginViewController()
            }else{
                self.gotoMainViewController()
            }
        } else {
            gotoLoginViewController()
        }
//        self.gotoMainViewController()
    }
    
    func setupPagerView() {
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        pagerView.itemSize = CGSize(width: 220, height: pagerView.frame.height + 100)
        pagerView.interitemSpacing = 20
//        pagerView.decelerationDistance = 2
//        pagerView.
        pagerView.isUserInteractionEnabled = false
        pagerView.automaticSlidingInterval = 2
    }
    
    
    @objc func animatePage(){
//        if currentIndex <= 8{
//            pagerView.scrollToItem(at: currentIndex, animated: true)
//            self.currentIndex += 1
//        }else{
//            slideTimer?.invalidate()
//            slideTimer = nil
//        }
        if slideTimer != nil{
            self.progressView.setProgress(Float(self.progressVal), animated: true)
            self.progressVal += 0.1
        }else{
            slideTimer?.invalidate()
            slideTimer = nil
        }
        
        
       
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backAction(_ sender: Any) {
    
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        timer?.invalidate()
        
        if DataManager.shared.userId != nil {
            if DataManager.shared.isGuestUser{
                gotoLoginViewController()
            }else{
                self.gotoMainViewController()
            }
        } else {
            gotoLoginViewController()
        }
        //self.gotoMainViewController()
    }
    
}


extension LoadingViewController: FSPagerViewDataSource {
    
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return slideImages.count
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = UIImage(named: slideImages[index])
        cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.clipsToBounds = true
        return cell
    }
}


extension LoadingViewController: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        
    }
    
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return true
    }
}
