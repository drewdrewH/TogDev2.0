//
//  PlayerController.swift
//  Toggle
//
//  Created by Walid Rafei on 12/20/20.
//

import UIKit
import AVFoundation
import AVKit

class PlayerConroller {
    private let AVPlayer: AVPlayer
    private var playerItem: AVPlayerItem
    
    init(AVPlayer: AVPlayer, AVplayerItem: AVPlayerItem) {
        self.AVPlayer = AVPlayer
        self.playerItem = AVplayerItem
    }
    
    func getPlayer() -> (AVPlayer: AVPlayer,AVPlayerItem: AVPlayerItem) {
        return (AVPlayer: self.AVPlayer, AVPlayerItem: self.playerItem)
    }
    
    func replacePlayerItem(AVPlayerItem: AVPlayerItem) {
        self.playerItem = AVPlayerItem
    }
        
    func playVideo() {
        AVPlayer.play()
    }
    
    func pauseVideo() {
        AVPlayer.pause()
    }
    
    func seekVideoToStart() {
        AVPlayer.seek(to: CMTime(seconds: 0, preferredTimescale: CMTimeScale(1)))
    }
    
    func assignPlayerItem() {
        AVPlayer.replaceCurrentItem(with: playerItem)
    }
}
