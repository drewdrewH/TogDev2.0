//
//  deviceVideosCollectionViewVCCollectionViewController.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/2/21.
//

import UIKit
import Photos
private let reuseIdentifier = "Cell"

class LocalVideosCollectionViewVC: UICollectionViewController {
    
    //MARK: - variables
    private var photos: PHFetchResult<PHAsset>!
    private let screenSize = UIScreen.main.bounds

    //MARK: - view lifeceycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getAssetFromPhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Your Videos"
    }
    
    //MARK: - Helpers
    
    private func getAssetFromPhoto() {
        let options = PHFetchOptions()
        options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: true) ]
        options.predicate = NSPredicate(format: "mediaType = %d AND duration < 61", PHAssetMediaType.video.rawValue)
        photos = PHAsset.fetchAssets(with: options)
        self.collectionView.reloadData()
    }
    
    private func setCellBorder(for cell: localVideosCollectionViewCell) {
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
    }
    
    private func getUrlFromPHAsset(asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void)
    {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions(), completionHandler: { (contentEditingInput, dictInfo) in

            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString
            {
                callBack(URL.init(string: strURL))
            }
        })
    }
    
    private func goToCreatePost(url: URL?, image: UIImage?) {
        DispatchQueue.main.async {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreatePostVC") as? CreatePostViewController {
                viewController.localVideoURL = url
                viewController.videoThumbnailImage = image
                if let navigator = self.navigationController {
                      navigator.pushViewController(viewController, animated: true)
                  }
            }
        }
    }
}

//MARK: - collection view delegate flow layout
extension LocalVideosCollectionViewVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsize = screenSize.width / 2
        return CGSize(width: cellsize, height: cellsize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: UICollectionViewDataSource
extension LocalVideosCollectionViewVC {

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! localVideosCollectionViewCell
        setCellBorder(for: cell)
        let asset = photos!.object(at: indexPath.row)
        let size = CGSize(width: screenSize.width / 2, height: screenSize.width / 2)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: nil) { (image, userInfo) -> Void in

            cell.thumbnailImage.image = image
            cell.lblVideoTime.text = String(format: "%02d:%02d",Int((asset.duration / 60)),Int(asset.duration) % 60)

        }
    
        return cell
    }
}

//MARK: - UI Collection View Delegate
extension LocalVideosCollectionViewVC {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = photos!.object(at: indexPath.row)
        let cell = collectionView.cellForItem(at: indexPath) as? localVideosCollectionViewCell
        getUrlFromPHAsset(asset: video) {[weak self] (url) in
            if let url = url, let image = cell?.thumbnailImage.image  {
                self?.goToCreatePost(url: url, image: image)
            }
        }
    }
}
