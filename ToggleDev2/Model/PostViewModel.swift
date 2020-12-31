//
//  postDataModel.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/25/20.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    //here we call API to get posts data, for now it's hard coded. The Post() struct is created under Model section
    init () {
        DataManager().queryPosts() { ps in
            self.posts = ps
        }
        let _ = print("Posts: \(self.posts)")
    }
}
