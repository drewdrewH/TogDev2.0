//
//  postDataModel.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/25/20.
//

import Foundation

class PostViewModel: ObservableObject {
    var posts = [Post]()
    var urls = [URL]()
    
    //here we call API to get posts data, for now it's hard coded. The Post() struct is created under Model section
    init () {
        DataManager().getAllPosts() { ps in
            print("Before Posts")
            self.posts = ps
            print("Before URL")
            let res = URLModel(posts: self.posts) { urls in
                self.urls = urls
            }
            DispatchQueue.main.async {
                print("URLModel: \(self.urls)")
            }
            //sleep(1)
            print(res)
        }
        let _ = print("Posts: \(self.posts)")
    }
}
