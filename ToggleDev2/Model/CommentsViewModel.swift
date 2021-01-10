//
//  Comment.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/28/20.
//

import Foundation
import Amplify
import AmplifyPlugins

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()
    init() {
        DataManager().getAllComments() { comments in
            for comment in comments {
                self.comments.append(comment)
            }
        }
    }
}
