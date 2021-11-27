//
//  AudioPlayerView.swift
//  ACL
//
//  Created by Aman on 12/11/20.
//  Copyright © 2020 Gagandeep Singh. All rights reserved.
//

import UIKit
import AVKit

class AudioPlayerView: UIView {

    //MARK: oputlets
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBOutlet weak var endTimeLbl: UILabel!
    @IBOutlet weak var playpauseBtn: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
   
    var player: AVPlayer?
    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initAudioPlayer(str : String, fileName : String){
        
        nameLbl.text = fileName
        let url = URL(string: str)
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)
        timeSlider.minimumValue = 0
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        endTimeLbl.text = self.stringFromTimeInterval(interval: seconds)
        
        let currentDuration : CMTime = playerItem.currentTime()
        let currentSeconds : Float64 = CMTimeGetSeconds(currentDuration)
        startTimeLbl.text = self.stringFromTimeInterval(interval: currentSeconds)
        timeSlider.maximumValue = Float(seconds)
        timeSlider.isContinuous = true
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                //self.timeSlider.value = Float ( time )
                UIView.animate(withDuration: 1, animations: {
                  self.timeSlider.setValue(Float ( time ), animated: true)
                })
//                self.timeSlider.setValue(Float ( time ), animated: true)

                self.startTimeLbl.text = self.stringFromTimeInterval(interval: time)
            }
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
                self.playpauseBtn.isHidden = true
//                SwiftLoader.show(animated: true)
            } else {
                print("Buffering completed")
//                SwiftLoader.hide()
                self.playpauseBtn.isHidden = false
            }
        }
       //change the progress value
        timeSlider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.playPause()
        }
    }


    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider) {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        player!.seek(to: targetTime)
        if player!.rate == 0 {
            player?.play()
            playpauseBtn.setImage(UIImage(named: "pauseIcon"), for: .normal)

        }
    }

    @objc func finishedPlaying( _ myNotification:NSNotification) {
        playpauseBtn.setImage(UIImage(named: "playIcon"), for: UIControl.State.normal)
        //reset player when finish
        timeSlider.value = 0
        let targetTime:CMTime = CMTimeMake(value: 0, timescale: 1)
        player!.seek(to: targetTime)
    }
    
    

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
    @IBAction func playPauseBtnAction(_ sender: UIButton) {
        print("play Button")
          playPause()
    }
    
    func playPause(){
        print("play Button")
                 if player?.rate == 0
                 {
                     player!.play()
                     self.playpauseBtn.isHidden = true
                     playpauseBtn.setImage(UIImage(named: "pauseIcon"), for: .normal)
                 } else {
                     player!.pause()
                     playpauseBtn.setImage(UIImage(named: "playIcon"), for: .normal)
                 }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
//        player = nil
//        playPause()
        player?.pause()
        self.animHide()
    }
}
