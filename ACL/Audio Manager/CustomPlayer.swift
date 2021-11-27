//
//  CustomPlayer.swift
//  ACL
//
//  Created by Rapidsofts Sahil on 22/04/21.
//  Copyright © 2021 Gagandeep Singh. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class CustomPlayer {
    
    static let sharedInstance = CustomPlayer()
    
    var audio: AVAudioPlayer? = AVAudioPlayer()
    var session: AVAudioSession? = AVAudioSession.sharedInstance()
    
    func setupNowPlaying(at itemURL: URL) {
        //audio = AVAudioPlayer()
        self.audio?.pause()
        do {
            try session?.setCategory(AVAudioSession.Category.playback)
            try session?.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print(error)
        }
        DispatchQueue.global(qos: .default).async {
            
//            self.getData(from: itemURL) { (sound, resp, err) in
//                guard let data = sound, err == nil else { return }
//                print("download finish")
//
//            }
            
            let soundData = try? Data.init(contentsOf: itemURL)
            DispatchQueue.main.async {
                do {
                    self.audio = try AVAudioPlayer(data: soundData!)
                } catch {
                    print(error)
                }

                NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
                    self.audio?.currentTime = 0
                    self.audio?.play()
                }

        
        
                self.audio?.prepareToPlay()
                self.audio?.play()
        let arrWork = MPMediaItemArtwork.init(boundsSize: CGSize(width: 60, height: 60)) { (_) -> UIImage in
            return UIImage(named: "logo")!
        }

        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        if Singleton.sharedInstance.currentTitle == ""{
            Singleton.sharedInstance.currentTitle = "Meditation"
        }
        
        let nowPlayingInfo = [
         MPMediaItemPropertyTitle: Singleton.sharedInstance.currentTitle,
         MPMediaItemPropertyArtist: Singleton.sharedInstance.currentAuthor,
             MPMediaItemPropertyArtwork: arrWork,
            MPMediaItemPropertyPlaybackDuration: self.audio!.duration,
            MPNowPlayingInfoPropertyPlaybackRate: self.audio!.rate,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: self.audio!.currentTime
            
        ] as [String : Any]
        
         nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
                self.setupRemoteTransportControls()
            }
        }
        
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] event in
            self.audio!.play()
            
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] event in
                self.audio!.pause()
                return .success
        }
    }

    func isPlaying()->Bool{
        if audio != nil{
           return self.audio!.isPlaying
        }
        return false
    }
    
    

}


