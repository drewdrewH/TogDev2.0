//
//  RoundButton.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/23/20.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderWidth = 1/UIScreen.main.nativeScale
        layer.borderColor = UIColor.purple.cgColor
        layer.cornerRadius = frame.height/2
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.borderColor = tintColor.cgColor
    }
    
}

class HighlightedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(white: 1, alpha: 0.2) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
}


class SFSymbolsIconButton: UIButton {
    @IBInspectable var pointSize:CGFloat = 30.0

    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: pointSize)
            setPreferredSymbolConfiguration(config, forImageIn: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
}
