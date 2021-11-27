//
//  WelcomeViewController.swift
//  ACL
//
//  Created by RGND on 06/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class WelcomeViewController: BaseViewController {

    @IBOutlet weak var viewLaterButton: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var loadingIndicator: UIImageView!
    
    //3.130.228.30/acl/backend/web/upload/introvideo.mp4
    
    var videoPlayer: AVPlayer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup button
        viewLaterButton.applyGradient(colours: [AppTheme.lightPurple, AppTheme.darkPurple])
        playFullScreenVideo()
        loadingIndicator.isHidden = true
    }
    
    @IBAction func viewLaterAction(_ sender: Any) {
        videoPlayer?.pause()
        videoPlayer = nil
//        self.pushToQuoteOfScreenVC()
        self.gotoMainViewController()
    }
    
    
    func pushToQuoteOfScreenVC(){
        let landingViewController = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        self.navigationController?.pushViewController(landingViewController, animated: true)

    }
    
    private func playFullScreenVideo() {
        // drag your video file in  project
        // check if video file is available,if not return
        
//        guard let path = Bundle.main.path(forResource: "WelcomeVideo", ofType:"mp4") else {
//            debugPrint("video.mp4 missing")
//            return
//        }
        // create instance of videoPlayer with video path
        videoPlayer = AVPlayer(url: URL(string: videoUrl)!)
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        playerLayer.frame = self.view.frame
        playerView.layer.addSublayer(playerLayer)
        videoPlayer?.play()
    }
}
