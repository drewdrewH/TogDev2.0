// swiftlint:disable all
import Amplify
import Foundation

extension Comment {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case post
    case content
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let comment = Comment.keys
    
    model.pluralName = "Comments"
    
    model.fields(
      .id(),
      .belongsTo(comment.post, is: .optional, ofType: Post.self, targetName: "postID"),
      .field(comment.content, is: .required, ofType: .string)
    )
    }
}