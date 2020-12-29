//
//  postDataModel.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/25/20.
//

import Foundation
struct OGPost: Identifiable, Hashable {
    var id: Int
    let postOwner: String
    let caption: String
    let numberOfLikes: Int
    let videoURL: String
}

class PostViewModel: ObservableObject {
    @Published var posts = [OGPost]()
    
    //here we call API to get posts data, for now it's hard coded. The Post() struct is created under Model section
    init () {
        
        let post1 = OGPost(id: 0, postOwner: "Walid Rafei", caption: "This is awesome", numberOfLikes: 10, videoURL:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")
        let post2 = OGPost(id: 1, postOwner: "Andrew", caption: "Great News", numberOfLikes: 9, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        let post3 = OGPost(id: 2, postOwner: "James", caption: "I had so much fun", numberOfLikes: 15, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")
        let post4 = OGPost(id: 3, postOwner: "Furqan Ahmad", caption: "This is awesome https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8 https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8 https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8 https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", numberOfLikes: 10, videoURL:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
        let post5 = OGPost(id: 4, postOwner: "Anthony Curri", caption: "Great News", numberOfLikes: 9, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")
        let post6 = OGPost(id: 5, postOwner: "Joe Jhons", caption: "I had so much fun", numberOfLikes: 15, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")
        
        let post7 = OGPost(id: 6, postOwner: "Walid Rafei", caption: "This is awesome", numberOfLikes: 10, videoURL:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")
        let post8 = OGPost(id: 7, postOwner: "Andrew", caption: "Great News", numberOfLikes: 9, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")
        let post9 = OGPost(id: 8, postOwner: "James", caption: "I had so much fun", numberOfLikes: 15, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")
        let post10 = OGPost(id: 9, postOwner: "Furqan Ahmad", caption: "This is awesome https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8 https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8 https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8 https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8", numberOfLikes: 10, videoURL:"http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4")
        let post11 = OGPost(id: 10, postOwner: "Anthony Curri", caption: "Great News", numberOfLikes: 9, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4")
        let post12 = OGPost(id: 11, postOwner: "Joe Jhons", caption: "I had so much fun", numberOfLikes: 15, videoURL: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4")

        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        posts.append(post4)
        posts.append(post5)
        posts.append(post6)
        posts.append(post7)
        posts.append(post8)
        posts.append(post9)
        posts.append(post10)
        posts.append(post11)
        posts.append(post12)
    }
}
