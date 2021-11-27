//
//  AudioPlayer.swift
//  ACL
//
//  Created by RGND on 28/06/20.
//  Copyright © 2020 RGND. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer

class AudioPlayer: AVPlayer {
    
    static var shared = AVPlayer()
    static var count = 6
    static var url : URL!
    static var timer = Timer()
    
    static func playItem(at itemURL: URL) {
//        let data = Data(contentsOf: itemURL)
//        AVPlayer.
        if AudioPlayer.shared.isPlaying{
            AudioPlayer.count = 6
            AudioPlayer.url = itemURL
            AudioPlayer.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fadeOutAndPlay), userInfo: nil, repeats: true)
        }else{
            checkANdPlaywithFadeOut(itemURL: itemURL)
        }
    }
    
    
    @objc static func fadeOutAndPlay(){
        if AudioPlayer.count >= 0{
            AudioPlayer.count -= 1
            switch AudioPlayer.count {
            case 6:
                AudioPlayer.shared.volume = 0.7
            case 5:
                    AudioPlayer.shared.volume = 0.6
            case 4:
                AudioPlayer.shared.volume = 0.5
            case 3:
                AudioPlayer.shared.volume = 0.4
            case 2:
                AudioPlayer.shared.volume = 0.3
            case 1:
                AudioPlayer.shared.volume = 0.1
            case 0:
                AudioPlayer.timer.invalidate()
                
                AudioPlayer.count = -1
                checkANdPlaywithFadeOut(itemURL: AudioPlayer.url)
            default: break
               
            }
        }
    }
    
   static func checkANdPlaywithFadeOut(itemURL : URL){
        AudioPlayer.shared = AVPlayer(url: itemURL)
        AudioPlayer.shared.play()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
//               AudioPlayer.shared.seek(to: CMTime.zero)
//               AudioPlayer.shared.play()
            if let defaultSound = UserDefaults.standard.value(forKey: "defaultSound") as? String{
                let url = URL(string: defaultSound)
                AudioPlayer.playItem(at: url!)
                Singleton.sharedInstance.isSoundSelected = false
                UserDefaults.standard.setValue(false, forKey: isSoundSelected_key)
                AudioPlayer.shared.volume = 1
            }
            
            let arrWork = MPMediaItemArtwork.init(boundsSize: CGSize(width: 60, height: 60)) { (_) -> UIImage in
                return UIImage(named: "logo")!
            }
            setupNowPlayingInfo(with: arrWork)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "playerRestarted"), object: nil, userInfo: nil)
        }
        
        let arrWork = MPMediaItemArtwork.init(boundsSize: CGSize(width: 60, height: 60)) { (_) -> UIImage in
            return UIImage(named: "logo")!
        }
        setupNowPlayingInfo(with: arrWork)
    }
    
    
    static func restart() {
        AudioPlayer.shared.pause()
        AudioPlayer.shared.seek(to: CMTime.zero)
        AudioPlayer.shared.play()
        let arrWork = MPMediaItemArtwork.init(boundsSize: CGSize(width: 48, height: 48)) { (_) -> UIImage in
            return UIImage(named: "logo")!
        }
        setupNowPlayingInfo(with: arrWork)
        
    }
    
    static func justSetInitialTime() {
        AudioPlayer.shared.pause()
        AudioPlayer.shared.seek(to: CMTime.zero)
    }
    
    static func setupNowPlayingInfo(with artwork: MPMediaItemArtwork) {
        DispatchQueue.main.async {
            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
            if Singleton.sharedInstance.currentTitle == ""{
                Singleton.sharedInstance.currentTitle = "Meditation"
            }
            let nowPlayingInfo = [
             MPMediaItemPropertyTitle: Singleton.sharedInstance.currentTitle,
             MPMediaItemPropertyArtist: Singleton.sharedInstance.currentAuthor,
                 MPMediaItemPropertyArtwork: artwork,
             MPMediaItemPropertyPlaybackDuration: AudioPlayer.shared.currentItem!.duration,
                 MPNowPlayingInfoPropertyPlaybackRate: 1,
                 MPNowPlayingInfoPropertyElapsedPlaybackTime: AudioPlayer.shared.currentTime(),
                MPNowPlayingInfoPropertyIsLiveStream : false
            ] as [String : Any]
            
             nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo

        }

        commandCenterSetup()

//        let interval: CMTime = CMTimeMakeWithSeconds(1, preferredTimescale: Int32(NSEC_PER_SEC))
//        AudioPlayer.shared.addPeriodicTimeObserver(forInterval: interval, queue: .main) { (time) in
//            print("timer calling")
//            if AudioPlayer.shared.currentItem?.status == .readyToPlay {
////                            let time : Float64 = CMTimeGetSeconds(AudioPlayer.shared.currentTime());
////                self.slide
////                            self.playbackSlider!.value = Float ( time );
//                        }
//        }
    }
  static  func commandCenterSetup() {

        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()


     //  setupNowPlaying()

        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in

            print("PAUSE")
            AudioPlayer.shared.pause()
            return .success

           }


           commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in

            print("PLAY")
            AudioPlayer.shared.play()
            return .success
           }

  

        }
//    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
////        if object is AVPlayer{
////            let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
////
////            switch AudioPlayer.shared.timeControlStatus {
////            case .waitingToPlayAtSpecifiedRate, .paused:
////                let nowPlayingInfo = [
//////                 MPMediaItemPropertyPlaybackDuration: AudioPlayer.shared.currentItem!.duration,
////                     MPNowPlayingInfoPropertyPlaybackRate: 0,
////                     MPNowPlayingInfoPropertyElapsedPlaybackTime: AudioPlayer.shared.currentTime()
////                ] as [String : Any]
////
////                 nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
////            case .playing :
////                let nowPlayingInfo = [
////
////                     MPNowPlayingInfoPropertyPlaybackRate: 1,
////                     MPNowPlayingInfoPropertyElapsedPlaybackTime: AudioPlayer.shared.currentTime()
////                ] as [String : Any]
////
////                 nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
////
////            default: break
////                //
////            }
////        }
//    }
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
