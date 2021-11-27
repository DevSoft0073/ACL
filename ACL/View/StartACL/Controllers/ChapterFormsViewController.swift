//
//  ChapterFormsViewController.swift
//  ACL
//
//  Created by zapbuild on 30/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit

class ChapterFormsViewController: BaseViewController {

    //MARK:- Outlets
    @IBOutlet private weak var formsTableView: UITableView!
    
    //MARK:- Varibales
    private var viewModel = ChapterFormsViewModel()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       formsTableView.register(UINib(nibName: "ChapterFormsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "ChapterFormsHeader")

    }

    //MARK:- Button actions
    @IBAction func backToMainChapterAction(_ sender: UIButton) {
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
    
    @IBAction func backToSettingAction(_ sender: UIButton) {
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

extension ChapterFormsViewController: UITableViewDelegate, UITableViewDataSource , FormsHeaderTapped{
    func headerTapped(tag: Int) {
         viewModel.formsData[tag].formsHeader.isExpended = !viewModel.formsData[tag].formsHeader.isExpended
        formsTableView.reloadSections([tag], with: .automatic)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.formsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.formsData[section].formsHeader.isExpended{
            return viewModel.formsData[section].formsTitles.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell") as? DropDownTableViewCell {
            cell.dropDownLabel.text = viewModel.formsData[indexPath.section].formsTitles[indexPath.row]
            
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
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ChapterFormsHeader") as? ChapterFormsHeader{
            headerView.tag = section
            headerView.setup(formsHeader: viewModel.formsData[section].formsHeader)
            headerView.delegate = self
            return headerView
        }
        return UIView()
    }
}


