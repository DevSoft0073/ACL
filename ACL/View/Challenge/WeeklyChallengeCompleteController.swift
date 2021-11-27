//
//  WeeklyChallengeCompleteeController.swift
//  ACL
//
//  Created by RGND on 27/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import UIKit
import AVFoundation

class WeeklyChallengeCompleteController: BaseViewController {

    @IBOutlet weak var videoView: UIView!
    var videPlayTimes = 0
    var player: AVPlayer?
    var layer : AVPlayerLayer = AVPlayerLayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initializeVideoPlayerWithVideo()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoView.frame = view.frame
        self.layer.frame = self.videoView.bounds
    }
    
    func initializeVideoPlayerWithVideo() {

         let videoString:String? = Bundle.main.path(forResource: "Fireworks_Animat", ofType: "mp4")
         guard let unwrappedVideoPath = videoString else {return}

         let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
         self.player = AVPlayer(url: videoUrl)
        // let layer: AVPlayerLayer = AVPlayerLayer(player: player)
         //layer.bounds = videoView.bounds
        layer.player = player
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
         self.player?.play()
        print("Here is starting time",Date())
        videoView.layer.addSublayer(layer)
        self.videPlayTimes += 1
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

        
     }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
            
        if self.videPlayTimes <= 2{
            
            self.videPlayTimes += 1
            self.player?.seek(to: CMTime.zero)
            self.player?.play()

        }
        
    }
    
    @IBAction func crossButtonAction(_ sender: Any) {
        self.dismiss(animated: true) {

            //self.gotoMainViewController()
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
