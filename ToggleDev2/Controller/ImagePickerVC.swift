import Foundation
import UIKit
import AVKit
import Amplify

class ImagePickerVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var videoURL: URL?
    var user: User?
    var username: String?
    var caption: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.username = Amplify.Auth.getCurrentUser()?.username
    }
    
    @IBOutlet weak var video: UIImageView!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.allowsEditing = true
        imagePickerVC.videoMaximumDuration = 60.0
        imagePickerVC.mediaTypes = ["public.movie"]
        
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    
    @IBOutlet var textField: UITextField!
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // do someting...
        picker.dismiss(animated: true, completion: nil)
        if let url = info[.mediaURL] as? URL {
            self.videoURL = url
            // create thumbnail for view page for form
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            
            var time = asset.duration
            time.value = min(time.value, 2)
            
            do {
                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                video.image = UIImage(cgImage: imageRef)
            } catch {
                print("imagePickerController error")
            }
        }
        
        // create thumbnail for view page for form
        let asset = AVAsset(url: (info[.mediaURL] as? URL)!)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            video.image = UIImage(cgImage: imageRef)
        } catch {
            print("error")
            
        }
    }
    
    @IBAction func submitPost(_ sender: Any) {
        let videoManager = VideoManager()
        let dataManager = DataManager()
        
        dataManager.getUser(username: self.username!) { user in
            if user.isEmpty {
                // then create the user
                print("Creating new user \(self.username!)")
                self.user = User(name: self.username!)
                dataManager.createUser(user: self.user!)
            } else {
                print("Using old user \(self.username!)")
                self.user = user[0]
            }
            let caption = self.caption ?? "caption not working"
            let post = Post(postOwner: self.user!, caption: caption, numberOfLikes: 0, status: PostStatus.active)
            print("Submitting \(post) for user \(self.username!)")
            if self.videoURL == nil {
                print("Video Url is nil. Not uploading or creating post.")
            } else {
                videoManager.uploadVideo(url: self.videoURL!, id: post.id)
                dataManager.createPost(post: post)
            }
        }
    }
}


