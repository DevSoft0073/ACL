//
//  VideoUploadViewController.swift
//  ACL
//
//  Created by zapbuild on 31/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import Photos

class VideoUploadViewController: BaseViewController {
    @IBOutlet private weak var continueButton: UIButton!
    @IBOutlet private weak var videoPreviewImageView: UIImageView!
    @IBOutlet private weak var videoPreview: UIView!
    @IBOutlet private weak var recordingButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
    }

    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
            self.recordingButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
            self.playPauseButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
            self.continueButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        }
    }
    
    //MARK:- Button Actions
    @IBAction private func backToMainAction(_ sender: UIButton) {
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
    
    @IBAction private func videoRecordingAction(_ sender: UIButton) {
        openCamera()
    }
    
    @IBAction private func continueAction(_ sender: UIButton) {
        if let agreementFormViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeaderShipAgreementViewController") as? LeaderShipAgreementViewController{
            self.navigationController?.pushViewController(agreementFormViewController, animated: true)
        }
    }
    
    @IBAction private func playPauseAction(_ sender: UIButton) {
        
    }
    
    @IBAction private  func backToACLAction(_ sender: UIButton) {
        
    }
}

//MARK:- Image picker delegates
extension VideoUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
           if  let  videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL{
                
            }
        }
        
    }
    
    func openCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self]response in
            guard let self = self else{return}
            DispatchQueue.main.async {
                if response {
                       self.openGalleryCamera(sourceType: .camera, mediaTypes: ["public.movie"])
                } else {
                    self.settingsAlert(title: "Tap on Settings", message: "ACL needs access to your Camera to capture photo.")
                }
            }
        }
    }

    func openGalleryCamera(sourceType: UIImagePickerController.SourceType,mediaTypes: [String]){
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               imagePicker.delegate = self
               imagePicker.sourceType = sourceType
               imagePicker.mediaTypes = mediaTypes
               imagePicker.allowsEditing = true
               self.present(imagePicker, animated: true, completion: nil)
           }
       }
    
   
}
