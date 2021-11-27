//
//  ViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import CircleProgressView
import AVFoundation
import AVKit

class MainViewController: BaseViewController {
    @IBOutlet weak var joinLiveButton: DefaultDoneButton!
    @IBOutlet weak var registerForEventButton: DefaultDoneButton!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var daysLbl: UILabel!
    @IBOutlet weak var secondsLbl: UILabel!
    @IBOutlet weak var minutesLbl: UILabel!
    @IBOutlet weak var hoursLbl: UILabel!
    @IBOutlet weak var dayView: CircleProgressView!
    @IBOutlet weak var hourView: CircleProgressView!
    @IBOutlet weak var minuteView: CircleProgressView!
    @IBOutlet weak var secondView: CircleProgressView!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var countDownLbl: UILabel!
    
    let viewModel = MainViewModel()
    let settingViewModel = AppSettingsViewModel()

    var releaseDate: NSDate?
    var countdownTimer = Timer()
    var player: AVPlayer?
    var layer : AVPlayerLayer = AVPlayerLayer()
    var videoView = UIView()
    var welcomeLbl = UILabel()
    
    let learnText = " Awareness, Courage and Love Global Project meetings provide experiences centered on exploring ourselves and others in a meaningful way and teaches the 'how' of creating extraordinary interactions intentionally.\n\nHere in the Living ACL app, you can have those experiences whenever you like - whether you live near an ACL Chapter, missed a meeting, or simply want to supplement ACL in between group meetings.  Please Explore and Enjoy!. \n\nStar icon = save to favorites. \n\nItems that Guests don't have: Favorites, ability to post in Thought Garden, ability to join Live Events, Journal access, Start your own ACL"                                                                                                                                                                                                                         
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup view
        self.timerView.isHidden = true
        self.countDownLbl.isHidden = true
        setup()
        // get current location
        LocationService.sharedInstance.startUpdatingLocation()
        LocationService.sharedInstance.isLocateSuccess = false
        LocationService.sharedInstance.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLightStatusBar()
        setupGardenEntrance()
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setDarkStatusBar()
    }
    
    func setup() {
        joinLiveButton.applyGradient(colours: [AppTheme.darkPurple, AppTheme.lightPurple])
        registerForEventButton.applyGradient(colours: [AppTheme.lightGreen, AppTheme.lightGreen])
        registerForEventButton.addTarget(self, action: #selector(registerForEventBtnAction), for: .touchUpInside)
    }
    
    func getData(){
        // get data
        SwiftLoader.show(animated: true)
        viewModel.getData { status, message in
            DispatchQueue.main.async {
                SwiftLoader.hide()
                
//                self.quoteLabel.text = self.viewModel.quote?.quote
                UIView.animate(withDuration: 0.5) {
                    self.quoteLabel.attributedText = self.setAttributedString(quote: self.viewModel.quote?.quote ?? "", author: self.viewModel.quote?.author ?? "")

                } completion: { (done) in
                    //
                }

//                self.quoteLabel.attributedText = self.setAttributedString(quote: self.viewModel.quote?.quote ?? "", author: self.viewModel.quote?.author ?? "")
                
                
                
                
                if self.viewModel.event?.event_date != nil{
                    let timestamp = Date().timeIntervalSince1970
                    let timeInDouble = Double(timestamp)
                    
                    let incomingStamp = self.viewModel.event?.event_date
                    print("here is timestamp-->>> current is \(timeInDouble) and incoming timestamp is \(incomingStamp)")
                    if incomingStamp ?? 0.0 > timeInDouble{
                        self.timerView.isHidden = false
                        self.countDownLbl.isHidden = false
                        self.startTimer(timeStamp: self.viewModel.event?.event_date ?? 0.0)
                    }else{
                        self.timerView.isHidden = true
                        self.countDownLbl.isHidden = true
                    }
                    
                    
                }else{
                    self.timerView.isHidden = true
                    self.countDownLbl.isHidden = true

                }
                if self.viewModel.quote?.isFavorite ?? false{
                self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
            }else{
                self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
                }
            }
        }
        
        settingViewModel.getSettings { (issuccess, msg) in
            print("get settings")
        }
        
    }
    
    


    
    func startTimer(timeStamp : Double) {
        let newDate =  Date(timeIntervalSince1970: timeStamp)
        var releaseDateString = ""
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.timeZone = TimeZone(abbreviation: "PST")
        releaseDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        releaseDateString = releaseDateFormatter.string(from: newDate)
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate
//        releaseDate = getCurrentDateIn(timeZone: "PST", newDate: newDate)! as NSDate
//        releaseDate = self.getCurrentDateIn(timeZone: "PST",newDate: newDate) as NSDate?
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        print("here is release date ::",releaseDate as Any)
        print("here is local time--",self.getCurrentDateIn(timeZone: TimeZone.current.abbreviation()!, newDate: newDate) as Any)
        print("here is pst time---->>>",self.getCurrentDateIn(timeZone: "PST", newDate: newDate) as Any)
    }
    


    @objc func updateTime() {
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        daysLbl.text = "\(diffDateComponents.day ?? 0)"
        hoursLbl.text = "\(diffDateComponents.hour ?? 0)"
        minutesLbl.text = "\(diffDateComponents.minute ?? 0)"
        secondsLbl.text = "\(diffDateComponents.second ?? 0)"
        let hourProgress = Double(diffDateComponents.hour ?? 0)
        let dayProgress = Double(diffDateComponents.day ?? 0)
        setupTimerView(circle: hourView, progress: hourProgress / 100)
        setupTimerView(circle: dayView, progress: dayProgress / 100)
    }

    func setupTimerView(circle : CircleProgressView, progress : Double){
        circle.setProgress(progress, animated: true)
    }
    
    
    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Alert!", message: "Are you sure want to logout?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
            DataManager.shared.clear()
            self.gotoLoginViewController()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
       
    }
    
    @IBAction func dailyMedication(_ sender: Any) {
        if let dailyMeditationViewController = UIStoryboard(name: "Meditation", bundle: nil).instantiateViewController(withIdentifier: "DailyMeditationViewController") as? DailyMeditationViewController {
            self.navigationController?.pushViewController(dailyMeditationViewController, animated: true)
        }
    }
    
    @IBAction func gardenAction(_ sender: Any) {
       // playVideo()
        initializeVideoPlayerForGarden()
        
       
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.videoView.frame = view.frame
        self.layer.frame = videoView.bounds
    }
    

    @objc func skipBtnTap(_ sender : UIButton){
//        if AudioPlayer.shared.isPlaying {
//                  AudioPlayer.shared.pause()
//              }
        if ((self.player?.isPlaying) != nil){
            self.player?.pause()
        }
        NotificationCenter.default.removeObserver(self)
        self.videoView.isHidden = true
        self.videoView.removeFromSuperview()
        if let thoughtGardenViewController = UIStoryboard(name: "ThoughtGarden", bundle: nil).instantiateViewController(withIdentifier: "QuestionOfWeekViewController") as? QuestionOfWeekViewController {
            self.navigationController?.pushViewController(thoughtGardenViewController, animated: false)
        }

    }
    
  
    
    func initializeVideoPlayerForGarden() {
        self.player?.play()
        NotificationCenter.default.addObserver(self, selector: #selector(animateFinish(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        
        let skipBtn = UIButton()
        skipBtn.frame = CGRect(x: self.view.frame.width - 70, y: 32, width: 70, height: 42)
        skipBtn.setTitle("Skip", for: .normal)
        //FFFF00
        skipBtn.setTitleColor(UIColor.colorFromHex("FFFF00"), for: .normal)
        skipBtn.addTarget(self, action: #selector(skipBtnTap(_:)), for: .touchUpInside)
        self.videoView.addSubview(skipBtn)

        welcomeLbl.text = "Welcome to the Thought Garden"
        self.welcomeLbl.frame = CGRect(x: 0, y: view.frame.origin.y, width: view.frame.width, height: 60)
        self.welcomeLbl.center = videoView.center
        self.welcomeLbl.font = UIFont(name: "Bodoni 72", size: 27)
        self.welcomeLbl.textColor = .white
        self.welcomeLbl.textAlignment = .center
        self.videoView.addSubview(welcomeLbl)
        self.welcomeLbl.alpha = 0
        UIView.transition(with: self.videoView, duration: 2,options: .transitionCrossDissolve,animations: {
            self.videoView.isHidden = false
            self.welcomeLbl.fadeIn(){_ in
                self.welcomeLbl.fadeOut()
            }
        })
    }
    
    
    @objc func animateFinish(note: NSNotification){
        if AudioPlayer.shared.isPlaying {
                  AudioPlayer.shared.pause()
              }
        if ((self.player?.isPlaying) != nil){
            self.player?.pause()
        }
        NotificationCenter.default.removeObserver(self)
        self.videoView.isHidden = true
        self.videoView.removeFromSuperview()
        if let thoughtGardenViewController = UIStoryboard(name: "ThoughtGarden", bundle: nil).instantiateViewController(withIdentifier: "ThoughtGardenViewController") as? ThoughtGardenViewController {
            self.navigationController?.pushViewController(thoughtGardenViewController, animated: false)
        }
    }
    
    func setupGardenEntrance(){
        
      let videoString:String? = Bundle.main.path(forResource: "Garden_Gates Animat", ofType:"mp4")
         guard let unwrappedVideoPath = videoString else {
            print("file not supported")
            return
        }
         let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
         self.player = AVPlayer(url: videoUrl)
        layer.player = player
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.videoView.layer.addSublayer(self.layer)
        view.addSubview(videoView)
        videoView.isHidden = true
    }
    
    @IBAction func inviteFriend(_ sender: Any) {
        self.inviteFriend()
    }
    
    @IBAction func findACL(_ sender: Any) {
        if let findACLNearMeController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "FindACLNearMeController") as? FindACLNearMeController {
            self.navigationController?.pushViewController(findACLNearMeController, animated: true)
        }
    }
    
    @IBAction func ACLNewsAction(_ sender: Any) {
        if let newsViewController = UIStoryboard(name: "News", bundle: nil).instantiateViewController(withIdentifier: "NewsViewController") as? NewsViewController {
            self.navigationController?.pushViewController(newsViewController, animated: true)
        }
    }
    
    @IBAction func learnAbout(_ sender: UIButton) {
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = self.learnText
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }

    }
    @IBAction func WeeklyChallengeAction(_ sender: Any) {
        if let weeklyChallengeViewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallengeViewController") as? WeeklyChallengeViewController {
            self.navigationController?.pushViewController(weeklyChallengeViewController, animated: true)
        }
    }
    
    @IBAction func MyACLAction(_ sender: Any) {
        if let myACLViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "MyACLViewController") as? MyACLViewController {
            self.navigationController?.pushViewController(myACLViewController, animated: true)
        }
    }
    
    @objc func registerForEventBtnAction(){
        //register for event btn action
        
        if let myACLViewController = UIStoryboard(name: "EnrollStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RegisterEventEnrollViewController") as? RegisterEventEnrollViewController {
            myACLViewController.isFromLiveEvent  = false
            self.navigationController?.pushViewController(myACLViewController, animated: true)
        }
    }
    @IBAction func favButtonAction(_ sender: UIButton) {
               SwiftLoader.show(animated: true)
        viewModel.addFavourite { status, message in
            guard status else {
                self.showError(message)
                return
            }
            SwiftLoader.hide()
            if self.favButton.imageView?.image == UIImage(named: "main_screen_star"){
                self.favButton.setImage(UIImage(named: "silverStar"), for: .normal)
                }else{
                self.favButton.setImage(UIImage(named: "main_screen_star"), for: .normal)
            }
        }
       
        
    }
    @IBAction func joinLiveEvntBtn(_ sender: DefaultDoneButton) {
        if let myACLViewController = UIStoryboard(name: "EnrollStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RegisterEventEnrollViewController") as? RegisterEventEnrollViewController {
            myACLViewController.isFromLiveEvent  = true
                   self.navigationController?.pushViewController(myACLViewController, animated: true)
               }
//        UIPasteboard.general.string = "www.google.com"
//        self.showToast(message: "Link copied!", font: AppFont.get(.medium, size: 16))

    }
    
    @IBAction func messageBtn(_ sender: UIButton) {
        openwebLink(controller: self, link: "https://forms.gle/7pzDLq8aS2m7XffY7")
        
    }
}
extension MainViewController: LocationServiceDelegate{
    func getAddressForLocation(locationAddress: String, currentAddress: [String : Any]) {
        print("current address is ,,", currentAddress)
    }
    
}



//favtype --->>
//Quotes = 1
//question of the week = 2
//Garden post = 3
//Meditation = 4
//Journal entry = 5
//Excercise = 6
//Video = 7
//Articles = 8
//Contacts = 9
//Acl groups = 10
