//
//  CreatePostVCViewController.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/2/21.
//

import UIKit
import Amplify
class CreatePostViewController: UIViewController {

    //MARK: - IB outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var captionTextView: UITextView!
    
    //MARK: - variables
    var localVideoURL: URL? = nil
    var videoThumbnailImage: UIImage? = UIImage(named: "highway")
    let userInfo = currentSessionInfo()
    var user : User?
    var comments : [Comment]?
    //MARK: - view life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        captionTextView.delegate = self
        DataManager().getUser(username: Amplify.Auth.getCurrentUser()!.username ){users in
            for user in users{
                self.user = user
            }
            
        }
    }

    //MARK: - IB Actions
    @IBAction func postButtonTapped(_ sender: Any) {
        var caption = ""
        guard let username = userInfo.getCurrentUser()?.username, let videoURL = localVideoURL else {
            return
        }
        
        if captionTextView.text != "Add a caption..." {
            caption = captionTextView.text ?? ""
        }
        let user = self.user
        
        
        let comments: List<Comment> = []
        let post = Post(postOwner: user!, caption: caption, numberOfLikes: 9985, status: PostStatus.active, comments : comments)
        //let comment = Comment(content: caption, owner: user!, post: post)
        
        let videoManager = VideoManager()
        let dataManager = DataManager()
        
        videoManager.uploadVideo(url: videoURL, id: post.id)
        
        dataManager.createPost(post: post)
       
        self.popBackNavController(3)
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    @IBAction func videoTapped(_ sender: Any) {
    }
    //MARK: - helpers
    private func prepareView() {
        if let username = userInfo.getCurrentUser()?.username, let thumbnailImage = videoThumbnailImage {
            usernameLabel.text = username
            videoThumbnail.image = thumbnailImage
        }
        setupCaptionTextView()
    }
    
    private func setupCaptionTextView() {
        captionTextView.text = "Add a caption..."
        captionTextView.textColor = UIColor.lightGray
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: - UI Text Field delegSate
extension CreatePostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Add a comment..."
            textView.textColor = UIColor.lightGray
        }
    }
}
