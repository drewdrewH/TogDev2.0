//
//  Comment.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/28/20.
//

import Foundation

struct Comment: Identifiable, Hashable {
    var id: Int
    let commentOwner: String
    let commentText: String
}

class CommentsViewModel: ObservableObject {
    @Published var comments = [Comment]()
    
    init() {
        let comment1 = Comment(id: 0, commentOwner: "Walid Rafei" , commentText: "This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing")
        
        let comment2 = Comment(id:1, commentOwner: "Andrew", commentText: "Hey!")
        
        let comment3 = Comment(id: 2, commentOwner: "test", commentText: "test")
        let comment4 = Comment(id: 3, commentOwner: "James", commentText: "haha")
        let comment5 = Comment(id: 4, commentOwner: "James", commentText: "haha")
        let comment6 = Comment(id: 5, commentOwner: "James", commentText: "haha")
        let comment8 = Comment(id: 6, commentOwner: "James", commentText: "haha")
        let comment9 = Comment(id: 6, commentOwner: "James", commentText: "haha")
        let comment10 = Comment(id: 6, commentOwner: "James", commentText: "haha")
        let comment11 = Comment(id: 6, commentOwner: "James", commentText: "haha")
        let comment12 = Comment(id: 6, commentOwner: "James", commentText: "haha")
        let comment13 = Comment(id: 6, commentOwner: "James", commentText: "haha This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing")
        let comment14 = Comment(id: 6, commentOwner: "James", commentText: "haha This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing This is amazing")

        
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
