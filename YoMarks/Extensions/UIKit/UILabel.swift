//
//  UILabel.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String, textColor: UIColor, alignment: NSTextAlignment = .left, font: UIFont) {
        self.init()
        self.text = text
        self.numberOfLines = 0
        self.textColor = textColor
        self.textAlignment = alignment
        self.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
