//
//  S3URL.swift
//  ToggleDev2
//
//  Created by James McDougall on 1/3/21.
//

import Foundation

class S3URL {
    @Published var url: URL? = URL(string: "")
    init(id: String) {
        DataManager().getURL(postId: id) { url in
            self.url = url
        }
    }
}
