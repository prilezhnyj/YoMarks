//
//  UIStackView.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], distribution: UIStackView.Distribution, axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .leading) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.distribution = distribution
        self.axis = axis
        self.spacing = spacing
        self.alignment = .fill
        self.contentHuggingPriority(for: .horizontal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
