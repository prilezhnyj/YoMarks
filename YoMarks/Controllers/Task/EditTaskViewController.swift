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
    
    private var contentViewSize: CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private var user: User
    private var task = TaskModel(title: "", description: "", id: "")
    
    // MARK: UI-components
    private let titleLabel = UILabel(text: "Heading", textColor: ColorSetup.black(), font: FontSetup.bold(size: 17))
    private let descriptionLabel = UILabel(text: "Description", textColor: ColorSetup.black(), font: FontSetup.bold(size: 17))
    private let footTitleLabel = UILabel(text: "Enter the name of the task. It will be displayed on the main screen.", textColor: ColorSetup.black(), font: FontSetup.regular(size: 13))
    private let footDescriptionLabel = UILabel(text: "Enter a description of the task. Part of the description will be displayed on the main screen.", textColor: ColorSetup.black(), font: FontSetup.regular(size: 13))

    private let titleTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    private let descriptionTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    
    private let saveButton = UIButton(titleText: "Save", titleFont: FontSetup.bold(size: 17), titleColor: ColorSetup.black(), backgroundColor: ColorSetup.green(), isBorder: false, cornerRadius: 15, isShadow: true, shadowColor: ColorSetup.purpleDark())
    private let deleteButton = UIButton(image: SystemImage.trash(), colorImage: ColorSetup.orange(), backgroundColor: ColorSetup.white(), isBorder: true, cornerRadius: 15, isShadow: true, borderColor: ColorSetup.orange(), shadowColor: ColorSetup.orange())
    
    private lazy var bgScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = ColorSetup.white()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = contentViewSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSetup.white()
        view.frame.size = contentViewSize
        return view
    }()
    
    // MARK: Custom Initializer
    init(user: User, task: TaskModel) {
        self.user = user
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.white()
        title = "✍🏻 Editing a task"
        setupConstraints()
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorSetup.purpleDark()]
        navigationController?.navigationBar.tintColor = ColorSetup.purpleDark()
        
        titleTextField.textField.text = task.title
        descriptionTextField.textField.text = task.description
        
        saveButton.addTarget(self, action: #selector(saveEditTask), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteTask), for: .touchUpInside)
        
        registerNotificationKeyboard()
        
        titleTextField.textField.delegate = self
        descriptionTextField.textField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        conteinerView.addGestureRecognizer(tapGesture)
    }

    // MARK: Required initializer
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        removeNotificationKeyboard()
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
    
    @objc private func tapGestureAction() {
        titleTextField.textField.resignFirstResponder()
        descriptionTextField.textField.resignFirstResponder()
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        bgScrollView.contentInset = UIEdgeInsets.zero
    }
    
    @objc private func keyboardHide() {
        bgScrollView.contentInset = UIEdgeInsets.zero
    }
}

// MARK: - UITextFieldDelegate
extension EditTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - KeyboardWillShowNotification & KeyboardWillHideNotification
extension EditTaskViewController {
    private func registerNotificationKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeNotificationKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Setting up constraints and auto layout
extension EditTaskViewController {
    private func setupConstraints() {
        view.addSubview(bgScrollView)
        bgScrollView.addSubview(conteinerView)
        
        conteinerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: conteinerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(titleTextField)
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        conteinerView.addSubview(footTitleLabel)
        NSLayoutConstraint.activate([
            footTitleLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            footTitleLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            footTitleLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: footTitleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(descriptionTextField)
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 16),
            descriptionTextField.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -16),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 50)])
        
        conteinerView.addSubview(footDescriptionLabel)
        NSLayoutConstraint.activate([
            footDescriptionLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 4),
            footDescriptionLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            footDescriptionLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])

        let buttonSV = UIStackView(arrangedSubviews: [saveButton, deleteButton], distribution: .fill, axis: .horizontal, spacing: 32)
        deleteButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        conteinerView.addSubview(buttonSV)
        NSLayoutConstraint.activate([
            buttonSV.topAnchor.constraint(equalTo: footDescriptionLabel.bottomAnchor, constant: 40),
            buttonSV.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            buttonSV.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32),
            buttonSV.heightAnchor.constraint(equalToConstant: 48)])
    }
}
