// swiftlint:disable all
import Amplify
import Foundation

extension Comment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case content
    case owner
    case post
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let comment = Comment.keys
    
    model.pluralName = "Comments"
    
    model.fields(
      .id(),
      .field(comment.content, is: .required, ofType: .string),
      .belongsTo(comment.owner, is: .required, ofType: User.self, targetName: "commentOwnerId"),
      .belongsTo(comment.post, is: .optional, ofType: Post.self, targetName: "commentPostId")
    )
    }
}