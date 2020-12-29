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
    private var playerControllers = [Int : PlayerConroller]()
    
    init() {}
    
    func appendPlayerController(postID: Int, player: PlayerConroller) {
        playerControllers[postID] = player
    }
    
    func removePlayer(for id: Int) -> PlayerConroller? {
        return playerControllers.removeValue(forKey: id)
    }
    
    func createPlayerController(videoURL: String) -> PlayerConroller {
        let player = AVPlayer()
        let asset = AVAsset(url: URL(string: videoURL)!)
        let playerItem = AVPlayerItem(asset: asset)
        let playerToReturn = PlayerConroller(AVPlayer: player, AVplayerItem: playerItem)
        return playerToReturn
    }
    
    public func getUniquePlayer(postID: Int) -> PlayerConroller? {
        if let currentPlayer = playerControllers[postID] {
            return currentPlayer
        }
        return nil
    }
    
    public func playUniquePlayer(postID: Int) {
        if let currentPlayer = playerControllers[postID] {
            currentPlayer.playVideo()
        }
    }
    
    public func pauseUniquePlayer(postID: Int) {
        if let currentPlayer = playerControllers[postID] {
            currentPlayer.pauseVideo()
        }
    }
    
    public func replacePlayerItem(from currentPostID: Int, to newPost: OGPost) {
        let AVPlayerToUpdate = getUniquePlayer(postID: currentPostID)
        let asset = AVAsset(url: URL(string: newPost.videoURL)!)
        let playerItem = AVPlayerItem(asset: asset)
        AVPlayerToUpdate?.replacePlayerItem(AVPlayerItem: playerItem)
    }
    
    public func assignPlayerTo(cellPlayerLayer: UIView, withID: Int) {
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
    
    public func restartPlayer(for postID: Int) {
        if let currentPlayer = playerControllers[postID] {
            currentPlayer.seekVideoToStart()
        }
    }
}
