//
//  ImagePickerVC.swift
//  ToggleDev2
//
//  Created by Niko  on 12/29/20.
//

import Foundation
import UIKit

class ImagePickerVC: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var videoURL: NSURL?
    @IBOutlet weak var video: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
            
            guard let videoURL = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerReferenceURL")] as? NSURL else {return}
            self.videoURL = videoURL
            print(videoURL)
        }
    
    
    
}
