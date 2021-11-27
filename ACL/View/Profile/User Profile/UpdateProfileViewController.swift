//
//  UpdateProfileViewController.swift
//  ACL
//
//  Created by RGND on 07/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import GooglePlaces
import SDWebImage

class UpdateProfileViewController: BaseViewController {

    @IBOutlet weak var emailTextField: DefaultTextField!
    @IBOutlet weak var usernameTextField: DefaultTextField!
    @IBOutlet weak var cityTextField: DefaultTextField!
    @IBOutlet weak var countryTextField: DefaultTextField!
    @IBOutlet weak var passwordTextField: DefaultTextField!
    @IBOutlet weak var photoTextField: DefaultTextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profilePicView: UIView!
    @IBOutlet weak var picEditButton: UIButton!
    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var notRobotButton: UIButton!
    @IBOutlet weak var captchaView: UIView!
    @IBOutlet weak var clickHereButton: UIButton!
    
    @IBOutlet weak var phoneTextFld: DefaultTextField!
    @IBOutlet weak var firstName: DefaultTextField!
    @IBOutlet weak var lastNameFld: DefaultTextField!
    @IBOutlet weak var oldPasswordFld: DefaultTextField!
    
    var imagePicker: ImagePicker!
    let viewModel = UpdateProfieViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        perform(#selector(getProfile)  , with: nil, afterDelay: 0.2)
    }
    
    func setupUI() {
        saveButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    @objc func getProfile() {
        SwiftLoader.show(animated: true)
        viewModel.getProfile { status, message in
            DispatchQueue.main.async {
                // hide loader
                SwiftLoader.hide()
                // validate status
                if status {
                    self.updateUI()
                } else {
                    self.showError(message)
                }
            }
        }
    }
    
    func updateUI() {
        emailTextField.text = viewModel.email
        usernameTextField.text = viewModel.username
        lastNameFld.text = viewModel.lastName
        cityTextField.text = viewModel.city
        countryTextField.text = viewModel.country
        passwordTextField.text = viewModel.password
        firstName.text = viewModel.firstName
        if viewModel.phone != nil && viewModel.phone != ""{
            phoneTextFld.text = viewModel.phone
        }
        if let imageData = viewModel.profilePicData, let image = UIImage(data: imageData){
            ProfilePic.image = image
            
        } else if let imageUrlString = viewModel.profilePicUrl, let url = URL(string: imageUrlString) {
            ProfilePic.sd_setImage(with: url, placeholderImage: UIImage(named: "my_default_picture"))//my_default_picture
        }
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: "click here", attributes: attributes)
        clickHereButton.titleLabel?.attributedText = attributedText
        
        if DataManager.shared.isGuestUser{
            self.picEditButton.isHidden = true
        }else{
            self.picEditButton.isHidden = false
        }
    }
    

    
    @IBAction func clickAction( _ sender: Any) {
        if let vc = UIStoryboard(name: "Help", bundle: nil).instantiateViewController(withIdentifier: "VideoViewController") as? VideoViewController {
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func backAction( _ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editPicAction(_ sender: Any) {
        if DataManager.shared.isGuestUser == false{
            self.imagePicker.present(from: self.view)
        }
    }
    
    @IBAction func captchaAction(_ sender: Any) {
        notRobotButton.isSelected = !notRobotButton.isSelected
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if sender == usernameTextField {
            viewModel.username = sender.text
        } else if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        }else if sender == phoneTextFld {
            viewModel.phone = sender.text
        }else if sender == oldPasswordFld {
            viewModel.oldPassword = sender.text
        }
    }
    
    @IBAction func CountryFieldDidSelect(_ sender: UITextField) {
        sender.resignFirstResponder()
        
        if let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationController") as? SearchLocationController {
            vc.delegate = self
            if sender == cityTextField{
                vc.placeholder = "Enter your city to search"
            }else{
                vc.placeholder = "Enter your country to search"
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        let validation = viewModel.validateEntries()
        if validation.valid {
            SwiftLoader.show(animated: true)
            viewModel.update{ status, message in
                DispatchQueue.main.async {
                    // hide loader
                    SwiftLoader.hide()
                    // validate status
                    if status {
                        self.gotoMainViewController()
                    } else {
                        self.showError(message)
                    }
                }
            }
        } else {
            self.showError(validation.message)
        }
    }
}

extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cityTextField || textField == countryTextField {
            return false
        }else if textField == phoneTextFld{
            let allowingChars = "+0123456789"
            let numberOnly = NSCharacterSet.init(charactersIn: allowingChars).inverted
            let validString = string.rangeOfCharacter(from: numberOnly) == nil
            return validString
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            viewModel.email = textField.text
        } else if textField == passwordTextField {
            viewModel.password = textField.text
        }else if textField == phoneTextFld {
            viewModel.phone = textField.text
        }else if textField == oldPasswordFld{
            viewModel.oldPassword = textField.text
        }
    }
}

extension UpdateProfileViewController: SearchLocationControllerDelegate {
    func placeSelected(_ place: GMSPlace) {
        // get city name
        if let name = place.name {
            debugPrint("Place name: \(name)")
            viewModel.city = name
        } else if let cityName = place.addressComponents?.first(where: { $0.type == "city" })?.name {
            debugPrint("city -> \(cityName)")
            viewModel.city = cityName
        } else if let localityName = place.addressComponents?.first(where: { $0.type == "locality" })?.name {
            debugPrint("localityName -> \(localityName)")
            viewModel.city = localityName
        }
        // get country code
        if let country = place.addressComponents?.first(where: { $0.type == "country" })?.name {
            debugPrint("country -> \(country)")
            viewModel.country = country
        }
        // get coordinates
        debugPrint("coordinate -> \(place.coordinate)")
        viewModel.latitude = "\(place.coordinate.latitude)"
        viewModel.longitude = "\(place.coordinate.longitude)"
        
        self.updateUI()
    }
}

extension UpdateProfileViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.ProfilePic.image = image
        self.viewModel.profilePicData = image?.pngData()
    }
}
