//
//  HomeFeedVC.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/24/20.
//

import UIKit
import Amplify

class HomeFeedVC: UIViewController {
        
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - variables
    private var posts = [Post]()
    private let playerManager = PlayerControllerManager()
    private var visibleCells = [IndexPath : CGFloat]()
    private var currentPlayingCellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var postIsLiked = [Bool]()
    
    //MARK: - view life cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override var prefersStatusBarHidden: Bool {
      return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playInitialCell()
        print(Amplify.Auth.getCurrentUser() ?? "")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if posts.count != 0{
            let cell = tableView.cellForRow(at: currentPlayingCellIndexPath)
            let currentlyPlayingCell = cell as! MainFeedTableViewCell
            playerManager.pauseUniquePlayer(postID: currentlyPlayingCell.postID)
            playerManager.restartPlayer(for: currentlyPlayingCell.postID)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let thumbnailManager = ThumbnailManager()
        setupNavControllerView()
        let dataModel = PostViewModel()
        for post in dataModel.posts {
            self.posts.append(post)
            let url = "https://togdev2b55dd05348be4fabbdeffd3b013c1bc2231450-togdev.s3-us-west-2.amazonaws.com/public/\(post.id).mp4"
            thumbnailManager.previewImageFromVideo(url: URL(string: url)! as NSURL)
            self.postIsLiked.append(false)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        // Do any additional setup after loading the view.
    }
    
    //MARK: - view setup helpers
    private func setupNavControllerView() {
        
        let appLogo = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        appLogo.setBackgroundImage(UIImage(named: "AppLogo"), for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: appLogo)
        
        let uploadButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        uploadButton.setBackgroundImage(UIImage(systemName: "camera.circle.fill"), for: .normal)
        uploadButton.addTarget(self, action: #selector(HomeFeedVC.uploadButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadButton)
    }
    
    private func playInitialCell() {
        if posts.count != 0 {
            let indexPath = currentPlayingCellIndexPath
            let cell = tableView.cellForRow(at: indexPath)
            let MainFeedInitialCell = cell as! MainFeedTableViewCell
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                MainFeedInitialCell.prepareToPlayVideo()
                self.playerManager.playUniquePlayer(postID: MainFeedInitialCell.postID)
                self.currentPlayingCellIndexPath = indexPath
            }
        }
    }
}
    
extension HomeFeedVC{
// upload Button Clicked action
    @objc func uploadButtonClicked() {
          }
    @objc private func uploadButton() {
        print("Test")
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "imagePickerViewController") as? ImagePickerVC {
              if let navigator = navigationController {
                  navigator.pushViewController(viewController, animated: true)
              }
          }
    }
}



//MARK: - table view delegate
extension HomeFeedVC: UITableViewDelegate {
    
    private func calculateVisibleCellHeightOnScreen() {
        if let visibleCellsOnScreen = tableView.indexPathsForVisibleRows {
            for indexPath in visibleCellsOnScreen {
                let cellRect = tableView.rectForRow(at: indexPath)
                if let superview = tableView.superview {
                    let convertedRect = tableView.convert(cellRect, to:superview)
                    let intersect = tableView.frame.intersection(convertedRect)
                    let visibleHeight = intersect.height
                    let cellHeight = cellRect.height
                    let ratio = visibleHeight / cellHeight
                    visibleCells[indexPath] = ratio
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        calculateVisibleCellHeightOnScreen()
        if let mostVisibleCell = visibleCells.max(by: { a, b in a.value < b.value }) {
            let getMostVisibleCell = tableView.cellForRow(at: mostVisibleCell.key)
            let mostVisibleMainFeedCell = getMostVisibleCell as! MainFeedTableViewCell
            
            let getCurrentPlayingCell = tableView.cellForRow(at: currentPlayingCellIndexPath)
            let currentPlayingMainFeedCell = getCurrentPlayingCell as! MainFeedTableViewCell
            if mostVisibleMainFeedCell.postID != currentPlayingMainFeedCell.postID {
                currentPlayingMainFeedCell.prepareToStopVideo()
                playerManager.pauseUniquePlayer(postID: currentPlayingMainFeedCell.postID)
                playerManager.restartPlayer(for: currentPlayingMainFeedCell.postID)

                mostVisibleMainFeedCell.prepareToPlayVideo()
                self.playerManager.playUniquePlayer(postID: mostVisibleMainFeedCell.postID)
                currentPlayingCellIndexPath = mostVisibleCell.key
                
            }
        }
        
    }
}

//MARK: - table view data source
extension HomeFeedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainFeedCell") as! MainFeedTableViewCell
        cell.configure(with: model)
        cell.delegate = self
        cell.tag = indexPath.row
        if(postIsLiked[indexPath.row]) {
            let image = UIImage(systemName: "heart.fill")
            cell.likeButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "heart")
            cell.likeButton.setImage(image, for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MainFeedTableViewCell {
            playerManager.removePlayer(for: cell.postID)
            cell.removePlayerLayer(from: cell.playerContainer)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? MainFeedTableViewCell {
            let currentPlayerController = playerManager.createPlayerController(videoURL: cell.videoURL)
            playerManager.appendPlayerController(postID: cell.postID, player: currentPlayerController)
            cell.addVideoPlayerLayer(to: cell.playerContainer)
            playerManager.assignPlayerTo(cellPlayerLayer: cell.playerContainer, withID: cell.postID)
        }
    }
}

//MARK: - user cell interactions
extension HomeFeedVC: MainFeedCellDelegate {
    func didTapCommentButton(for cell: MainFeedTableViewCell) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentsViewController") as? CommentsVC {
              if let navigator = navigationController {
                  navigator.pushViewController(viewController, animated: true)
              }
          }
        
    }
    

    func didTapLikeButton(for cell: MainFeedTableViewCell) {
        let currentCellTag = cell.tag
        let currentCell = tableView.cellForRow(at: IndexPath(row: cell.tag, section: 0)) as! MainFeedTableViewCell
        let likeButton = currentCell.likeButton!
        if !postIsLiked[currentCellTag]{
            UIView.transition(with: likeButton, duration: 0.5, options: .transitionFlipFromRight, animations: {
                                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)}, completion: nil)
            postIsLiked[currentCellTag] = true
        } else {
            UIView.transition(with: likeButton, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)}, completion: nil)
            postIsLiked[currentCellTag] = false
        }
    }
    
}
