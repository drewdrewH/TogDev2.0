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
        imagePickerVC.delegate = self // new
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func textInput(_ sender: Any) {
        
    }
    
    func imagePickerController( picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // do someting...
        picker.dismiss(animated: true, completion: nil)

        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let url = info[.mediaURL] as? URL {
            do {
                let docDirURL: URL = documentsDirectoryURL.appendingPathComponent("test.mov")
                
                if FileManager.default.fileExists(atPath: docDirURL.path) {
                    do {
                        try FileManager.default.removeItem(at: docDirURL)
                        print("Removed pre-existing file at \(docDirURL)")
                    } catch {
                        print("Failed to remove file.")
                    }
                }
                try FileManager.default.moveItem(at: url, to: docDirURL)
                print("Movie saved in application store.")
                let dataManager = DataManager()
                movToMp4(at: docDirURL) { (mp4Url, _) in
                    dataManager.uploadFile(fileKey: mp4Url?.lastPathComponent ?? "test.mp4")
                }
            } catch {
                print("Error: ImagePickerController")
                print(error)
            }
        }
        
        // create thumbnail for view page for form
        let asset = AVAsset(url: videoURL!)
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
    }
}
