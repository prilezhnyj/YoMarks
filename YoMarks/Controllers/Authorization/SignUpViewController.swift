//
//  SignUpViewController.swift
//  YoMarks
//
//  Created by Максим Боталов on 08.08.2022.
//

import UIKit

class SignUpViewController: UIViewController {
    
    weak var delegate: AuthTransitionProtocol!
    
    private var contentViewSize: CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    // MARK: UI-components
    private let greetingLabel = UILabel(text: "Welcome", textColor: ColorSetup.purpleDark(), font: FontSetup.bold(size: 34))
    private let descriptionLabel = UILabel(text: "These are applications for keeping track of your cases and tasks.", textColor: ColorSetup.black(), font: FontSetup.regular(size: 17))
    
    private let emailTextField = CustomTextFieldForEmail(keyboardType: .emailAddress, isSecure: false, placeholder: "Your email")
    private let passwordTextField = CustomTextFieldForEmail(keyboardType: .default, isSecure: false, placeholder: "Your password")
    private let repeatPasswordTextField = CustomTextFieldForEmail(keyboardType: .default, isSecure: false, placeholder: "Your password again")
    
    private let signUpButton = UIButton(titleText: "Finish registration", titleFont: FontSetup.bold(size: 17), titleColor: ColorSetup.white(), backgroundColor: ColorSetup.purpleDark(), isBorder: false, cornerRadius: 15, isShadow: true, shadowColor: ColorSetup.purpleDark())
    private let signInButton = UIButton(titleText: "Have an account? Sign In", titleFont: FontSetup.bold(size: 17), titleColor: ColorSetup.orange(), backgroundColor: ColorSetup.white(), isBorder: true, cornerRadius: 15, isShadow: true, borderColor: ColorSetup.orange(), shadowColor: ColorSetup.orange())
    private let closeButton = UIButton(image: SystemImage.arrowDown(), colorImage: ColorSetup.orange(), backgroundColor: ColorSetup.white(), isBorder: true, cornerRadius: 15, isShadow: true, borderColor: ColorSetup.orange(), shadowColor: ColorSetup.orange())
    
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
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorSetup.white()
        setupConstraints()
        setupTarget()
        registerNotificationKeyboard()
        
        emailTextField.textField.delegate = self
        passwordTextField.textField.delegate = self
        repeatPasswordTextField.textField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        conteinerView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: Lifecycle viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.textField.text = ""
        passwordTextField.textField.text = ""
        repeatPasswordTextField.textField.text = ""
    }
    
    deinit {
        removeNotificationKeyboard()
    }
}

//MARK: - Setup target and @objc functions
extension SignUpViewController {
    private func setupTarget() {
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(finishRegistration), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(pushSignInVC), for: .touchUpInside)
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true)
    }
    
    @objc private func finishRegistration() {
        FirebaseAuth.shared.singUp(email: emailTextField.textField.text, password: passwordTextField.textField.text, repeatPassword: repeatPasswordTextField.textField.text) { result in
            switch result {
            case .success(let user):
                self.showAlert(with: "Success", and: "User «\(user.email!)» has been successfully created.") {
                    self.dismiss(animated: true) {
                        self.delegate?.delegatePushTaskVC(for: user)
                    }
                }
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
    }
    
    @objc private func pushSignInVC() {
        dismiss(animated: true) {
            self.delegate.delegatePushSignInVC()
        }
    }
    
    @objc private func tapGestureAction() {
        emailTextField.textField.resignFirstResponder()
        passwordTextField.textField.resignFirstResponder()
        repeatPasswordTextField.textField.resignFirstResponder()
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        bgScrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height - 24)
        greetingLabel.isHidden = true
        descriptionLabel.isHidden = true
    }
    
    @objc private func keyboardHide() {
        bgScrollView.contentOffset = CGPoint.zero
        greetingLabel.isHidden = false
        descriptionLabel.isHidden = false
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - KeyboardWillShowNotification & KeyboardWillHideNotification
extension SignUpViewController {
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
extension SignUpViewController {
    private func setupConstraints() {
        view.addSubview(bgScrollView)
        bgScrollView.addSubview(conteinerView)
        
        conteinerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: conteinerView.safeAreaLayoutGuide.topAnchor, constant: 32),
            closeButton.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 48),
            closeButton.heightAnchor.constraint(equalToConstant: 48)])
        
        conteinerView.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.bottomAnchor.constraint(equalTo: conteinerView.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            signInButton.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 48),
            signInButton.widthAnchor.constraint(equalToConstant: 256)])
        
        conteinerView.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -16),
            signUpButton.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.widthAnchor.constraint(equalToConstant: 256)])
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, repeatPasswordTextField], distribution: .fill, axis: .vertical, spacing: 32)
        
        conteinerView.addSubview(textFieldsStackView)
        NSLayoutConstraint.activate([
            textFieldsStackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -48),
            textFieldsStackView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            textFieldsStackView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -48),
            descriptionLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),
            greetingLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
    }
}
