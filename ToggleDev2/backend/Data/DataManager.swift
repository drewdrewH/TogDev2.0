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
    func queryPosts(completion: ([Post]) -> ()) {
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
    
    func createPost(postOwner: User, caption: String, numberOfLikes: Int ) {
        let post: Post = Post(postOwner: postOwner,
                              caption: caption,
                              numberOfLikes:
                                numberOfLikes,
                              status: PostStatus.active)
        createPost(post: post)
    }
    
    func createPost(post: Post) {
        Amplify.API.mutate(request: .create(post)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let post):
                    print("Successfully created post: \(post)")
                case .failure(let graphQLError):
                    print("Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError):
                print("Failed to create a post", apiError)
            }
        }
    }
    
    func createUser(user: User) {
        Amplify.API.mutate(request: .create(user)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let user):
                    print("Successfully created user: \(user)")
                case .failure(let graphQLError):
                    print("Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError):
                print("Failed to create a post", apiError)
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
    
    /*
     Upload raw data to amplify. Probably won't ever be used in favor of file upload.
     */
    func uploadData(key: String, data: Data) {
        Amplify
            .Storage
            .uploadData(key: "ExampleKey", data: data,
                        progressListener: { progress in
                            print("Progress: \(progress)")
                        }, resultListener: { (event) in
                            switch event {
                            case .success(let data):
                                print("Completed: \(data)")
                            case .failure(let storageError):
                                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                            }
                        })
    }
    
    /*
     Get the S3 URL of the fileKey if it exists, or the error image if it doesn't exist.
     */
    func getURL(fileKey: String, completionHandler:@escaping(URL) -> ()) {
        self.getS3URL(fileKey: fileKey) { url in
            // convert the url to string, or if error send the error image.
            if url.absoluteString != "" {
                completionHandler(url)
            }
        }
    }
    
    func getS3URL(fileKey: String, completionHandler:@escaping(URL) -> ()) {
        Amplify.Storage.getURL(key: fileKey) { event in
            switch event {
            case let .success(url):
                completionHandler(url)
            case let .failure(storageError):
                print("S3URL: Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
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
