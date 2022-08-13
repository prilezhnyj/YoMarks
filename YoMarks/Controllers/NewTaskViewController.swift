//
//  DescriptionTaskViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 12.08.2022.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    weak var delegate: SaveTaskProtocol?
    
    // MARK: UI-components
    private let titleLabel = UILabel(text: "Heading", textColor: .black, font: FontSetup.bold(size: 17))
    private let descriptionLabel = UILabel(text: "Description", textColor: .black, font: FontSetup.bold(size: 17))
    private let footTitleLabel = UILabel(text: "Enter the name of the task. It will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    private let footDescriptionLabel = UILabel(text: "Enter a description of the task. Part of the description will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    
    private let titleTextField = UITextField(placeholder: "", isSecure: false)
    private let descriptionTextField = UITextField(placeholder: "", isSecure: false)
    
    private let saveButton = UIButton(titleText: "Save", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add a new task"
        setupConstraints()
        saveButton.addTarget(self, action: #selector(saveNewTask), for: .touchUpInside)
    }
    
    // MARK: Lifecycle viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.text? = ""
        descriptionTextField.text = ""
    }
}

// MARK: - Setup target and @objc functions
extension NewTaskViewController {
    @objc private func saveNewTask() {
        guard titleTextField.text != "" else {
            print("The header field is empty")
            return
        }
        dismiss(animated: true) {
            self.delegate?.saveTask(title: self.titleTextField.text!, description: self.descriptionTextField.text!)
        }
    }
}

// MARK: - Setting up constraints and auto layout
extension NewTaskViewController {
    private func setupConstraints() {
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, titleTextField, footTitleLabel], distribution: .equalSpacing, axis: .vertical, spacing: 5)
        let descriptionStackView = UIStackView(arrangedSubviews: [descriptionLabel, descriptionTextField, footDescriptionLabel], distribution: .equalSpacing, axis: .vertical, spacing: 5)
        let fullStackView = UIStackView(arrangedSubviews: [titleStackView, descriptionStackView], distribution: .equalSpacing, axis: .vertical, spacing: 20)
        
        view.addSubview(fullStackView)
        NSLayoutConstraint.activate([
            fullStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            fullStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fullStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)])
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: fullStackView.bottomAnchor, constant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 256),
            saveButton.heightAnchor.constraint(equalToConstant: 48)])
    }
}
