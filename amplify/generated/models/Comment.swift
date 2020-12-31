// swiftlint:disable all
import Amplify
import Foundation

public struct Comment: Model {
  public let id: String
  public var content: String
  public var owner: User
  public var post: Post?
  
  public init(id: String = UUID().uuidString,
      content: String,
      owner: User,
      post: Post? = nil) {
      self.id = id
      self.content = content
      self.owner = owner
      self.post = post
  }
}