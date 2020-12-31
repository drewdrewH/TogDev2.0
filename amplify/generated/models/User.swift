// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var name: String
  public var posts: List<Post>?
  public var comments: List<Comment>?
  
  public init(id: String = UUID().uuidString,
      name: String,
      posts: List<Post>? = [],
      comments: List<Comment>? = []) {
      self.id = id
      self.name = name
      self.posts = posts
      self.comments = comments
  }
}