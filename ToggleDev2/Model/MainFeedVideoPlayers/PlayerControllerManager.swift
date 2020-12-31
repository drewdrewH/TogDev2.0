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
    
    func createPlayerController(videoURL: String) -> PlayerConroller {
        let player = AVPlayer()
        let asset = AVAsset(url: URL(string: videoURL)!)
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
    
    public func replacePlayerItem(from currentPostID: String, to newPost: Post) {
        let vidUrl = "https://togdev2b55dd05348be4fabbdeffd3b013c1bc2231450-togdev.s3-us-west-2.amazonaws.com/public/\(newPost.id).mp4"
        print("Vid Url: \(vidUrl)")
        let AVPlayerToUpdate = getUniquePlayer(postID: currentPostID)
        let asset = AVAsset(url: URL(string: vidUrl)!)
        let playerItem = AVPlayerItem(asset: asset)
        AVPlayerToUpdate?.replacePlayerItem(AVPlayerItem: playerItem)
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
