//
//  MainFeedCellTableViewCell.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/25/20.
//

import UIKit
import AVKit

protocol MainFeedCellDelegate: AnyObject {
    func didTapLikeButton(for cell: MainFeedTableViewCell)
    func didTapCommentButton(for cell: MainFeedTableViewCell)
}

class MainFeedTableViewCell: UITableViewCell {

    //MARK: - IB outlets
    @IBOutlet weak var likeButton: SFSymbolsIconButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var HeightOfThumbNailImage: NSLayoutConstraint!
    
    var postID: String = "0"
    var videoURL: String = ""
    
    weak var delegate: MainFeedCellDelegate?
    
    //MARK: - cell life cycle
    override func prepareForReuse() {
        super.prepareForReuse()
        let image = UIImage(systemName: "heart")
        likeButton.setImage(image, for: .normal)
    }
    
    override func awakeFromNib() {
        profileImage.makeRounded()
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func configure(with post: Post) {
        let thumbnailManager = ThumbnailManager()
        usernameLabel.text = post.postOwner.name
        numberOfLikes.text = "\(post.numberOfLikes) Likes"
        caption.text =  post.caption
        postID = post.id
        videoURL = "https://togdev2b55dd05348be4fabbdeffd3b013c1bc2231450-togdev.s3-us-west-2.amazonaws.com/public/\(post.id).mp4"
        let generatedImage = thumbnailManager.previewImageFromVideo(url: URL(string: videoURL)! as NSURL)
        if let image = generatedImage {
            thumbnail.image = image
        } else {
            thumbnail.image = UIImage(named: "highway")
        }
    }
    
    //MARK: - setup thumbnail
    /*func createThumbnail(for imageView: UIImageView, using image: UIImage) {
        let ratio = image.size.width / image.size.height
        let newHeight = (thumbnail.frame.width / ratio)
        HeightOfThumbNailImage.constant = newHeight
        imageView.image = image
        self.layoutIfNeeded()
    }*/
    
    //MARK: - adding video layer
    
    func addVideoPlayerLayer(to view: UIView) {
        let layer: AVPlayerLayer = AVPlayerLayer()
        layer.backgroundColor = UIColor.black.cgColor
        layer.videoGravity = .resize
        layer.isHidden = true
        layer.frame = view.bounds
        layer.name = "playerLayer"
        view.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach { $0.removeFromSuperlayer() }
        view.layer.addSublayer(layer)
    }
    
    func removePlayerLayer(from vie: UIView) {
        if let sublayers = playerContainer.layer.sublayers {
            for layer in sublayers {
                if (layer.name == "playerLayer") {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func prepareToPlayVideo() {
        DispatchQueue.main.async {
            self.thumbnail.isHidden = true
            if let sublayers = self.playerContainer.layer.sublayers {
                for layer in sublayers {
                    if (layer.name == "playerLayer") {
                        layer.isHidden = false
                    }
                }
            }
        }
    }
    
    func prepareToStopVideo() {
        DispatchQueue.main.async {
            self.thumbnail.isHidden = false
            if let sublayers = self.playerContainer.layer.sublayers {
                for layer in sublayers {
                    if (layer.name == "playerLayer") {
                        layer.isHidden = true
                    }
                }
            }
        }
    }
    
    //MARK: - user interactions
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        delegate?.didTapLikeButton(for: self)
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        delegate?.didTapCommentButton(for: self)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
}
