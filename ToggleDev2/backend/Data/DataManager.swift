//
//  DataManager.swift
//  ToggleDev2
//
//  Created by James McDougall on 12/30/20.
//

import Foundation
import Amplify
import AmplifyPlugins

class DataManager {
    
    /*
     Get a list of all the posts in the database.
     completionHandler:@escaping([Post]) ->[Post]
     */
    func getAllPosts(completion: ([Post]) -> ()) {
        Amplify.DataStore.query(Post.self) { result in
            switch(result) {
            case .success(let posts):
                print("Successfully queried \(posts.count) posts in Datastore.")
                completion(posts)
            case .failure(let error):
                print("Could not query DataStore: \(error)")
            }
        }
    }
    
    /*
     Create the given post
     */
    func createPost(post: Post) {
        Amplify.DataStore.save(post) { result in
            switch result {
            case .success:
                print("Post saved successfully!")
            case .failure(let error):
                print("Error saving post \(error)")
            }
            
        }
    }
    
    /*
     Mostly for debugging, get all posts from the post table in the database.
     */
    func getAllComments(completion:@escaping ([Comment]) -> ()) {
        Amplify.DataStore.query(Comment.self) { result in
            switch result {
            case .success(let comments):
                print("Successfully retrieved all comments: \(comments)")
                completion(comments)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        }
        
    }
    
    func updatePost(post: Post, list :List<Comment>){
        if list.isEmpty{
            print("EMPTY LIST MOTHERFUCKER!!!!!!!!!!!!!!!!")
        }
        Amplify.DataStore.save(post) {result in
            switch result {
            case .success:
                print("Updated the existing post with \(list)")
            case .failure(let error):
                print("Error updating post - \(error.localizedDescription)")
            }
        }
        
    }
    
    /*
     Get the comments associated with the post
     */
    func getPostComments(post: Post, completion:@escaping ([Comment]) -> ()) {
        print(" THIS IS POST QUERY \(Comment.CodingKeys.post)")
        Amplify.DataStore.query(Comment.self, where: Comment.CodingKeys.post == post.id) { result in
            switch result {
            case .success(let comment):
                print("Successfully retrieved comments: \(comment)")
                completion(comment)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        }
    }
    
    
    
    
    /*
     Create a comment from a proper comment object
     */
    func createComment(comment: Comment, post:Post, comments: [Comment] ) {
        var commentsList : [Comment] = comments
        Amplify.DataStore.save(comment) { result in
            switch result {
            case .success:
                commentsList.append(comment)
                self.updatePost(post: post, list:List(commentsList))
                print("Comment saved successfully!")
            case .failure(let error):
                print("Error saving Comment \(error)")
            }
        }
    }
    
    /*
     Create the given user object
     */
    func createUser(user: User) {
        Amplify.DataStore.save(user) { result in
            switch result {
            case .success:
                print("Post saved successfully!")
            case .failure(let error):
                print("Error saving post \(error)")
            }
        }
    }
    
    /*
     Get the user associated with the given username.
     */
    func getUser(username: String, completion:@escaping ([User]) -> ()) {
        print("Getting user \(username)")
        let predicate = User.keys.name == username
        Amplify.DataStore.query(User.self, where: predicate) { result in
            switch result {
            case .success(let user):
                print("Retrieved users \(user) with username: \(username)")
                completion(user)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        }
    }
    
    /*
     Upload the given filename key. Assumes the file is in the document root of the application.
     See FileManager.default.urls(for: .documentDirecotyr, in: .userDomainMask) line.
     */
    func uploadFile(fileKey: String) {
        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileKey)
        Amplify.Storage.uploadFile(
            key: fileKey,
            local: filename,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { event in
                switch event {
                case let .success(data):
                    print("Completed Upload: \(data)")
                case let .failure(storageError):
                    print("Error: Upload")
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                }
            }
        )
    }
    
    
    func clearLocalData() {
        Amplify.DataStore.clear { result in
            switch result {
            case .success:
                print("DataStore cleared")
            case .failure(let error):
                print("Error clearing DataStore: \(error)")
            }
        }
    }
    
    
    func getURL(postId: String, completion:@escaping (URL) -> ()) {
        Amplify.Storage.getURL(key: "\(postId).mp4") { event in
            switch event {
            case let .success(url):
                completion(url)
            case let .failure(storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }

    }
}
