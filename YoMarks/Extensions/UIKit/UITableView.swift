//
//  UITableView.swift
//  YoMarks
//
//  Created by Максим Боталов on 12.08.2022.
//

import UIKit

extension UITableView {
    convenience init(backgroundColor: UIColor, separatorColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
        self.separatorColor = separatorColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
