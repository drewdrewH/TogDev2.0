//
//  UrlModel.swift
//  ToggleDev2
//
//  Created by James McDougall on 1/3/21.
//

import Foundation


class URLModel {
    @Published var urls = [URL]()
    init(posts: [Post]) {
        for post in posts {
            let s3URL = S3URL(id: post.id).url
            if s3URL != nil {
                print("s3url: \(s3URL!)")
                self.urls.append(s3URL!)
            }
        }
    }
}
