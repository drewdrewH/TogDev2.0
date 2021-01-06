//
//  FetchPostsManager.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 1/5/21.
//

import Foundation
import UIKit
class FetchPostsManager {
    var postsFetched = [Post]()
    var URLsFetched = [String : URL]()
    var ThumbNailsFetched = [String : UIImage?]()
    
    private let dataManager = DataManager()
    private let thumbnailManager = ThumbnailManager()
    
    func getAllPostsData(completion:@escaping (Bool) -> ()) {
        let semaphore = DispatchSemaphore(value: 1)
        DispatchQueue.background(delay: 0, background: {
            print("fetch posts is waiting")
            semaphore.wait()
            print("fetch posts wait finished")
            self.getAllPosts {(taskIsDone) in
                if taskIsDone {
                    semaphore.signal()
                    print("fetch posts is done ")
                }
            }
            
            print("fetch URLS is waiting")
            semaphore.wait()
            print("fetch URLS wait finished")
            self.getURLS(for: self.postsFetched) { (taskIsDone) in
                if taskIsDone {
                    semaphore.signal()
                    print("fetch URLS is done ")
                }
            }
           
            print("fetch IMAGES is waiting")
            semaphore.wait()
            print("fetch IMAGES wait finished")
            self.getThumbnails(for: self.URLsFetched) { (taskIsDone) in
                if taskIsDone {
                    semaphore.signal()
                    print("IMAGES URLS is done ")
                }
            }
        }, completion: {
            completion(true)
        })
    }
    
    private func getAllPosts(completion:@escaping (Bool) -> ()) {
        dataManager.getAllPosts() { postsResult in
            self.postsFetched = postsResult
            completion(true)
        }
    }
    
    private func getURLS(for posts: [Post], completion:@escaping (Bool) -> ()) {
        let group = DispatchGroup()
        for post in posts {
            group.enter()
            DataManager().getURL(postId: post.id) {[weak self] url in
                self?.URLsFetched[post.id] = url
                group.leave()
            }
        }
        group.wait()
        completion(true)
    }
    
    private func getThumbnails(for URLs: [String : URL], completion:@escaping (Bool) -> ()) {
        let group = DispatchGroup()
        for (postID, url) in URLs {
            group.enter()
            let image = thumbnailManager.previewImageFromVideo(url: url as NSURL)
            self.ThumbNailsFetched[postID] = image
            group.leave()
        }
        group.wait()
        completion(true)
    }
}

extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}
