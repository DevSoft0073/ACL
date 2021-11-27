//
//  FindACLNearMeController.swift
//  ACL
//
//  Created by RGND on 23/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class FindACLNearMeController: BaseViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var cityTextField: DefaultTextField!
    @IBOutlet weak var countryTextField: DefaultTextField!
    @IBOutlet weak var zipcodeTextField: DefaultTextField!
    
    enum chapterTypes:Int {
            case privateChapter = 0
           case  publicChapter = 1
            case ghostChapter = 2
        }
    
    var viewModel = FinalACLViewModel()
    let learnText = "Click on the location icons for more information about that chapter!"
    var needMarker = false
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
        
        if Singleton.sharedInstance.isEnterfromMyACL == false{
            SwiftLoader.show(animated: true)
            viewModel.findACL { status, message in
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    if self.viewModel.hasLocalChapters == false{
                        self.showError("No ACL found on your location")
                    }
                    self.reloadMap()
                }
            }

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // add observer to ditect tap on right view
        if Singleton.sharedInstance.isEnterfromMyACL == false{
            NotificationCenter.default.addObserver( self,
                       selector: #selector(self.moveToOriginalLocation),
                       name: Notification.Name("TextFieldRightViewTapped"),
                       object: nil)
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove observer to ditect tap on right view
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TextFieldRightViewTapped"), object: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAgainAction(_ sender: Any) {
        reloadData()
    }
    
    @IBAction func learnAbt(_ sender: UIButton) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }

    }
    func reloadData() {
        // set text fields
        self.cityTextField.text = viewModel.searchCityName
        self.countryTextField.text = viewModel.searchCountryName
        self.zipcodeTextField.text = viewModel.searchZipcode
        // get data
        if Singleton.sharedInstance.isEnterfromMyACL == true{
            Singleton.sharedInstance.isEnterfromMyACL = false
            Singleton.sharedInstance.userLatLonginMY_ACL["lat"] = viewModel.searchLat
            Singleton.sharedInstance.userLatLonginMY_ACL["lng"] = viewModel.searchLong
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.navigationController?.popViewController(animated: true)
            }
        }else{
            SwiftLoader.show(animated: true)
            viewModel.findACL { status, message in
                DispatchQueue.main.async {
                    SwiftLoader.hide()
                    // set markers on map
                    if self.viewModel.hasLocalChapters == false{
                        if self.viewModel.searchLat != ""{
                            self.showError("No ACL found on searched location")

                        }else{
                            self.showError("No ACL found on your location")

                        }
                    }else{
                       
                    }
                    self.reloadMap()
                }
            }
        }
    }
    
    /// Setup map view
    func setupMap() {
        // map type
        mapView.mapType = .terrain
        
        // get lat long of current location
        guard let lat = LocationService.sharedInstance.current?.latitude, let long = LocationService.sharedInstance.current?.longitude  else {
            return
        }
        // set marker to current location
        viewModel.searchLat = "\(Double(lat))"
        viewModel.searchLong = "\(Double(long))"
        //setMarker(lat: lat, long: long, message: "", chapterType: 0, isFromNonresult: true, needanimation: true)
    }
    
    
    /// Relaod markers on map
    func reloadMap() {
        // check if acl found
        if viewModel.aclArray.count == 0 {
            if viewModel.searchLong != ""{
                needMarker = false
                setMarker(lat: Double(viewModel.searchLat)!, long: Double(viewModel.searchLong)!, message: "", chapterType: 0, isFromNonresult: true, needanimation: false)
            }
            if Singleton.sharedInstance.isEnterfromMyACL == true{
                Singleton.sharedInstance.isEnterfromMyACL = false
                Singleton.sharedInstance.userLatLonginMY_ACL["lat"] = viewModel.searchLat
                Singleton.sharedInstance.userLatLonginMY_ACL["lng"] = viewModel.searchLong
                navigationController?.popViewController(animated: true)
            }else{
                needMarker = false

                showError("No ACL found")
            }
            return
        }
        
        if viewModel.aclArray.count > 0{
            self.needMarker = true
        }
        
        for acl in viewModel.aclArray {
            guard let lat = acl.latitude, let latValue = Double(lat), let long = acl.longitude, let longValue = Double(long)  else {
                return
            }
            // set markers
            setMarker(lat: latValue, long: longValue, message: acl.name, chapterType: acl.chapterType?.rawValue ?? 0, isFromNonresult: false, needanimation: false)
        }
        
        
        if viewModel.hasLocalChapters{
            let lat =  Double(self.viewModel.searchLat)
            let long =  Double(self.viewModel.searchLong)
            let camera = GMSCameraPosition.camera(withLatitude: lat ?? 0 , longitude: long ?? 0, zoom: 10.0)
            self.mapView.camera = camera
        }else{
            if viewModel.searchLong != ""{
                needMarker = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.setMarker(lat: Double(self.viewModel.searchLat)!, long: Double(self.viewModel.searchLong)!, message: "", chapterType: 0, isFromNonresult: true, needanimation: true)
                }
            }
        }
        
    }
    
    /// Move to original map position
    @objc func moveToOriginalLocation() {
        // get lat long of last location
//        guard let lat = viewModel.searchLat, let latValue = Double(lat), let long = viewModel.searchLong, let longValue = Double(long)  else {
//            return
//        }
        guard let lat = LocationService.sharedInstance.current?.latitude, let long = LocationService.sharedInstance.current?.longitude  else {
            return
        }
        // set marker to current location
        viewModel.searchLat = "\(Double(lat))"
        viewModel.searchLong = "\(Double(long))"
        
        
        // set camera to location
        mapView.camera = GMSCameraPosition.camera(withLatitude: Double(viewModel.searchLat) ?? 0 , longitude: Double(viewModel.searchLong) ?? 0, zoom: 10.0)
    }
    // Set markers with message
    func setMarker(lat: Double, long: Double, message: String?,chapterType : chapterTypes.RawValue,isFromNonresult :Bool,needanimation:Bool)  {
        // set camera
        let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long, zoom: 10.0)
//        mapView.camera = camera
        //set marker
        if needanimation{
            mapView.animate(to: camera)
            mapView.camera = camera
        }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        
        DispatchQueue.main.async {
            if isFromNonresult{
                marker.snippet = nil
            }else{
                marker.snippet = "click for full chapter info"
            }
            marker.map = self.mapView
            marker.icon = UIImage(named: "Search_result_pin")
            if #available(iOS 13.0, *) {
                if isFromNonresult{
                    marker.icon = GMSMarker.markerImage(with: .systemRed)
    //1=private,0=public,2=ghost
                }else{
                    if chapterType == 1{
                        marker.icon = GMSMarker.markerImage(with: UIColor.colorFromHex("00BFFF"))
                    }else if chapterType == 0{
                        marker.icon = GMSMarker.markerImage(with: AppTheme.lightDullPurple)
                    }else if chapterType == 2{
                        marker.icon = GMSMarker.markerImage(with: UIColor.colorFromHex("00BFFF"))
                    }else{
                        marker.icon = GMSMarker.markerImage(with: AppTheme.lightBlue)
                        
                    }
                }
            
                
            } else {
                // Fallback on earlier versions
            }
        }
       
        if needMarker == true{
            mapView.selectedMarker = marker

        }
    }
    
    

    
    
     @IBAction func CountryFieldDidSelect(_ sender: UITextField) {
           sender.resignFirstResponder()
           
           if let vc = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "SearchLocationController") as? SearchLocationController {
               vc.delegate = self
               self.navigationController?.pushViewController(vc, animated: true)
           }
       }
}

extension FindACLNearMeController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // get selected acl
        let filter = viewModel.aclArray.filter { acl -> Bool in
            // match lat long
            if let lat = acl.latitude, Double(lat) == marker.position.latitude,
                let long = acl.longitude, Double(long) == marker.position.longitude {
                return true
            }
            return false
        }
        //get acl id
        guard let selectedACL = filter.first, let ACLId = selectedACL.id else {
            return
        }
        // update selected id
        viewModel.selectedACLId = ACLId
    
        //move to description view
        if let mapLocationDetailController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "MapLocationDetailController") as? MapLocationDetailController {
            // pass viewModel
            mapLocationDetailController.viewModel = viewModel
            self.navigationController?.pushViewController(mapLocationDetailController, animated: true)
        }
        
    }
    
}

extension FindACLNearMeController: SearchLocationControllerDelegate {
    func placeSelected(_ place: GMSPlace) {
        // get city name
        if let name = place.name {
            viewModel.searchCityName = name
        } else if let cityName = place.addressComponents?.first(where: { $0.type == "city" })?.name {
            debugPrint("city -> \(cityName)")
            viewModel.searchCityName = cityName
        } else if let localityName = place.addressComponents?.first(where: { $0.type == "locality" })?.name {
            debugPrint("localityName -> \(localityName)")
            viewModel.searchCityName = localityName
        }
        // get country code
        if let country = place.addressComponents?.first(where: { $0.type == "country" })?.name {
            debugPrint("country -> \(country)")
            viewModel.searchCountryName = country
        }
        // get coordinates
        debugPrint("coordinate -> \(place.coordinate)")
                
        viewModel.searchLat = "\(place.coordinate.latitude)"
        viewModel.searchLong = "\(place.coordinate.longitude)"
        
        if let postal_code = place.addressComponents?.first(where: { $0.type == "postal_code" })?.name {
            debugPrint("postal_code -> \(postal_code)")
            viewModel.searchZipcode = postal_code
        }
        let address = place.formattedAddress
        if Singleton.sharedInstance.isEnterfromMyACL == true{
            Singleton.sharedInstance.userLatLonginMY_ACL["address"] = address
        }
        
        self.mapView.clear()
        self.reloadData()
    }
}
