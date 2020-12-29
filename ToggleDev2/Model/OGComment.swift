//
//  Comment.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/28/20.
//

import Foundation

struct OGComment: Identifiable, Hashable {
    var id: Int
    let commentOwner: String
    let commentText: String
}

class CommentsViewModel: ObservableObject {
    @Published var comments = [OGComment]()
    
    init() {
        let comment1 = OGComment(id: 0, commentOwner: "Walid Rafei" , commentText: "This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing")
        
        let comment2 = OGComment(id:1, commentOwner: "Andrew", commentText: "Hey!")
        
        let comment3 = OGComment(id: 2, commentOwner: "test", commentText: "test")
        let comment4 = OGComment(id: 3, commentOwner: "James", commentText: "haha")
        let comment5 = OGComment(id: 4, commentOwner: "James", commentText: "haha")
        let comment6 = OGComment(id: 5, commentOwner: "James", commentText: "haha")
        let comment8 = OGComment(id: 6, commentOwner: "James", commentText: "haha")
        let comment9 = OGComment(id: 6, commentOwner: "James", commentText: "haha")
        let comment10 = OGComment(id: 6, commentOwner: "James", commentText: "haha")
        let comment11 = OGComment(id: 6, commentOwner: "James", commentText: "haha")
        let comment12 = OGComment(id: 6, commentOwner: "James", commentText: "haha")
        let comment13 = OGComment(id: 6, commentOwner: "James", commentText: "haha This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing")
        let comment14 = OGComment(id: 6, commentOwner: "James", commentText: "haha This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing")

        
        comments.append(comment1)
        comments.append(comment2)
        comments.append(comment3)
        comments.append(comment4)
        comments.append(comment5)
        comments.append(comment6)
        comments.append(comment8)
        comments.append(comment9)
        comments.append(comment10)
        comments.append(comment11)
        comments.append(comment12)
        comments.append(comment13)
        comments.append(comment14)

    }
    
}
