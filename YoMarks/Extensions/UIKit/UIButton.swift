//
//  UIButton.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

extension UIButton {
    convenience init(titleText: String, titleFont: UIFont, titleColor: UIColor, backgroundColor: UIColor, isBorder: Bool, cornerRadius: CGFloat, isShadow: Bool) {
        self.init(type: .system)
        self.setTitle(titleText, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = titleFont
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isBorder == true {
            self.layer.borderWidth = 1.5
            self.layer.borderColor = UIColor.black.cgColor
        }
        
        if isShadow == true {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.1
            self.layer.shadowRadius = 5
            self.layer.shadowOffset = CGSize(width: 4, height: 4)
        }
    }
}
