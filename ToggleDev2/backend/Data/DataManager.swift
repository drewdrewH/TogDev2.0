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
     Mostly for debugging, get all posts from the post table in the database.
     */
    func getAllComments(completion:@escaping ([Comment]) -> ()) {
        Amplify.API.query(request: .list(Comment.self)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let comments):
                    print("Successfully retrieved all comments: \(comments)")
                    completion(comments)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
            }
        }
        
    }
    
    func getPostComments(post: Post, completion:@escaping (List<Comment>?) -> ()) {
        Amplify.API.query(request: .get(Post.self, byId: post.id)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let post):
                    guard let post = post else {
                        print("Could not find post")
                        return
                    }
                    print("Successfully retrieved post: \(post)")
                    completion(post.comments)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
            }
        }
    }
    
    
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
        Amplify.API.query(request: .list(User.self, where: predicate)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Retrieved users \(user) with username: \(username)")
                    completion(user)
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
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
}
