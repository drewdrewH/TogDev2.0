//
//  PlayerControllerManager.swift
//  Toggle
//
//  Created by Walid Rafei on 12/20/20.
//

import UIKit
import AVFoundation
import AVKit

class PlayerControllerManager: ObservableObject {
    private var playerControllers = [String : PlayerConroller]()
    
    init() {}
    
    func appendPlayerController(postID: String, player: PlayerConroller) {
        playerControllers[postID] = player
    }
    
    func removePlayer(for id: String) -> PlayerConroller? {
        return playerControllers.removeValue(forKey: id)
    }
    
    func createPlayerController(videoURL: URL?) -> PlayerConroller {
        let player = AVPlayer()
        let asset = AVAsset(url: videoURL!)
        let playerItem = AVPlayerItem(asset: asset)
        let playerToReturn = PlayerConroller(AVPlayer: player, AVplayerItem: playerItem)
        return playerToReturn
    }
    
    public func getUniquePlayer(postID: String) -> PlayerConroller? {
        if let currentPlayer = playerControllers[postID] {
            return currentPlayer
        }
        return nil
    }
    
    public func playUniquePlayer(postID: String) {
        if let currentPlayer = playerControllers[postID] {
            currentPlayer.playVideo()
        }
    }
    
    public func pauseUniquePlayer(postID: String) {
        if let currentPlayer = playerControllers[postID] {
            currentPlayer.pauseVideo()
        }
    }
    
    public func assignPlayerTo(cellPlayerLayer: UIView, withID: String) {
        if let sublayers = cellPlayerLayer.layer.sublayers {
            for layer in sublayers {
                if (layer.name == "playerLayer") {
                    if let currLayer = layer as? AVPlayerLayer,
                       let playerController = getUniquePlayer(postID: withID){
                        playerController.assignPlayerItem()
                        currLayer.player = playerController.getPlayer().AVPlayer
                    }
                }
            }
        }
    }
    
    public func restartPlayer(for postID: String) {
        if let currentPlayer = playerControllers[postID] {
            currentPlayer.seekVideoToStart()
        }
    }
    
    
}
