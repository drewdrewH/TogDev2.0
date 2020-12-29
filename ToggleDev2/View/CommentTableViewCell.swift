//
//  CommentTableViewCell.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/28/20.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    //MARK: - IB Outlets
    @IBOutlet weak var commentLabel: UILabel!
    
    //MARK: - cell life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - configuration
    func configure(with model: OGComment) {
        let boldText = model.commentOwner
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 1))]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)

        let normalText = " \(model.commentText)"
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(normalString)
        commentLabel.attributedText = attributedString
    }

}
