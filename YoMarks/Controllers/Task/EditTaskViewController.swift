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
    let currentUser: User?
    weak var delegate: UpdatingTaskProtocol?
    
    var titleTrans = ""
    var descriptionTrans = ""
    
    // MARK: UI-components
    private let titleLabel = UILabel(text: "Heading", textColor: .black, font: FontSetup.bold(size: 17))
    private let descriptionLabel = UILabel(text: "Description", textColor: .black, font: FontSetup.bold(size: 17))
    private let footTitleLabel = UILabel(text: "Enter the name of the task. It will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    private let footDescriptionLabel = UILabel(text: "Enter a description of the task. Part of the description will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    
    private let titleTextField = UITextField(placeholder: "", isSecure: false)
    private let descriptionTextField = UITextField(placeholder: "", isSecure: false)
    
    private let saveButton = UIButton(titleText: "Save", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    
    // MARK: Custom Initializer
    init?(currentUser: User?) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init()
    }
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Editing a task"
        setupConstraints()
        saveButton.addTarget(self, action: #selector(saveEditTask), for: .touchUpInside)
    }
    
    // MARK: Lifecycle viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleTextField.text = titleTrans
        descriptionTextField.text = descriptionTrans
    }
    
    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup target and @objc functions
extension EditTaskViewController {
    @objc private func saveEditTask() {
        guard titleTextField.text != "" else {
            print("The header field is empty")
            return
        }
        delegate?.updatingTask(title: titleTextField.text!, description: descriptionTextField.text!)
    }
}

// MARK: - Setting up constraints and auto layout
extension EditTaskViewController {
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
