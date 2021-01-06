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
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - variables
    private var posts = [Post]()
    var URLS =  [String : URL]()
    var thumbnails = [String : UIImage?]()
    
    private let playerManager = PlayerControllerManager()
    private let fetchPosts = FetchPostsManager()
    private var visibleCells = [IndexPath : CGFloat]()
    private var currentPlayingCellIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var postIsLiked = [Bool]()
    private var dataIsReadyToBeDisplayed = false
    
    //MARK: - view life cycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override var prefersStatusBarHidden: Bool {
      return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        playInitialCell()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        centerActivityIndicator()
        startObservingEvents()
        setupNavControllerView()
        startActivityIndicator()
        self.tableView.isHidden = true
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
                self.playerManager.playUniquePlayer(postID: MainFeedInitialCell.postID)
                MainFeedInitialCell.prepareToPlayVideo()
                self.currentPlayingCellIndexPath = indexPath
            }
        }
    }
    
    private func startObservingEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(startFetching(notification:)), name: Notification.Name("DataStoreReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeFeedVC.videoEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func stopObservingEvents() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func startActivityIndicator() {
        ActivityIndicator.isHidden = false
        ActivityIndicator.startAnimating()
    }
    
    private func stopActivityIndicator() {
        ActivityIndicator.isHidden = true
        ActivityIndicator.stopAnimating()
    }
    
    private func centerActivityIndicator() {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let topPadding = window.safeAreaInsets.top
            let bottomPadding = window.safeAreaInsets.bottom
            let heightPosition = self.view.bounds.height - topPadding - bottomPadding
            ActivityIndicator.center = CGPoint(x: self.view.bounds.size.width/2, y: heightPosition/3)
        }
    }
    
    
    @objc private func videoEnded() {
        let getCurrentPlayingCell = tableView.cellForRow(at: currentPlayingCellIndexPath)
        let currentPlayingMainFeedCell = getCurrentPlayingCell as? MainFeedTableViewCell
        playerManager.restartPlayer(for: currentPlayingMainFeedCell?.postID ?? "")
        playerManager.playUniquePlayer(postID: currentPlayingMainFeedCell?.postID ?? "")
    }
    
    @objc private func startFetching(notification: NSNotification) {
        fetchPosts.getAllPostsData { (dataIsReady) in
            if dataIsReady {
                DispatchQueue.main.async {
                    self.posts = self.fetchPosts.postsFetched
                    self.URLS = self.fetchPosts.URLsFetched
                    self.thumbnails = self.fetchPosts.ThumbNailsFetched
                    for _ in self.posts {
                        self.postIsLiked.append(false)
                    }
                    self.tableView.reloadData()
                    self.stopActivityIndicator()
                    self.tableView.isHidden = false
                    self.playInitialCell()
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("DataStoreReady"), object: nil)

                }
            }
        }
    }
    
    @objc private func uploadButton() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "localVideosCollectionView") as? LocalVideosCollectionViewVC {
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
            let mostVisibleMainFeedCell = getMostVisibleCell as? MainFeedTableViewCell
            
            let getCurrentPlayingCell = tableView.cellForRow(at: currentPlayingCellIndexPath)
            let currentPlayingMainFeedCell = getCurrentPlayingCell as? MainFeedTableViewCell
            if mostVisibleMainFeedCell?.postID != currentPlayingMainFeedCell?.postID {
                currentPlayingMainFeedCell?.prepareToStopVideo()
                playerManager.pauseUniquePlayer(postID: currentPlayingMainFeedCell?.postID ?? "")
                playerManager.restartPlayer(for: currentPlayingMainFeedCell?.postID ?? "")

                mostVisibleMainFeedCell?.prepareToPlayVideo()
                self.playerManager.playUniquePlayer(postID: mostVisibleMainFeedCell?.postID ?? "")
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
        cell.thumbnail.image = thumbnails[cell.postID]!
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
            let url = URLS[cell.postID]
            let currentPlayerController = playerManager.createPlayerController(videoURL: url)
            playerManager.appendPlayerController(postID: cell.postID, player: currentPlayerController)
            cell.addVideoPlayerLayer(to: cell.playerContainer)
            playerManager.assignPlayerTo(cellPlayerLayer: cell.playerContainer, withID: cell.postID)
        }
    }
}

//MARK: - user cell interactions
extension HomeFeedVC: MainFeedCellDelegate {
    func didTapCommentButton(for cell: MainFeedTableViewCell) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "commentsViewController") as? CommentsVC{
              if let navigator = navigationController {
                  navigator.pushViewController(viewController, animated: true)
              }
            
            let indexPath = currentPlayingCellIndexPath
            viewController.post = posts[indexPath.row]
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
