
//  DailyMeditationViewController.swift
//  ACL
//
//  Created by RGND on 20/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit

class DailyMeditationViewController: BaseViewController {

    @IBOutlet weak var pauseSegment: TTSegmentedControl!
    @IBOutlet weak var restartSegment: TTSegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var learnAbtBtn: UIButton!
    
    @IBOutlet weak var backgrounPicView: UIView!
    @IBOutlet weak var selectSoundBtn: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var selectSoundView: UIView!
    @IBOutlet weak var backgroundSoundView: UIView!
    
    @IBOutlet weak var timeLbl: UILabel!
    var backGroundImageEnabled: Bool = true
    var backGroundSoundEnabled: Bool = true
    
    let viewModel = DailyMeditationViewModel()
    var isFromLibraryMeditation = false
    var dataFromLibrary = [String :Any]()
    var isFromCatChange = false
    var timerr : Timer?
    var isFromPauseRestart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSegments()
        setRestartSegments()
        Singleton.sharedInstance.isNeedPlayback = true
        self.timeLbl.isHidden = true
        self.showAudioTime()
        //main_screen_star
        //MyACL_favoritess
        // enable sound and image in initial
        soundButton.isSelected = true
        pictureButton.isSelected = false
        backGroundImageEnabled = false
        favouriteBtn.setImage(UIImage(named: "silverStar"), for: .normal)
        //playerRestarted
        NotificationCenter.default.addObserver(self, selector: #selector(self.playerAutoRestarted), name: NSNotification.Name(rawValue: "playerRestarted"), object: nil)
        // load data
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification
                    , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.didBecomeActiveNotification
                    , object: nil)


        if isFromLibraryMeditation == true{
            SwiftLoader.show(animated: true)
            viewModel.meditation = Meditation(dataFromLibrary)
            if let categories = dataFromLibrary["category"] as? [[String: Any]] {
                for category in categories {
                    viewModel.customeMeditations.append(Meditation(category))
                }
                viewModel.meditation?.isFavorite = dataFromLibrary["isFavorite"] as? String
            }
            self.getCustomsound()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reloadView()
                SwiftLoader.hide()
            }
        }else{
            SwiftLoader.show(animated: true)
                  viewModel.getMedications { status, message in
                      SwiftLoader.hide()
                    self.getCustomsound()
                      guard status else {
                          self.showError(message)
                          return
                      }
                      self.reloadView()
                  }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if pauseSegment.currentIndex == 0{
            if AudioPlayer.shared.isPlaying {
                      AudioPlayer.shared.pause()
                  }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        if !backGroundSoundEnabled{
//            if AudioPlayer.shared.isPlaying {
//                      AudioPlayer.shared.pause()
//                  }
//        }
        if backGroundSoundEnabled{

        
        
        
        let isSoundSelected = UserDefaults.standard.bool(forKey: isSoundSelected_key)
        Singleton.sharedInstance.isSoundSelected = isSoundSelected
        if Singleton.sharedInstance.isSoundSelected{
            if AudioPlayer.shared.isPlaying == false{
                let soundUrl = UserDefaults.standard.value(forKey: selectedSoundURL_Key)
                Singleton.sharedInstance.selectedSoundName = UserDefaults.standard.value(forKey: selectedSoundName_Key) as? String ?? ""
                Singleton.sharedInstance.selectedSoundURL = soundUrl as? String ?? ""
                let url = URL(string: Singleton.sharedInstance.selectedSoundURL)!
                AudioPlayer.playItem(at: url)
//                self.selectSoundBtn.setTitle(Singleton.sharedInstance.selectedSoundName, for: .normal)
            }
        }else{
            if AudioPlayer.shared.isPlaying{
                AudioPlayer.shared.pause()
            }
        }
        }else{
            if AudioPlayer.shared.isPlaying{
                AudioPlayer.shared.pause()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.backGroundSoundEnabled = Singleton.sharedInstance.backgroundSettingisOn
        let isSoundSelected = UserDefaults.standard.bool(forKey: isSoundSelected_key)
        Singleton.sharedInstance.isSoundSelected = isSoundSelected
        if Singleton.sharedInstance.isSoundSelected{
            if AudioPlayer.shared.isPlaying == false{
                let soundUrl = UserDefaults.standard.value(forKey: selectedSoundURL_Key)
                Singleton.sharedInstance.selectedSoundName = UserDefaults.standard.value(forKey: selectedSoundName_Key) as? String ?? ""
                Singleton.sharedInstance.selectedSoundURL = soundUrl as? String ?? ""
                if backGroundSoundEnabled{
                    let url = URL(string: Singleton.sharedInstance.selectedSoundURL)!
                    AudioPlayer.playItem(at: url)
                    self.selectSoundBtn.setTitle(Singleton.sharedInstance.selectedSoundName, for: .normal)
                }
            }
        }else{
//            if let defaultSound = UserDefaults.standard.value(forKey: "defaultSound") as? String{
//                let url = URL(string: defaultSound)
//                AudioPlayer.playItem(at: url!)
//            }
        }
        
        if AudioPlayer.shared.isPlaying {
            pauseSegment.selectItemAt(index: 1, animated: true)
        }else{
            pauseSegment.selectItemAt(index: 0, animated: true)

        }
    }
    
    @objc func playerAutoRestarted(){
        AudioPlayer.shared.volume = 1
        //selectedSoundName_Key
        let name = UserDefaults.standard.value(forKey: selectedSoundName_Key) as? String ?? ""
        self.selectSoundBtn.setTitle(name, for: .normal)
        self.showAudioTime()
    }
    
    @objc func applicationWillEnterForeground(_ notification: NSNotification) {
        if AudioPlayer.shared.isPlaying {
            pauseSegment.selectItemAt(index: 1, animated: true)
        }else{
            pauseSegment.selectItemAt(index: 0, animated: true)

        }
    }
    
    
    func getCustomsound(){
        SwiftLoader.show(animated: true)
        viewModel.getCustomMeditationSounds { (status, msg) in
            SwiftLoader.hide()
            guard status else {
                self.showError(msg)
                return
            }
            
        }
    }
    
    func reloadView() {
//        if backGroundSoundEnabled, let urlString = viewModel.meditation?.backgroundSound, let url = URL(string: urlString) {}
        Singleton.sharedInstance.currentAuthor = self.viewModel.meditation?.authorName ?? ""

        if let urlString = viewModel.meditation?.backgroundSound, let url = URL(string: urlString) {
//            if isFromCatChange == true{
//                let url = URL(s)
//                MusicPlayer.instance.playAudioWithUrl(url: urlString)
//                Singleton.sharedInstance.currentAuthor = self.viewModel.meditation?.authorName ?? ""
            if !Singleton.sharedInstance.isSoundSelected{
                if isFromCatChange == true{
                    AudioPlayer.playItem(at: url)
                    self.showAudioTime()

                }else{
                    if AudioPlayer.shared.isPlaying == false{
//                        AudioPlayer.playItem(at: url)
//                        self.showAudioTime()

                    }
                }
            }
                
//            }else{
//                self.pauseSegment.selectItemAt(index: 0)
//            }
            if AudioPlayer.shared.isPlaying{
                self.pauseSegment.selectItemAt(index: 1, animated: false)
            }
//            self.selectSoundView.isHidden = false
            self.selectSoundView.hideWithAnimation(hidden: false)
        }else{
//            self.selectSoundView.isHidden = true
            self.selectSoundView.hideWithAnimation(hidden: true)


        }
        
//        if backGroundImageEnabled, let backgroundImage = viewModel.meditation?.backgroundImage {
//            backGroundImageView.sd_setImage(with: URL(string: backgroundImage), placeholderImage: UIImage(named: "Daily maditation background"), completed: nil)
//        }
        backGroundImageView.image = UIImage(named: "5. meditation bckgrd 1 shutterstock_525011896")
        if let isFavorite = viewModel.meditation?.isFavorite{
            if isFavorite == "0"{
                favouriteBtn.setImage(UIImage(named: "silverStar"), for: .normal)
            }else{
                favouriteBtn.setImage(UIImage(named: "main_screen_star"), for: .normal)
            }
        }
        // reload collection data
        self.collectionView.reloadData()
        
        
    }
    
    func showAudioTime(){
        Singleton.sharedInstance.currentAuthor = self.viewModel.meditation?.authorName ?? ""
//        Singleton.sharedInstance.currentTitle = self.viewModel.meditation?.categoryName ?? ""
//        self.timeLbl.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if AudioPlayer.shared.isPlaying{
                
                self.pauseSegment.selectItemAt(index: 1, animated: true)
                self.timeLbl.isHidden = false
                self.timerr =  Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            }else{
                self.timerr?.invalidate()
                self.timeLbl.isHidden = true
            }
        }
    }
    
    @objc func updateTime(){
        let currentItem = AudioPlayer.shared.currentItem
    let tym = currentItem?.currentTime().seconds
    let pendingSeconds = Int(currentItem?.asset.duration.seconds ?? 0) - Int(tym!)

        if pendingSeconds != 0{
            let pendingTime = self.getHoursMinutesSecondsFrom(seconds: Double(pendingSeconds))
            DispatchQueue.main.async {
                let str = String.init(format: "%02d:%02d", pendingTime.minutes,pendingTime.seconds)
                self.timeLbl.text = str
                if pendingTime.seconds < 6 && pendingTime.minutes == 0{
                    switch pendingTime.seconds {
                    case 5:
                        AudioPlayer.shared.volume = 0.5
                        break
                    case 4:
                        AudioPlayer.shared.volume = 0.3

                        break
                        
                    case 3:
                        AudioPlayer.shared.volume = 0.2

                        break
                    case 2:
                        AudioPlayer.shared.volume = 0.1

                        break
                    case 1:
                        AudioPlayer.shared.volume = 0

//                        AudioPlayer.shared.pause()
//                        self.timerr?.invalidate()
//                        if let defaultSound = UserDefaults.standard.value(forKey: "defaultSound") as? String{
//                            let url = URL(string: defaultSound)
//                            AudioPlayer.playItem(at: url!)
//                            self.showAudioTime()
//                            self.selectSoundBtn.setTitle("Select your sound", for: .normal)
//                            Singleton.sharedInstance.isSoundSelected = false
//                            UserDefaults.standard.setValue(false, forKey: isSoundSelected_key)
//                            AudioPlayer.shared.volume = 1
//                        }
                        

                        break
                    default:
                        //AudioPlayer.shared.volume = 1
                        print("finish")
                        //
                    }
                }
            }
        }else{
            self.timerr?.invalidate()
            self.timeLbl.text = ""
            self.timeLbl.isHidden = true
        }
    }
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func setSegments() {
        pauseSegment.allowChangeThumbWidth = false
        pauseSegment.itemTitles = ["Pause","Start"]
        pauseSegment.defaultTextFont = AppFont.get(.regular, size: 16)
        pauseSegment.selectedTextFont = AppFont.get(.regular, size: 16)
        pauseSegment.thumbBorderWidth = 1
        pauseSegment.thumbBorderColor = .white
        pauseSegment.thumbGradientColors = [AppTheme.darkPurple, AppTheme.lightPurple]
        pauseSegment.useGradient = true
        pauseSegment.didSelectItemWith = { (index, title) -> () in
            print("Selected item \(index)")
            
            // check if pause tapped
            if index == 0 {
                // pause
                self.isFromPauseRestart = true
                if AudioPlayer.shared.isPlaying {
                    AudioPlayer.shared.pause()
                    self.showAudioTime()
                }
            } else {
                // play if background sound enabled
                if self.isFromPauseRestart{
                    self.isFromPauseRestart = false
                    AudioPlayer.shared.play()
                     self.showAudioTime()
                }else{
                    if self.backGroundSoundEnabled{
                        if let urlString = self.viewModel.meditation?.backgroundSound, let url = URL(string: urlString) {
                                  AudioPlayer.playItem(at: url)

                            self.showAudioTime()
                              }
                    }else{
                        self.pauseSegment.selectItemAt(index: 0, animated: true)
                        self.showError("To play the sound it should turn on from setting screen")
                    }
                }
            }
        }
        // set to play intially
        pauseSegment.selectItemAt(index: 1, animated: true)
        backgrounPicView.isHidden = true
        backgroundSoundView.isHidden = true
    }
    
    func setRestartSegments() {
        restartSegment.allowChangeThumbWidth = false
        restartSegment.itemTitles = ["Restart","Continue"]
        restartSegment.defaultTextFont = AppFont.get(.regular, size: 15)
        restartSegment.selectedTextFont = AppFont.get(.regular, size: 15)
        restartSegment.thumbBorderWidth = 1
        restartSegment.thumbBorderColor = .white
        restartSegment.thumbGradientColors = [AppTheme.darkPurple, AppTheme.lightPurple]
        restartSegment.useGradient = true
        
        restartSegment.didSelectItemWith = { (index, title) -> () in
            print("Selected item \(index)")
            // background sound should be enabled
//            guard self.backGroundSoundEnabled else {
//                // keep it to continue
//                self.restartSegment.selectItemAt(index: 1, animated: true)
//                return
//            }
            // check if restart tapped
            if index == 0 {
                self.restartSegment.selectItemAt(index: 0, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    // restart audio
                    
                    
                    // Change buttons index to Play and continue
                    self.restartSegment.selectItemAt(index: 1, animated: true)
                    if AudioPlayer.shared.isPlaying{
                        AudioPlayer.restart()
                        self.pauseSegment.selectItemAt(index: 1, animated: true)
                    }else{
                        AudioPlayer.justSetInitialTime()
                    }
                })
            }
            self.showAudioTime()
        }
        // set to continue intially
        restartSegment.selectItemAt(index: 1)
    }
    
    @IBAction func learnAboutBtn(_ sender: UIButton) {
        let alert = UIAlertController(title: "Meditation", message: "About this feature", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func backAction(_ sender: Any) {
//        if AudioPlayer.shared.isPlaying {
//            AudioPlayer.shared.pause()
//        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func soundAction(_ sender: Any) {
        self.soundButton.isSelected = !soundButton.isSelected
        self.backGroundSoundEnabled = self.soundButton.isSelected
        Singleton.sharedInstance.isNeedPlayback = self.backGroundSoundEnabled
//        if  let urlString = viewModel.meditation?.backgroundSound, let url = URL(string: urlString) {
//            // play
//            if let urlString = viewModel.meditation?.backgroundSound, let url = URL(string: urlString){
//                AudioPlayer.playItem(at: url)
//            }
//           // AudioPlayer.shared.play()
//            // change segment to play
//            pauseSegment.selectItemAt(index: 1, animated: true)
//            // change segment to play
//            self.restartSegment.selectItemAt(index: 1, animated: true)
////            self.selectSoundView.isHidden = false
//            self.selectSoundView.hideWithAnimation(hidden: false)
//
//
//        } else {
//            AudioPlayer.shared.pause()
//            self.showAudioTime()
//            pauseSegment.selectItemAt(index: 0, animated: true)
//            // change segment to play
//            self.restartSegment.selectItemAt(index: 1, animated: true)
////            self.selectSoundView.isHidden = true
//            self.selectSoundView.hideWithAnimation(hidden: true)
//
//        }
    }
    
    @IBAction func pictureAction(_ sender: Any) {
        self.pictureButton.isSelected = !pictureButton.isSelected
        backGroundImageEnabled = self.pictureButton.isSelected
        
        if backGroundImageEnabled, let backgroundImage = viewModel.meditation?.backgroundImage {
            backGroundImageView.sd_setImage(with: URL(string: backgroundImage), placeholderImage: getBackgroundImage(), completed: nil)
        } else {
            // set default image
            backGroundImageView.image = getBackgroundImage()
        }
    }
    
    @IBAction func favouriteAction(_ sender: Any) {
        SwiftLoader.show(animated: true)
        viewModel.addFavourite { status, message in
            guard status else {
                self.showError(message)
                return
            }
            SwiftLoader.hide()

            if self.favouriteBtn.imageView?.image == UIImage(named: "main_screen_star"){
                self.favouriteBtn.setImage(UIImage(named: "silverStar"), for: .normal)
                }else{
                self.favouriteBtn.setImage(UIImage(named: "main_screen_star"), for: .normal)
            }
        }

    }
    
    @IBAction func chooseYourOwnAction(_ sender: Any) {
        if let meditationArchivesController = UIStoryboard(name: "Meditation", bundle: nil).instantiateViewController(withIdentifier: "MeditationArchivesController") as? MeditationArchivesController {
            meditationArchivesController.viewModel = self.viewModel
            meditationArchivesController.delegate = self
            self.navigationController?.pushViewController(meditationArchivesController, animated: true)
        }
    }
    @IBAction func selectSoundAction(_ sender: UIButton) {
        
        if viewModel.customSound.count > 0{
            var strArray = [String]()
            for files in viewModel.customSound{
                strArray.append(files.name ?? "")
            }
            strArray.insert("None", at: 0)
           
            displayActionSheetWithCongratsVC(title: "Choose Audio", strArray) { (index, isCancel) in
                if isCancel == false{
                    if index == 0{
                        self.selectSoundBtn.setTitle("Select your sound", for: .normal)
                        Singleton.sharedInstance.isSoundSelected = false
                        //defaultSound
                        
                        UserDefaults.standard.setValue(false, forKey: isSoundSelected_key)
                                if AudioPlayer.shared.isPlaying {
                                    AudioPlayer.shared.pause()
                                    self.showAudioTime()
                                }

                    }else{
                        if self.backGroundSoundEnabled{
                            Singleton.sharedInstance.isSoundSelected = true
                            Singleton.sharedInstance.selectedSoundURL = self.viewModel.customSound[index - 1].backgroundSound ?? ""
                            UserDefaults.standard.setValue(true, forKey: isSoundSelected_key)
                            UserDefaults.standard.setValue(Singleton.sharedInstance.selectedSoundURL, forKey: selectedSoundURL_Key)
                            Singleton.sharedInstance.selectedSoundName = strArray[index]
                            UserDefaults.standard.setValue(Singleton.sharedInstance.selectedSoundName, forKey: selectedSoundName_Key)
                            self.selectSoundBtn.setTitle(strArray[index], for: .normal)
                            self.viewModel.meditation?.backgroundSound = self.viewModel.customSound[index - 1].backgroundSound
                            UserDefaults.standard.setValue(self.viewModel.meditation?.backgroundSound, forKey: "defaultSound")

                            let urlString = self.viewModel.meditation?.backgroundSound
                            Singleton.sharedInstance.currentTitle = self.viewModel.customSound[index - 1].name ?? ""
                            let url = URL(string: urlString ?? "")
                                AudioPlayer.playItem(at: url!)
                                self.showAudioTime()

                        }else{
                            self.showError("To play the sound it should turn on from setting screen")
                        }
                        

                    }

                }
                
            }
        }
      
        
    }
    
    
}

extension DailyMeditationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyMeditationsCollectionCell", for: indexPath) as? MyMeditationsCollectionCell {
            
            if indexPath.row == 0 {
                cell.titleLabel.text = "Author"
                if self.viewModel.meditation?.authorName == ""{
                    cell.nameLabel.text = "No author available"

                }else{
                    cell.nameLabel.text = self.viewModel.meditation?.authorName

                }
                cell.descriptionTextView.text = self.viewModel.meditation?.authorDescription
                
            } else {
                cell.titleLabel.text = "Reader"
                if self.viewModel.meditation?.readerName == ""{
                    cell.nameLabel.text = "No reader available"
                }else{
                cell.nameLabel.text = self.viewModel.meditation?.readerName
                }
                cell.descriptionTextView.text = self.viewModel.meditation?.readerDescription
            }
            
            return cell
        }
        
        return MyMeditationsCollectionCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 60)/2, height: collectionView.frame.height )
    }
    
}

extension DailyMeditationViewController: MeditationArchivesControllerDelegate {
    func meditationDidSelect(_ meditation: Meditation) {
        self.viewModel.meditation = meditation
        self.pauseSegment.selectItemAt(index: 1, animated: true)
        self.isFromCatChange = true
        self.selectSoundBtn.setTitle("Select your sound", for: .normal)
        Singleton.sharedInstance.currentAuthor = self.viewModel.meditation?.authorName ?? ""
        Singleton.sharedInstance.currentTitle = self.viewModel.meditation?.categoryName ?? ""
        Singleton.sharedInstance.isSoundSelected = false
      //  UserDefaults.standard.setValue(false, forKey: isSoundSelected_key)
        self.reloadView()
    }
}
