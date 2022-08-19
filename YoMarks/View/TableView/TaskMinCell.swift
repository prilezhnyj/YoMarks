//
//  TaskMinCell.swift
//  YoMarks
//
//  Created by Максим Боталов on 11.08.2022.
//

import UIKit

class TaskMinCell: UITableViewCell {
    
    // MARK: Property
    static let cellID = "TaskMinCell"
    
    // MARK: Cell UI-components
    private let titleLabel = UILabel(text: "", textColor: ColorSetup.white(), font: FontSetup.bold(size: 17))
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSetup.white()
        view.layer.borderWidth = 2
        view.layer.borderColor = ColorSetup.white().cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let customBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSetup.purpleDark()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: Initializer cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        setupConstraints()
        
        let selectView = UIView()
        selectView.backgroundColor = ColorSetup.white()
        self.selectedBackgroundView = selectView
    }
    
     // MARK: layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        customBackgroundView.layer.cornerRadius = 15
        customBackgroundView.clipsToBounds = true
        borderView.layer.cornerRadius = 6
        borderView.clipsToBounds = true
    }
    
    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(task: TaskModel) {
        titleLabel.text = task.title
    }
}

// MARK: - Setting up constraints and auto layout
extension TaskMinCell {
    private func setupConstraints() {
        self.addSubview(customBackgroundView)
        NSLayoutConstraint.activate([
            customBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            customBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            customBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            customBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)])
        
        customBackgroundView.addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 16),
            borderView.leadingAnchor.constraint(equalTo: customBackgroundView.leadingAnchor, constant: 16),
            borderView.widthAnchor.constraint(equalToConstant: 18),
            borderView.heightAnchor.constraint(equalToConstant: 18)])

        customBackgroundView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customBackgroundView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: customBackgroundView.trailingAnchor, constant: -16)])
    }
}
