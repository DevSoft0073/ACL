//
//  VoiceRecorderViewController.swift
//  ACL
//
//  Created by Gagandeep on 12/07/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class VoiceRecorderViewController: BaseViewController {

    var recorder = KAudioRecorder.shared
    var fileName = "MyJournalRecording"
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recorder.delegate = self
        // set file name
        recorder.recordName = fileName
        // delete old file
        recorder.delete(name: fileName)
        
        saveButton.applyGradient(colours: [AppTheme.megenta, AppTheme.lightOrange])
        
        // disable buttons initially
        stopButton.disable()
        playButton.disable()
        deleteButton.disable()
        saveButton.disable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // check authentication
        if recorder.isAuth() {
            recordButton.enable()
        } else {
            recordButton.disable()
            showError("Audion recording permission is not granted. Please go to phone Settings and allow audio recording for ACL app")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // check if audio playing
        if recorder.isPlaying {
            // stop audio
            recorder.stopPlaying()
            // change state to start now
            playButton.isSelected = false
        }
    }

    @IBAction func record(_ sender: Any) {
        // disbale play
        playButton.disable()
        // disbale delete
        deleteButton.disable()
        // stop audio Playing
        if recorder.isPlaying {
            recorder.stopPlaying()
        }
        playButton.isSelected = false
        // enable stop button first
        stopButton.enable()
        
        // disable save
        saveButton.disable()
        
        // diable record button first
        recordButton.disable()
        // start recording
        recorder.record()
    }
    
    @IBAction func stop(_ sender: Any) {
        // stop recording
        if recorder.isRecording {
            recorder.stop()
        }
        // enable record again
        recordButton.enable()
        
        // enable play
        playButton.enable()
        
        // enable delete
        deleteButton.enable()
        
        // enable save
        saveButton.enable()
        
        // diable stop itself after some delay but if not recording at that time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if !self.recorder.isRecording {
                self.stopButton.disable()
            }
        }
    }
    
    @IBAction func play(_ sender: Any) {
        // check if already playing
        if recorder.isPlaying {
            // stop
            recorder.stopPlaying()
            // change state to start now
            playButton.isSelected = false
        } else {
            // start from starting
            recorder.play(name: fileName)
            // change state to pause
            playButton.isSelected = true
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        // check if already playing
        if recorder.isPlaying {
            // stop
            recorder.stopPlaying()
            // change state to start now
            playButton.isSelected = false
        }
        // delete file
        recorder.delete(name: fileName)
        
        // disbale play
        playButton.disable()
        
        //disable save
        saveButton.disable()
        
        // diable delete itself after some delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.deleteButton.disable()
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveEntryAction(_ sender: Any) {
        do {
            // get file data
            let data = try Data(contentsOf: recorder.getFileURL())
            // upload to server
            uploadFileToServer(data)
        }
        catch {
            
        }
    }
    
    func uploadFileToServer( _ data: Data) {
        if DataManager.shared.isGuestUser{
            return
        }
        let parameters = ["uid": DataManager.shared.userId!]
        let audioData = ["recording": data]
        
        // show loader
        SwiftLoader.show(animated: true)
        // upload
        CloudDataManager.shared.uploadRecordingFile(parameters, audioData: audioData) { status, message in
            // hide loader
            SwiftLoader.hide()
            // check status and disable if uploaded successfully
            if status {
                self.saveButton.disable()
            }
            // show message
            self.showError(message)
        }
    }

}

extension VoiceRecorderViewController: KAudioRecorderDelegate {
    
    func didRecordFinish() {
        
    }
    
    func didPlayFinish() {
        // change state to play again
        self.playButton.isSelected = false
    }
    
}
