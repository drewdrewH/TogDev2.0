import Foundation
import UIKit
import AVKit

class ImagePickerVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var videoURL: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var video: UIImageView!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.mediaTypes = ["public.movie"]
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func textInput(_ sender: Any) {
        
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
        // TODO: move code form ImagePickerController to a backend function then create the new post here using state variables.
        // make a post and upload the video.
        let user = User(name: "James")
        let post = Post(postOwner: user, caption: "Ok, this is epic.", status: PostStatus.active)
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
