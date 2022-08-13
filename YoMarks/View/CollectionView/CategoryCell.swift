//
//  CategoryCell.swift
//  YoMarks
//
//  Created by Максим Боталов on 12.08.2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: Property
    static let cellID = "CategoryCell"
    
    // MARK: Cell UI-components
    private let titleLabel = UILabel(text: "🎉", textColor: .black, alignment: .center, font: FontSetup.bold(size: 20))
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initializer cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        customBackgroundView.layer.cornerRadius = self.frame.height / 2
        customBackgroundView.clipsToBounds = true
    }
    
    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setting up constraints and auto layout
extension CategoryCell {
    private func setupConstraints() {
        self.addSubview(customBackgroundView)
        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            customBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            customBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
        
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)])
    }
}
