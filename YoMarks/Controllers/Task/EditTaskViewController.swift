//
//  EditTaskViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 14.08.2022.
//

import UIKit
import FirebaseAuth

class EditTaskViewController: UIViewController {
    
    // MARK: Property
    weak var delegate: UpdatingTaskProtocol?
    
    private var user: User
    private var task = TaskModel(title: "", description: "", id: "")
    
    // MARK: UI-components
    private let titleLabel = UILabel(text: "Heading", textColor: .black, font: FontSetup.bold(size: 17))
    private let descriptionLabel = UILabel(text: "Description", textColor: .black, font: FontSetup.bold(size: 17))
    private let footTitleLabel = UILabel(text: "Enter the name of the task. It will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    private let footDescriptionLabel = UILabel(text: "Enter a description of the task. Part of the description will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    
    private let titleTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    private let descriptionTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    
    private let saveButton = UIButton(titleText: "Save", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    private let deleteButton = UIButton(image: SystemImage.trash(), colorImage: .black, backgroundColor: ColorSetup.background(), isBorder: true, cornerRadius: 0, isShadow: true)
    
    // MARK: Custom Initializer
    init(user: User, task: TaskModel) {
        self.user = user
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.background()
        title = "✍🏻 Editing a task"
        setupConstraints()
        
        titleTextField.textField.text = task.title
        descriptionTextField.textField.text = task.description
        
        saveButton.addTarget(self, action: #selector(saveEditTask), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
    }
    
    // MARK: viewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.layer.cornerRadius = saveButton.frame.height / 2
        saveButton.clipsToBounds = true
        deleteButton.layer.cornerRadius = deleteButton.frame.height / 2
        deleteButton.clipsToBounds = true
    }

    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup target and @objc functions
extension EditTaskViewController {
    @objc private func saveEditTask() {
        guard titleTextField.textField.text != "" else {
            print("The header field is empty")
            return
        }
        FirestoreServices.shared.updatingData(title: titleTextField.textField.text!, description: descriptionTextField.textField.text!, user: user, task: task) { result in
            switch result {
                
            case .success(let data):
                print(data)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func deleteTask() {
        FirestoreServices.shared.deleteData(user: user, task: task) { chek in
            if chek == true {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: - Setting up constraints and auto layout
extension EditTaskViewController {
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

        let buttonSV = UIStackView(arrangedSubviews: [saveButton, deleteButton], distribution: .fill, axis: .horizontal, spacing: 32)
        deleteButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        view.addSubview(buttonSV)
        NSLayoutConstraint.activate([
            buttonSV.topAnchor.constraint(equalTo: footDescriptionLabel.bottomAnchor, constant: 40),
            buttonSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            buttonSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            buttonSV.heightAnchor.constraint(equalToConstant: 48)])
    }
}
