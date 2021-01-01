import Foundation
import UIKit
import AVKit
import Amplify

class ImagePickerVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var videoURL: URL?
    var user: String?
    var caption: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = Amplify.Auth.getCurrentUser()?.username
    }
    
    @IBOutlet weak var video: UIImageView!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.mediaTypes = ["public.movie"]
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    
    @IBOutlet var textField: UITextField!
    
    @IBAction func textInput(_ sender: Any) {
        self.caption = textField.text
        print(self.caption ?? "no caption")
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("imagePickerController")
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
        // self.caption = caption , self.user = username
        let user = User(name: self.user! )
        let caption = self.caption ?? "caption not working"
        //let comment = Comment
        let post = Post(postOwner: user, caption: caption, numberOfLikes: 0, status: PostStatus.active)
        let videoManager = VideoManager()
        let dataManager = DataManager()
        if self.videoURL == nil {
            print("Video Url is nil. Not uploading or creating post.")
        } else {
            videoManager.uploadVideo(url: self.videoURL!, id: post.id)
            dataManager.createUser(user: user)
            dataManager.createPost(post: post)
        }
    }
}
    

