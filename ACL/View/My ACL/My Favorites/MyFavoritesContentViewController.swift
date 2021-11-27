//
//  MyFavoritesContentViewController.swift
//  ACL
//
//  Created by Aman on 03/08/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit
import AVFoundation
import HCVimeoVideoExtractor

class MyFavoritesContentViewController: BaseViewController {
//MARK: Outlets
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var contentTableView: UITableView!
    
    var subTitle = ""
    var viewModal = FavoriteListModel()
    var titleModal = MyFavoritesViewModel()
    var player : AVPlayer?

    var audioView : AudioPlayerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subtitleLbl.text = subTitle
        registerNib()
        addAudioView()
        
        if subTitle == "Journal Entries"{
            SwiftLoader.show(animated: true)
            viewModal.getRecordingData { (IsSuccess, Str) in
                SwiftLoader.hide()
                self.contentTableView.reloadData()
                if self.viewModal.favList.count == 0{
                    self.showError("No Data Found") { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }else{
            SwiftLoader.show(animated: true)
            viewModal.getData(type: getType()) { (IsSuccess, Str) in
                SwiftLoader.hide()
                self.contentTableView.reloadData()
                if self.viewModal.favList.count == 0{
                    self.showError("No Data Found") { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }

        }
       
    }
    
    func addAudioView(){
        audioView = Bundle.main.loadNibNamed("AudioPlayerView", owner: self, options: nil)?.first as? AudioPlayerView
        audioView?.isHidden = true
        audioView?.frame = view.frame
        audioView?.animHide()
        view.addSubview(audioView!)
    }
    
    
    func getType() -> String{
        var str = ""
        switch subTitle{
          
        case "Quotes" :
            str = APIConstants.favType.Quotes
       case "Question of the week" :
        str = APIConstants.favType.question_ofthe_week
                           
        case "Thought Garden Posts" :
            str = APIConstants.favType.Garden_post
        case "Meditations":
            str = APIConstants.favType.Meditation
        case "Journal Entries":
            str = APIConstants.favType.Journal_entry
        case "Exercises":
            str = APIConstants.favType.Excercise
        case "Videos":
          str = APIConstants.favType.Video
        case "Articles":
          str = APIConstants.favType.Articles
        case "Contacts":
            str = APIConstants.favType.Contacts
        case "ACL Groups":
            str = APIConstants.favType.Acl_groups
            case "Weekly Challenges":
            str = APIConstants.favType.weekly_challenge
        default:
            str = ""
        }
        
        return str
    }
   
       
       
    
    //MARK: register nibs
    func registerNib(){
        contentTableView.register(UINib(nibName: "FavoriteContentCell", bundle: nil), forCellReuseIdentifier: "FavoriteContentCell")
        contentTableView.tableFooterView = UIView()
    }
    
//MARK: back button action
    @IBAction func backBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
        
        func playYoutubeVideo(str: String){
            let videoIdentifier = String(str.suffix(11))
            XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { (video, error) in
                if error == nil{
                      if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                        DispatchQueue.main.async{
                            let playerViewController = AVPlayerViewController()
                            playerViewController.player = AVPlayer(url: streamURL)
                            playerViewController.player?.play()
                            self.present(playerViewController, animated: true, completion: nil)
                        }
                        
                      }
                }else{
                    self.dismiss(animated: true)
                    print(error?.localizedDescription as Any)
                }
            }
        }
        
        
        func playVimeoVideo(videoUrl : String){
            let url = URL(string: videoUrl)!
                        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
                            if let err = error {
                                print("Error = \(err.localizedDescription)")
                                return
                            }
                            guard let vid = video else {
                                print("Invalid video object")
                                return
                            }
                            if let videoURL = vid.videoURL[.Quality720p] {
                                DispatchQueue.main.async {
                                    let playerViewController = AVPlayerViewController()
                                    playerViewController.player = AVPlayer(url: videoURL)
                                    playerViewController.player?.play()
                                    self.present(playerViewController, animated: true, completion: nil)
                                }
                            }
                        })
        }
        
    
    func playSound(url : String)
     {
       guard  let url = URL(string: url)
      else
         {
           print("error to get the mp3 file")
           return
         }
      do{
        try AVAudioSession.sharedInstance().setCategory(.ambient)
          try AVAudioSession.sharedInstance().setActive(true)
          player = try AVPlayer(url: url as URL)
          guard let player = player
                else
                    {
                      return
                    }
          player.play()
       } catch let error {
             print(error.localizedDescription)
                }
    }
    
    //push function
    func pushToWeeklyChallenge(data: [String: Any]){
        if let weeklyChallengeViewController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallengeViewController") as? WeeklyChallengeViewController {
            weeklyChallengeViewController.isFromLibrary = true
            weeklyChallengeViewController.challengeDatafromLib = data
                  self.navigationController?.pushViewController(weeklyChallengeViewController, animated: true)
              }
    }
    
    func pushToMeditationVC(data : [String: Any]){
        if let dailyMeditationViewController = UIStoryboard(name: "Meditation", bundle: nil).instantiateViewController(withIdentifier: "DailyMeditationViewController") as? DailyMeditationViewController {
            dailyMeditationViewController.isFromLibraryMeditation = true
            dailyMeditationViewController.dataFromLibrary = data
            self.navigationController?.pushViewController(dailyMeditationViewController, animated: true)
        }

    }
    
    func pushToGardenQuestionVC(data : [String: Any]){
        if let QuestionOfWeekViewController = UIStoryboard(name: "ThoughtGarden", bundle: nil).instantiateViewController(withIdentifier: "QuestionOfWeekViewController") as? QuestionOfWeekViewController {
            QuestionOfWeekViewController.isFromFavSection = true
            QuestionOfWeekViewController.dataFromFavSection = data
            self.navigationController?.pushViewController(QuestionOfWeekViewController, animated: true)
        }
    }
    
    func pushToSHowQuotes(str : String){
        if let weeklyChallenegDescriptionController = UIStoryboard(name: "Challenge", bundle: nil).instantiateViewController(withIdentifier: "WeeklyChallenegDescriptionController") as? WeeklyChallenegDescriptionController {
            weeklyChallenegDescriptionController.moreTExt = str
            self.navigationController?.pushViewController(weeklyChallenegDescriptionController, animated: true)
        }
    }
    
}

extension MyFavoritesContentViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.favList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteContentCell") as! FavoriteContentCell
        cell.setUpCell(heading: subTitle)
        let data = viewModal.favList[indexPath.row]
        cell.nameLbl.text = data.name ?? ""
        cell.dateLbl.text = data.created_at ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let data = viewModal.favList[indexPath.row]
        
        
        if subTitle == "Videos"{
            if data.videoLink != ""{
                if data.videoLink?.contains("youtu") ?? false{
                    self.playYoutubeVideo(str: data.videoLink ?? "")
                }else{
                    self.playVimeoVideo(videoUrl: data.videoLink ?? "")
                }
            }
        }else if subTitle == "Quotes"{
            let txt = self.setAttributedString(quote: data.name ?? "", author: data.authorName ?? "")
            self.pushToSHowQuotes(str: txt.string)
            
        }else if subTitle == "ACL Groups"{
            if let mapLocationDetailController = UIStoryboard(name: "FindACL", bundle: nil).instantiateViewController(withIdentifier: "MapLocationDetailController") as? MapLocationDetailController {
                mapLocationDetailController.isFromFavList = true
                mapLocationDetailController.selectedId = data.id ?? ""
                self.navigationController?.pushViewController(mapLocationDetailController, animated: true)
            }
        }
            
        else if subTitle == "Weekly Challenges"{
            let data = viewModal.favList[indexPath.row]
            self.pushToWeeklyChallenge(data: data.wholeData ?? [:])
            
        }
            
        else if subTitle == "Meditations"{
            let data = viewModal.favList[indexPath.row]
            self.pushToMeditationVC(data: data.wholeData ?? [:])
        }
            
        else if subTitle == "Question of the week"{
            let data = viewModal.favList[indexPath.row]
            self.pushToGardenQuestionVC(data: data.wholeData ?? [:])
        }
            
        else if subTitle == "Journal Entries"{
            let data = viewModal.favList[indexPath.row]
            audioView?.animShow(backView: self.view)
            audioView?.initAudioPlayer(str: data.recordingUrl ?? "",fileName: data.name ?? "")
//            self.playSound(url: data.recordingUrl ?? "")
        }else if subTitle == "Exercises"{
            if let aclExercisesViewController = UIStoryboard(name: "MyACL", bundle: nil).instantiateViewController(withIdentifier: "ACLExercisesViewController") as? ACLExercisesViewController {
                let dataDict = data.wholeData
                let id = dataDict?["category_id"] as? String ?? ""
                if id == "1"{
                    aclExercisesViewController.titleTExt = "Awareness Exercise"
                    aclExercisesViewController.viewtype = .awareness
                }else if id == "2"{
                    aclExercisesViewController.titleTExt = "Courage Exercise"
                    aclExercisesViewController.viewtype = .courage
                }else if id == "3"{
                    aclExercisesViewController.titleTExt = "Love Exercise"
                    aclExercisesViewController.viewtype = .love
                }
                let isFavourite = dataDict?["isFavorite"] as? String ?? ""
                if isFavourite == "1"{
                    aclExercisesViewController.isFav = true
                }else{
                    aclExercisesViewController.isFav = false
                }
                aclExercisesViewController.isDetailSelected = true
                aclExercisesViewController.isFromFavSection = true
                aclExercisesViewController.selectedText = dataDict?["description"] as? String ?? ""
                self.navigationController?.pushViewController(aclExercisesViewController, animated: true)
            }
            
        }
    }
    
}
