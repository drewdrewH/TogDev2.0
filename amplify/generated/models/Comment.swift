// swiftlint:disable all
import Amplify
import Foundation

public struct Comment: Model {
  public let id: String
  public var post: Post?
  public var content: String
  
  public init(id: String = UUID().uuidString,
      post: Post? = nil,
      content: String) {
      self.id = id
      self.post = post
      self.content = content
  }
}