//
//  ImagePickerVC.swift
//  ToggleDev2
//
//  Created by Niko  on 12/29/20.
//

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
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // do someting...
            picker.dismiss(animated: true, completion: nil)
            
            
           // if let image = info[.mediaType] as? UIImage {
             //   video.image = image
               // }
            if let videoURL = info[.mediaURL] as? URL {
                self.videoURL=videoURL
                print(videoURL)
            }
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
