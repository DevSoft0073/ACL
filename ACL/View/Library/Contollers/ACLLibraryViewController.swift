//
//  ACLLibraryViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
         
class ACLLibraryViewController: BaseViewController {

    //MARK:- Outlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var dropDownTable: UITableView!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectedLabel: UILabel!
    @IBOutlet private weak var dropDownButton: UIButton!
    @IBOutlet weak var searchTextFld: UITextField!
    
    //MARK:- Variables
    private var dropDownItems:[String] = ["Meditations", "Challenges","Awareness Exercises","Courage Exercises","Love Exercises"]
//    private var dropDownItems:[String] = ["Quotes", "Suggested Reading","Meditations", "General Articles", "Questions", "Blogs & Podcasts", "Challeges", "Challeges","Exercises", "Acedmic Publications","Videos"]

    var searchableText = ""
    var searchDataInstance = SaveSearchData()
    var searchArray : [SearchedData] = []
    
    //MARK:- View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        if UIDevice().isRegularModel() {
            titleLabelTopConstraint.constant = 30
        } else if UIDevice().isPlusModel() {
            titleLabelTopConstraint.constant = 50
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.setCollectionViewLayout(layout, animated: true)
        searchTextFld.delegate = self
        dropDownTable.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getSearchedHistory()
    }
    
    func getSearchedHistory(){
        searchDataInstance.getHistoryData()
        searchArray = searchDataInstance.searchHistoryData as! [SearchedData]
        dropDownTable.reloadData()
    }
    
    
    //MARK:- Button Actions
    @IBAction private func dropDownAction(_ sender: UIButton) {
        if searchArray.count > 0{
            sender.isSelected = !sender.isSelected
            dropDownTable.isHidden = !sender.isSelected
            searchButton.isHidden = sender.isSelected
        }
        
    }
    
    @IBAction private func backToMainAction(_ sender: UIButton) {
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
    
    @IBAction private func searchButtonAction(_ sender: UIButton) {
        if searchTextFld.text!.isEmpty{
            showError("search text is required")
        }else{
            searchDataInstance.saveDataInCoreData(idSearch: searchTextFld.text ?? "")
            
            if let searchViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController{
                searchViewController.searchText = searchableText
                self.navigationController?.pushViewController(searchViewController, animated: true)
            }

        }
        
    }
}


extension ACLLibraryViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownTableViewCell") as? DropDownTableViewCell {
            // get list of answers for current label
            let data = searchArray[indexPath.row]
            cell.dropDownLabel.text = data.name
            cell.selectionStyle = .none
//            cell.dropDownLabel.text = dropDownItems[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchTextFld.text = searchArray[indexPath.row].name
        searchableText = searchTextFld.text ?? ""
        dropDownButton.isSelected = !dropDownButton.isSelected
        tableView.isHidden = !dropDownButton.isSelected
        searchButton.isHidden = dropDownButton.isSelected
        dropDownTable.isHidden = true
        searchButton.isHidden = false
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let text = searchTextFld.text
        let textRange = Range(range, in: text ?? "")
        let updatedText = text?.replacingCharacters(in: textRange!, with: string) ?? ""
        if updatedText.count > 0{
            
            dropDownTable.isHidden = true
        }else{
            if searchArray.count > 0{
                dropDownTable.isHidden = false
            }
        }
        searchableText = updatedText
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTextFld{
            if searchArray.count > 0{
                dropDownTable.isHidden = false
            }
        }
    }
    
}

extension ACLLibraryViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dropDownItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as! LibraryCollectionViewCell
        cell.libraryLabel.text = dropDownItems[indexPath.row]
        cell.libraryLabel.textAlignment = .left
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 1.0, left: 1.0, bottom: 1.0, right: 1.0)//here your custom value for spacing
        }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                let lay = collectionViewLayout as! UICollectionViewFlowLayout
                let widthPerItem = collectionView.frame.width / 2 - lay.minimumInteritemSpacing

    return CGSize(width:widthPerItem, height:20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dropDownItems[indexPath.row]{
//        ["Meditations", "Challeges","Awareness Exercises","Courage Exercises","Love Exercises"]
        case "Meditations":
            self.pushToMeditationScreen()
        case "Challeges":
            self.pushToChallengeScreen()
        case "Awareness Exercises":
            if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
                aclExercisesViewController.viewtype = .awareness
                self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
            }
        case "Courage Exercises":
            if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
                aclExercisesViewController.viewtype = .courage
                self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
            }
        case "Love Exercises":
            if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
                aclExercisesViewController.viewtype = .love
                self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
            }
        default:
            break
        }
    }
    
    func pushToMeditationScreen(){
        if let dailyMeditationViewController = UIStoryboard(name: "Meditation", bundle: nil).instantiateViewController(withIdentifier: "DailyMeditationViewController") as? DailyMeditationViewController {
            self.navigationController?.pushViewController(dailyMeditationViewController, animated: true)
        }
    }
    func pushToChallengeScreen(){
        if let weeklyChallengeViewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallengeViewController") as? WeeklyChallengeViewController {
            self.navigationController?.pushViewController(weeklyChallengeViewController, animated: true)
        }
    }
    
    
    
    
}
