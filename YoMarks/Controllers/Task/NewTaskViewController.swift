//
//  DescriptionTaskViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 12.08.2022.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    weak var delegate: SaveTaskProtocol?
    
    private var contentViewSize: CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: UI-components
    private let titleLabel = UILabel(text: "Heading", textColor: .black, font: FontSetup.bold(size: 17))
    private let descriptionLabel = UILabel(text: "Description", textColor: .black, font: FontSetup.bold(size: 17))
    private let footTitleLabel = UILabel(text: "Enter the name of the task. It will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))
    private let footDescriptionLabel = UILabel(text: "Enter a description of the task. Part of the description will be displayed on the main screen.", textColor: .gray, font: FontSetup.regular(size: 13))

    private let titleTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    private let descriptionTextField = CustomTextField(bgColor: .white, keyboardType: .default, isSecure: false)
    
    private let saveButton = UIButton(titleText: "Save", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    private let closeButton = UIButton(image: SystemImage.close(), colorImage: .black, backgroundColor: ColorSetup.background(), isBorder: true, cornerRadius: 0, isShadow: true)
    
    private lazy var bgScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = ColorSetup.background()
        scrollView.contentSize = contentViewSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSetup.background()
        view.frame.size = contentViewSize
        return view
    }()
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.background()
        title = "🎉 New task"
        setupConstraints()
        
        saveButton.addTarget(self, action: #selector(saveNewTask), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeViewController), for: .touchUpInside)
        
        registerNotificationKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        conteinerView.addGestureRecognizer(tapGesture)
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
    
    deinit {
        removeNotificationKeyboard()
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

// MARK: - KeyboardWillShowNotification & KeyboardWillHideNotification
extension NewTaskViewController {
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
extension NewTaskViewController {
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

        let buttonSV = UIStackView(arrangedSubviews: [saveButton, closeButton], distribution: .fill, axis: .horizontal, spacing: 32)
        closeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        conteinerView.addSubview(buttonSV)
        NSLayoutConstraint.activate([
            buttonSV.topAnchor.constraint(equalTo: footDescriptionLabel.bottomAnchor, constant: 40),
            buttonSV.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            buttonSV.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32),
            buttonSV.heightAnchor.constraint(equalToConstant: 48)])
    }
}
