//
//  UICollectionView.swift
//  YoMarks
//
//  Created by Максим Боталов on 12.08.2022.
//

import UIKit

extension UICollectionView {
    convenience init(backgroundColor: UIColor) {
        self.init()
        self.backgroundColor = backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
