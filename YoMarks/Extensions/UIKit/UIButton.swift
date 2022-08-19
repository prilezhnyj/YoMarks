//
//  UIButton.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

extension UIButton {
    convenience init(titleText: String, titleFont: UIFont, titleColor: UIColor, backgroundColor: UIColor, isBorder: Bool, cornerRadius: CGFloat, isShadow: Bool, borderColor: UIColor = .black, shadowColor: UIColor = .black) {
        self.init(type: .system)
        self.setTitle(titleText, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isBorder == true {
            self.layer.borderWidth = 2
            self.layer.borderColor = borderColor.cgColor
        }
        
        if isShadow == true {
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 10
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
        }
    }
    
    convenience init(image: UIImage, colorImage: UIColor, backgroundColor: UIColor, isBorder: Bool, cornerRadius: CGFloat, isShadow: Bool, borderColor: UIColor = .black, shadowColor: UIColor = .black) {
        self.init(type: .system)
        self.setImage(image, for: .normal)
        self.tintColor = colorImage
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isBorder == true {
            self.layer.borderWidth = 2
            self.layer.borderColor = borderColor.cgColor
        }
        
        if isShadow == true {
            self.layer.shadowColor = shadowColor.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 10
            self.layer.shadowOffset = CGSize(width: 2, height: 2)
        }
    }
}
