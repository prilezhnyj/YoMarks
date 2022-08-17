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
    private let greetingLabel = UILabel(text: "Welcome", textColor: .black, font: FontSetup.bold(size: 46))
    private let descriptionLabel = UILabel(text: "These are applications for keeping track of your cases and tasks. With him, you will never miss an important meeting or forget to do any business.", textColor: .black, font: FontSetup.medium(size: 16))
    
    private let emailTextField = UITextField(placeholder: "Your email", isSecure: false, initialLetter: .none)
    private let passwordTextField = UITextField(placeholder: "Your password", isSecure: false, initialLetter: .none)
    private let repeatPasswordTextField = UITextField(placeholder: "Your password again", isSecure: false, initialLetter: .none)
    
    private let signUpButton = UIButton(titleText: "Finish registration", titleFont: FontSetup.medium(size: 16), titleColor: .white, backgroundColor: .black, isBorder: false, cornerRadius: 10, isShadow: true)
    private let signInButton = UIButton(titleText: "Have an account? Sign In", titleFont: FontSetup.medium(size: 16), titleColor: .black, backgroundColor: .white, isBorder: true, cornerRadius: 10, isShadow: true)
    private let closeButton = UIButton(image: SystemImage.arrowLeft(), colorImage: .white, backgroundColor: .black, isBorder: false, cornerRadius: 24, isShadow: true)
    
    private lazy var bgScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.contentSize = contentViewSize
        scrollView.frame = view.bounds
        return scrollView
    }()
    
    private lazy var conteinerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()
    
    // MARK: Lifecycle viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        setupTarget()
        registerNotificationKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        bgScrollView.addGestureRecognizer(tapGesture)
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
        FirebaseAuth.shared.singUp(email: emailTextField.text, password: passwordTextField.text, repeatPassword: repeatPasswordTextField.text) { result in
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
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc private func keyboardShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        bgScrollView.contentOffset = CGPoint(x: 0, y: keyboardFrame.size.height - 24)
    }
    
    @objc private func keyboardHide() {
        bgScrollView.contentOffset = CGPoint.zero
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
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -8),
            signUpButton.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.widthAnchor.constraint(equalToConstant: 256)])
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, repeatPasswordTextField], distribution: .equalSpacing, axis: .vertical, spacing: 8)
        
        conteinerView.addSubview(textFieldsStackView)
        NSLayoutConstraint.activate([
            textFieldsStackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -32),
            textFieldsStackView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            textFieldsStackView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: textFieldsStackView.topAnchor, constant: -32),
            descriptionLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            descriptionLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
        
        conteinerView.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor, constant: 32),
            greetingLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor, constant: -32)])
    }
}
