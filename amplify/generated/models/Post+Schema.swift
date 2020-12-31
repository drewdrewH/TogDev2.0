// swiftlint:disable all
import Amplify
import Foundation

extension Post {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case postOwner
    case caption
    case numberOfLikes
    case status
    case comments
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let post = Post.keys
    
    model.pluralName = "Posts"
    
    model.fields(
      .id(),
      .belongsTo(post.postOwner, is: .required, ofType: User.self, targetName: "postPostOwnerId"),
      .field(post.caption, is: .required, ofType: .string),
      .field(post.numberOfLikes, is: .required, ofType: .int),
      .field(post.status, is: .required, ofType: .enum(type: PostStatus.self)),
      .hasMany(post.comments, is: .optional, ofType: Comment.self, associatedWith: Comment.keys.post)
    )
    }
}