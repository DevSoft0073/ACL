//
//  SearchContentViewController.swift
//  ACL
//
//  Created by Rakesh Verma on 27/07/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit
import AVFoundation
import HCVimeoVideoExtractor

struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}

class SearchContentViewController: BaseViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    var pageIndex: Int = 0
    var viewModel = SearchResultViewModel()
    var videoLinks = [String]()
    
    //    struct YouTubeVideoQuality {
    //        static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    //        static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    //        static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.register(UINib.init(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        resultTableView.register(UINib.init(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: "VideoCell")
        resultTableView.reloadData()
        
    }
    
    
    
    
    
    
    
    
    func playYoutubeVideo(str: String){
        
        let videoIdentifier = String(str.suffix(11))
        
        //        var reutnUrl = String()
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { (video, error) in
            if error == nil{
                if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                    //                            print("video view",videoView?.frame as Any)
                    //                                            reutnUrl = streamURL.absoluteString
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
        
        
        //        return reutnUrl
    }
    
    
    func playVimeoVideo(videoUrl : String){
        let url = URL(string: videoUrl)!
        //  var returnUrl = String()
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video:HCVimeoVideo?, error:Error?) -> Void in
            if let err = error {
                print("Error = \(err.localizedDescription)")
                return
            }
            guard let vid = video else {
                print("Invalid video object")
                return
            }
            
            print(" url = \(vid.videoURL[.Quality720p]?.absoluteString)\(vid.thumbnailURL)")
            
            if let videoURL = vid.videoURL[.Quality720p] {
                //                            returnUrl = videoURL.absoluteString
                DispatchQueue.main.async {
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = AVPlayer(url: videoURL)
                    playerViewController.player?.play()
                    self.present(playerViewController, animated: true, completion: nil)
                }
                
                
            }
        })
        //        return returnUrl
    }
    
    
    func fetchVimeoVideoThumbnail(link : String) -> String {
        var str = ""
        let newStr = link.replacingOccurrences(of: "/", with: " ")
        if let range = newStr.range(of: "vimeo.com") {
            let id = newStr[range.upperBound...].trimmingCharacters(in: .whitespaces)
            print(id)
            str = "https://i.vimeocdn.com/video/\(id)_640.jpg"
            return str
        }else{
            return str
            
        }
        
        
        //https://i.vimeocdn.com/video/170452644?ref=em-v-share_640.jpg
        
    }
    
    
    func getHtmlString(string: String, color: UIColor) -> NSAttributedString? {
        
        guard let data = string.data(using: .utf8) else { return NSAttributedString() }
        do {
            let rr = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            
            let p = NSMutableAttributedString(attributedString: rr)
            var attributes = [NSAttributedString.Key: AnyObject]()
            attributes[.foregroundColor] = UIColor.white
            p.addAttributes(attributes, range: NSMakeRange(0, string.count))
            
            return p
        } catch {
            return NSAttributedString()
        }
    }
    
    func getSpecificText(str : String) -> NSAttributedString{
        let attrs1 = [NSAttributedString.Key.font: AppFont.get(.medium, size: 16), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let attrs2 = [NSAttributedString.Key.font: AppFont.get(.regular, size: 15), NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        let color1 = NSAttributedString(string: "▶ ", attributes: attrs1)
        let color2 = NSAttributedString(string: str, attributes: attrs2)
        let string = NSMutableAttributedString()
        string.append(color1)
        string.append(color2)
        return string
    }
    
    func fetchYoutubeThumbnail(url : String) -> String{
        var str = ""
        let videoId = String(url.suffix(11))
        str = "https://img.youtube.com/vi/\(videoId)/mqdefault.jpg"
        //https://youtu.be/1HbZmkNzkk0
        //https://img.youtube.com/vi/f4CG18FPCj0/hqdefault.jpg
        return str
    }
    
    func generateThumbnail(for asset:AVAsset) -> UIImage? {
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2)
        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        if img != nil {
            let frameImg  = UIImage(cgImage: img!)
            return frameImg
        }
        return nil
    }
    
}

extension SearchContentViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch pageIndex{
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        case 2:
            return UITableView.automaticDimension
        case 3:
            return 320
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.searchArray.count > 0{
            switch pageIndex{
            case 0:
                return viewModel.searchArray[0].weekly_meditation?.count ?? 0
            case 1:
                return viewModel.searchArray[0].quotes?.count ?? 0
            case 2:
                return viewModel.searchArray[0].weekly_challenges?.count ?? 0
            case 3:
                return viewModel.searchArray[0].video?.count ?? 0
            default:
                return 0
            }
        }else{
            return 1
        }
        
        // return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if pageIndex == 3{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell") as? VideoCell{
                if viewModel.searchArray.count > 0{
                    let modelArray = viewModel.searchArray[0]
                    let title = modelArray.video?[indexPath.row]["title"] as? String ?? ""
                    cell.videoTitle.attributedText = getSpecificText(str: title)
                    cell.starBtn.tag = indexPath.row
                    cell.starBtn.addTarget(self, action: #selector(starClicked(sender:)), for: .touchUpInside)
                    
                    let isFav = modelArray.video?[indexPath.row]["isFavorite"] as? String ?? ""
                    if isFav == "0"{
                        cell.starBtn.setImage(UIImage(named: "silverStar"), for: .normal)
                    }else{
                        cell.starBtn.setImage(UIImage(named: "main_screen_star"), for: .normal)
                    }
                    let videoUrl = modelArray.video?[indexPath.row]["video_link"] as? String ?? ""
                    
                    if videoUrl.contains("youtu"){
                        let img = fetchYoutubeThumbnail(url: videoUrl)
                        let urlImg = URL(string: img)
                        cell.thumbImageView.sd_setImage(with: urlImg, completed: nil)
                    }else{
                        let img = fetchVimeoVideoThumbnail(link: videoUrl)
                        let urlImg = URL(string: img)
                        cell.thumbImageView.sd_setImage(with: urlImg, completed: nil)
                    }
                    
                    
                    //   let videoUrl = modelArray.video?[indexPath.row]["video_link"] as? String ?? ""
                    //                    https://vimeo.com/474708803
                    //                    cell.configureCell(imageUrl: nil, description: title, videoUrl: videoUrl)
                    //                    if self.videoLinks.count > 1 {
                    //                        if  self.videoLinks.count > indexPath.row {
                    //                            cell.configureCell(imageUrl: nil, description: title, videoUrl: videoLinks[indexPath.row])
                    //                        }
                    //                    }
                    
                    //                    else{
                    //                        if videoUrl.contains("youtu"){
                    //                            let modifyUrl = self.playYoutubeVideo(str: videoUrl, videoView: cell.videoView)
                    //                            if modifyUrl != ""{
                    //                                cell.configureCell(imageUrl: nil, description: title, videoUrl: modifyUrl)
                    //                            }
                    //                        }else if videoUrl.contains("vimeo"){
                    //                            let modifyUrl = self.playVimeoVideo(videoUrl: videoUrl)
                    //                            if modifyUrl != ""{
                    //                                cell.configureCell(imageUrl: nil, description: title, videoUrl: modifyUrl)
                    //                            }
                    //                        }
                    //                    }
                    
                    
                }
                
                return cell
            }
            
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell {
                var name = ""
                var discription = ""
                if viewModel.searchArray.count > 0{
                    let modelArray = viewModel.searchArray[0]
                    
                    switch pageIndex{
                    case 0:
                        name = modelArray.weekly_meditation?[indexPath.row]["name"] as? String ?? ""
                        //discription = modelArray.weekly_meditation?[indexPath.row]["author_description"] as? String ?? ""
                        
                        break
                        
                    case 1:
                        name = modelArray.quotes?[indexPath.row]["author"] as? String ?? ""
                        discription = modelArray.quotes?[indexPath.row]["quotes"] as? String ?? ""
                        
                        break
                        
                    case 2:
                        
                        name = modelArray.weekly_challenges?[indexPath.row]["name"] as? String ?? ""
                        let disc = (modelArray.weekly_challenges?[indexPath.row]["description"] as? String ?? "").html2String
                        // print("here is html desc-->>",disc)
                        discription = disc
                        //discription = modelArray.weekly_challenges?[indexPath.row]["description"] as? String ?? ""
                        break
                        
                        
                    default: break
                    //
                    }
                }else{
                    
                }
                
                cell.titleLbl.text = name
                cell.discriptionLbl.text = discription
                
                cell.layoutIfNeeded()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let modelArray = viewModel.searchArray[0]
        
        switch pageIndex{
        case 0:
            print("first index")
            let dataArry = modelArray.weekly_meditation?[indexPath.row] ?? [:]
            self.pushToMeditationVC(data: dataArry)
            break
            
        case 1:
            print("second index")
            break
            
        case 2:
            print("third index")
            let data = modelArray.weekly_challenges?[indexPath.row] ?? [:]
            self.pushToWeeklyChallenge(data: data)
            
            break
            
        case 3:
            print("last index")
            let videoUrl = modelArray.video?[indexPath.row]["video_link"] as? String ?? ""
            if videoUrl.contains("youtu"){
                self.playYoutubeVideo(str: videoUrl)
            }else{
                self.playVimeoVideo(videoUrl: videoUrl)
            }
            
            break
            
        default: break
        //
        }
    }
    
    //   func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //          if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL {
    //              ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
    //          }
    //      }
    //
    //      func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    //          pausePlayeVideos()
    //      }
    //
    //      func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //          if !decelerate {
    //              pausePlayeVideos()
    //          }
    //      }
    //
    //      func pausePlayeVideos(){
    //          ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: resultTableView)
    //      }
    //
    //      @objc func appEnteredFromBackground() {
    //          ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: resultTableView, appEnteredFromBackground: true)
    //      }
    //
    
    
    //start button click
    @objc func starClicked(sender : UIButton){
        let modelArray = viewModel.searchArray[0]
        let videoId = modelArray.video?[sender.tag]["id"] as? String ?? ""
        SwiftLoader.show(animated: true)
        viewModel.addFavouriteForVideo(videoId: videoId) { (isSuccess, str) in
            SwiftLoader.hide()
            if isSuccess{
                DispatchQueue.main.async {
                    if sender.imageView?.image == UIImage(named: "main_screen_star"){
                        sender.setImage(UIImage(named: "silverStar"), for: .normal)
                    }else{
                        sender.setImage(UIImage(named: "main_screen_star"), for: .normal)
                    }
                }
                
            }else{
                print(str)
            }
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
}
extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
