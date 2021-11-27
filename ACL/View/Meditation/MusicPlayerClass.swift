//
//  MusicPlayerClass.swift
//  ACL
//
//  Created by Rapidsofts Sahil on 19/04/21.
//  Copyright © 2021 Gagandeep Singh. All rights reserved.
//

import Foundation
import AVFoundation

class MusicPlayer : NSObject {
    public static var instance = MusicPlayer()
    var player = AVPlayer()

    func playAudioWithUrl(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        playAudioBackground()
        play()
    }
    
    func playAudioBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: [.mixWithOthers])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    func pause(){
        player.pause()
    }
    
    func play() {
        player.play()
    }
}
