//
//  VideoViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import AVFoundation
enum IntroVideoViewType {
    case login
    case sigup
    case news
}

class VideoViewController: BaseViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playbutton: UIButton!
    
    var videoPlayer: AVPlayer?
    
    var viewType: IntroVideoViewType = .login
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playbutton.isHidden = true
        self.playFullScreenVideo()
        // set back button title
        if viewType == .news {
            backButton.setTitle(" Back to News", for: .normal)
        }
    }
    

    @IBAction func backButtonAction(_ sender: Any) {
        videoPlayer?.pause()
        videoPlayer = nil
        
        self.dismiss(animated: true, completion: nil)
    }
    

    
    
    private func playFullScreenVideo() {
      
        // drag your video file in  project
        // check if video file is available,if not return
        guard let path = Bundle.main.path(forResource: "acl2", ofType:"mp4") else {
            debugPrint("video.mp4 missing")
            return
        }
//
        
        if self.viewType == .news{
            videoPlayer = AVPlayer(url: URL(string: videoUrl)!)
                   let playerLayer = AVPlayerLayer(player: videoPlayer)
                   playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                   playerLayer.frame = self.view.frame
                   playerView.layer.addSublayer(playerLayer)
                   videoPlayer?.play()
        }else{
            let url = URL(fileURLWithPath: path)
                  // create instance of videoPlayer with video path
                  videoPlayer = AVPlayer(url: url)
                  // create instance of playerlayer with videoPlayer
                  let playerLayer = AVPlayerLayer(player: videoPlayer)
                  // set its videoGravity to AVLayerVideoGravityResizeAspectFill to make it full size
                  playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                  // add it to your view
                  playerLayer.frame = self.view.frame
                  playerView.layer.addSublayer(playerLayer)
                  // start playing video
                  videoPlayer?.play()
        }
        
        if ((videoPlayer?.isMuted) != nil){
            videoPlayer?.isMuted = false
        }
        
      
    }
}
