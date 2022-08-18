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

    private let titleTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    private let descriptionTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    
    private let saveButton = UIButton(titleText: "Save", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    private let closeButton = UIButton(image: SystemImage.close(), colorImage: .black, backgroundColor: ColorSetup.background(), isBorder: true, cornerRadius: 0, isShadow: true)
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.background()
        title = "🎉 New task"
        setupConstraints()
        
        saveButton.addTarget(self, action: #selector(saveNewTask), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
    }
    
    // MARK: Lifecycle viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.textField.text? = ""
        descriptionTextField.textField.text = ""
    }
    
    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.clipsToBounds = true
        closeButton.layer.cornerRadius = closeButton.frame.height / 2
        closeButton.clipsToBounds = true
    }
}

// MARK: - Setup target and @objc functions
extension NewTaskViewController {
    @objc private func saveNewTask() {
        guard titleTextField.textField.text != "" else {
            print("The header field is empty")
            return
        }
        dismiss(animated: true) {
            self.delegate?.saveTask(title: self.titleTextField.textField.text!, description: self.descriptionTextField.textField.text!)
        }
    }
    
    @objc private func closeViewController() {
        dismiss(animated: true)
    }
}

// MARK: - Setting up constraints and auto layout
extension NewTaskViewController {
    private func setupConstraints() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(footTitleLabel)
        NSLayoutConstraint.activate([
            footTitleLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            footTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            footTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: footTitleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])
        
        view.addSubview(descriptionTextField)
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        view.addSubview(footDescriptionLabel)
        NSLayoutConstraint.activate([
            footDescriptionLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 4),
            footDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            footDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)])

        let buttonSV = UIStackView(arrangedSubviews: [saveButton, closeButton], distribution: .fill, axis: .horizontal, spacing: 32)
        closeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        view.addSubview(buttonSV)
        NSLayoutConstraint.activate([
            buttonSV.topAnchor.constraint(equalTo: footDescriptionLabel.bottomAnchor, constant: 40),
            buttonSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buttonSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            buttonSV.heightAnchor.constraint(equalToConstant: 48)])
    }
}
