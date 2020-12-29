//
//  customTextField.swift
//  ToggleDev2
//
//  Created by Walid Rafei on 12/23/20.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftIcon(_ image: UIImage) {
       let iconView = UIImageView(frame:
                      CGRect(x: 0, y: 5, width: 20, height: 20))
       iconView.image = image
       let iconContainerView: UIView = UIView(frame:
                      CGRect(x: 20, y: 0, width: 30, height: 30))
       iconContainerView.addSubview(iconView)
       leftView = iconContainerView
       leftViewMode = .always
    }
    
    func setPlaceHolder(for textField: UITextField, with placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.5)])
    }
}
