//
//  UrlModel.swift
//  ToggleDev2
//
//  Created by James McDougall on 1/3/21.
//

import Foundation


class URLModel {
    var urls = [URL]()
    init(posts: [Post], completion:@escaping ([URL]) -> ()) {
        for post in posts {
            print("Getting url for post \(post.id)")
            DataManager().getURL(postId: post.id) { url in
                print("s3URL: \(url)")
                self.urls.append(url)
                completion(self.urls)
            }
        }
        print("s3URLs: \(self.urls)")
    }
}
