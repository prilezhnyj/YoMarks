//
//  TaskCell.swift
//  YoMarks
//
//  Created by Максим Боталов on 11.08.2022.
//

import UIKit

class TaskMaxCell: UITableViewCell {
    
    // MARK: Property
    static let cellID = "TaskMaxCell"
    
    // MARK: Cell UI-components
    let titleLabel = UILabel(text: "Heading", textColor: .black, font: FontSetup.bold(size: 20))
    private let subtitleLabel = UILabel(text: "Description of the task. Description of the task. Description of the task. Description of the task. Description of the task.", textColor: .black, font: FontSetup.regular(size: 14), numberOfLines: 2)
    
    private let markButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.black.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initializer cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupConstraints()
        
        customBackgroundView.bottomAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 13).isActive = true
    }
    
    // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        customBackgroundView.layer.cornerRadius = 20
        customBackgroundView.clipsToBounds = true
        markButton.layer.cornerRadius = 6
        markButton.clipsToBounds = true
    }
    
    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(task: TaskModel) {
        titleLabel.text = task.title
        subtitleLabel.text = task.description
    }
}

// MARK: - Setting up constraints and auto layout
extension TaskMaxCell {
    private func setupConstraints() {
        self.addSubview(customBackgroundView)
        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            customBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            customBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            customBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)])
        
        customBackgroundView.addSubview(markButton)
        NSLayoutConstraint.activate([
            markButton.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 16),
            markButton.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 16),
            markButton.widthAnchor.constraint(equalToConstant: 18),
            markButton.heightAnchor.constraint(equalToConstant: 18)])

        customBackgroundView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            titleLabel.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: markButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -16)])
        
        customBackgroundView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalToConstant: 34)])
    }
}
