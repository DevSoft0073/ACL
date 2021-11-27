//
//  AboutACLChapterViewController.swift
//  ACL
//
//  Created by zapbuild on 29/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import SwiftlyScrollSlider

class AboutChapterViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet private weak var usersCollectionView: UICollectionView!
    @IBOutlet private weak var chaptersTableView: UITableView!
    @IBOutlet weak var scrollIndicatorView: SwiftlyScrollSlider!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet weak var parentScrollView: UIScrollView!
    
    //MARK:- Outlets
    var viewModel = AboutChapterViewModel()
    
    //MARK:- Outlets
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = "\u{22}As an ACL Chapter Leader, you get to form your\nown group. There are four types of chapters to\nchoose from. You may change Chapter Type any\ntime with appropriate notice.\u{22}"
        chaptersTableView.register(UINib(nibName: "AboutChapterHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "AboutChapterHeader")
        setupScrollIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chaptersTableView.reloadData()
        setContentHeight()
    }
    
    func setContentHeight(){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.parentScrollView.contentSize.height = self.chaptersTableView.contentSize.height
            self.setupScrollIndicator()
        }
    }
    
    private func setupScrollIndicator(){
        
        self.scrollIndicatorView.lineBackgroundWidth = 0.1
        self.scrollIndicatorView.lineBackgroundView?.layer.borderColor = UIColor.clear.cgColor
        self.scrollIndicatorView.lineBackgroundView?.backgroundColor = UIColor.init(red: 252.0/255.0, green: 246.0/255.0, blue: 254.0/255.0, alpha: 1)
        self.scrollIndicatorView.thumbImageView?.image = UIImage(named: "about_acl_chapter_scroll")
    }
    
    //MARK:- Button Actions
    @IBAction private func backToStartChapterAction(_ sender: UIButton) {
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
    
    @IBAction private func backToMyACLAction(_ sender: UIButton) {
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
}

extension AboutChapterViewController: UITableViewDelegate, UITableViewDataSource , ChapterHeaderTapped{
    func headerTapped(tag: Int) {
         viewModel.chaptersData[tag].chapterHeader.isExpended = !viewModel.chaptersData[tag].chapterHeader.isExpended
        chaptersTableView.reloadSections([tag], with: .automatic)
        setContentHeight()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.chaptersData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.chaptersData[section].chapterHeader.isExpended{
            return viewModel.chaptersData[section].chapterTitles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell") as? DropDownTableViewCell {
            cell.dropDownLabel.text = viewModel.chaptersData[indexPath.section].chapterTitles[indexPath.row]
           // cell.layoutMargins = tableView.to_scrollBar!.adjustedTableViewCellLayoutMargins(forMargins: cell.layoutMargins, manualOffset: 0)
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cornerRadius = 50
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AboutChapterHeader") as? AboutChapterHeader{
            headerView.tag = section
            headerView.setup(chapterHeader: viewModel.chaptersData[section].chapterHeader)
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}

extension AboutChapterViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChapterUserCollectionViewCell", for: indexPath) as! ChapterUserCollectionViewCell
        if indexPath.row == 0 {
            cell.contentView.isHidden = true
        }else{
            cell.contentView.isHidden = false
        }
            
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:60, height:60)
    }
    
}
